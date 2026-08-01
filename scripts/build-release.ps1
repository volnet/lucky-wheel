param(
  [string]$Version = "1.0.0"
)

$ErrorActionPreference = "Stop"

if ($Version -notmatch '^\d+(\.\d+){0,3}$') {
  throw "Version must contain one to four numeric components, for example 1.0.1."
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$distRoot = Join-Path $repoRoot "dist"
$extensionPackageRoot = Join-Path $distRoot "extension-package"
$offlinePackageRoot = Join-Path $distRoot "offline-package"

if ((Split-Path -Parent $distRoot) -ne $repoRoot) {
  throw "Resolved dist directory is outside the repository."
}

function Reset-PackageDirectory {
  param([string]$Path)

  if ((Split-Path -Parent $Path) -ne $distRoot) {
    throw "Package directory is outside dist: $Path"
  }
  if (Test-Path -LiteralPath $Path) {
    Remove-Item -LiteralPath $Path -Recurse -Force
  }
  New-Item -ItemType Directory -Path $Path | Out-Null
}

function New-ReleaseArchive {
  param(
    [string]$PackageRoot,
    [string]$ArchiveName
  )

  $archivePath = Join-Path $distRoot $ArchiveName
  if ((Split-Path -Parent $archivePath) -ne $distRoot) {
    throw "Archive path is outside dist: $archivePath"
  }
  if (Test-Path -LiteralPath $archivePath) {
    Remove-Item -LiteralPath $archivePath -Force
  }
  Compress-Archive -Path (Join-Path $PackageRoot "*") -DestinationPath $archivePath -CompressionLevel Optimal
  return $archivePath
}

function Set-ConfigCacheVersion {
  param([string]$HtmlPath)

  $html = [System.IO.File]::ReadAllText($HtmlPath, [System.Text.Encoding]::UTF8)
  $html = $html.Replace(
    '__LUCKY_WHEEL_BUILD_VERSION__',
    $Version
  )
  [System.IO.File]::WriteAllText($HtmlPath, $html, $utf8WithoutBom)
}

Reset-PackageDirectory -Path $extensionPackageRoot
Reset-PackageDirectory -Path $offlinePackageRoot

# Build the shared Manifest V3 package used by both browser stores.
New-Item -ItemType Directory -Path (Join-Path $extensionPackageRoot "config") | Out-Null
New-Item -ItemType Directory -Path (Join-Path $extensionPackageRoot "icons") | Out-Null

Copy-Item -LiteralPath (Join-Path $repoRoot "index.html") -Destination (Join-Path $extensionPackageRoot "wheel.html")
Copy-Item -LiteralPath (Join-Path $repoRoot "assets") -Destination $extensionPackageRoot -Recurse
Copy-Item -LiteralPath (Join-Path $repoRoot "config\default-config.js") -Destination (Join-Path $extensionPackageRoot "config\default-config.js")
New-Item -ItemType File -Path (Join-Path $extensionPackageRoot "config\local-config.js") -Force | Out-Null

Get-ChildItem -LiteralPath (Join-Path $repoRoot "extension") | Where-Object {
  $_.Name -ne "assets"
} | ForEach-Object {
  Copy-Item -LiteralPath $_.FullName -Destination $extensionPackageRoot -Recurse -Force
}

$manifestPath = Join-Path $extensionPackageRoot "manifest.json"
$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$manifest.version = $Version
$manifestJson = $manifest | ConvertTo-Json -Depth 20
$utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($manifestPath, $manifestJson, $utf8WithoutBom)
Set-ConfigCacheVersion -HtmlPath (Join-Path $extensionPackageRoot "wheel.html")

Add-Type -AssemblyName System.Drawing
$iconMasterPath = Join-Path $repoRoot "extension\assets\icon-liquid-glass-master.png"
$iconMaster = [System.Drawing.Image]::FromFile($iconMasterPath)
try {
  foreach ($size in @(16, 32, 48, 128)) {
    $bitmap = New-Object System.Drawing.Bitmap($size, $size)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    try {
      $graphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
      $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
      $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
      $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
      $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
      $graphics.DrawImage($iconMaster, 0, 0, $size, $size)
      $bitmap.Save((Join-Path $extensionPackageRoot "icons\icon-$size.png"), [System.Drawing.Imaging.ImageFormat]::Png)
    } finally {
      $graphics.Dispose()
      $bitmap.Dispose()
    }
  }
} finally {
  $iconMaster.Dispose()
}

# Build the standalone offline HTML package.
New-Item -ItemType Directory -Path (Join-Path $offlinePackageRoot "config") | Out-Null
Copy-Item -LiteralPath (Join-Path $repoRoot "index.html") -Destination $offlinePackageRoot
Copy-Item -LiteralPath (Join-Path $repoRoot "assets") -Destination $offlinePackageRoot -Recurse
Copy-Item -LiteralPath (Join-Path $repoRoot "config\default-config.js") -Destination (Join-Path $offlinePackageRoot "config\default-config.js")
Copy-Item -LiteralPath (Join-Path $repoRoot "config\local-config.example.js") -Destination (Join-Path $offlinePackageRoot "config\local-config.example.js")
New-Item -ItemType File -Path (Join-Path $offlinePackageRoot "config\local-config.js") -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $repoRoot "README.md") -Destination $offlinePackageRoot
Copy-Item -LiteralPath (Join-Path $repoRoot "privacy") -Destination $offlinePackageRoot -Recurse
Set-ConfigCacheVersion -HtmlPath (Join-Path $offlinePackageRoot "index.html")

$archives = @(
  New-ReleaseArchive -PackageRoot $extensionPackageRoot -ArchiveName "lucky-wheel-chrome-v$Version.zip"
  New-ReleaseArchive -PackageRoot $extensionPackageRoot -ArchiveName "lucky-wheel-edge-v$Version.zip"
  New-ReleaseArchive -PackageRoot $offlinePackageRoot -ArchiveName "lucky-wheel-offline-html-v$Version.zip"
)

Write-Host "Built release packages:"
$archives | ForEach-Object { Write-Host "  $_" }
