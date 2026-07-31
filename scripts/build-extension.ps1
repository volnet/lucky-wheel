param(
  [string]$Version = "1.0.0"
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$distRoot = Join-Path $repoRoot "dist"
$packageRoot = Join-Path $distRoot "extension-package"

if ((Split-Path -Parent $distRoot) -ne $repoRoot) {
  throw "Resolved dist directory is outside the repository."
}

if (Test-Path -LiteralPath $packageRoot) {
  Remove-Item -LiteralPath $packageRoot -Recurse -Force
}

New-Item -ItemType Directory -Path $packageRoot | Out-Null
New-Item -ItemType Directory -Path (Join-Path $packageRoot "config") | Out-Null
New-Item -ItemType Directory -Path (Join-Path $packageRoot "icons") | Out-Null

Copy-Item -LiteralPath (Join-Path $repoRoot "index.html") -Destination (Join-Path $packageRoot "wheel.html")
Copy-Item -LiteralPath (Join-Path $repoRoot "assets") -Destination $packageRoot -Recurse
Copy-Item -LiteralPath (Join-Path $repoRoot "config\default-config.js") -Destination (Join-Path $packageRoot "config\default-config.js")
New-Item -ItemType File -Path (Join-Path $packageRoot "config\local-config.js") -Force | Out-Null

Get-ChildItem -LiteralPath (Join-Path $repoRoot "extension") | Where-Object {
  $_.Name -ne "assets"
} | ForEach-Object {
  Copy-Item -LiteralPath $_.FullName -Destination $packageRoot -Recurse -Force
}

$manifestPath = Join-Path $packageRoot "manifest.json"
$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$manifest.version = $Version
$manifestJson = $manifest | ConvertTo-Json -Depth 20
$utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($manifestPath, $manifestJson, $utf8WithoutBom)

Add-Type -AssemblyName System.Drawing
$iconMasterPath = Join-Path $repoRoot "extension\assets\icon-liquid-glass-master.png"
$iconMaster = [System.Drawing.Image]::FromFile($iconMasterPath)
foreach ($size in @(16, 32, 48, 128)) {
  $bitmap = New-Object System.Drawing.Bitmap($size, $size)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
  $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
  $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $graphics.DrawImage($iconMaster, 0, 0, $size, $size)

  $bitmap.Save((Join-Path $packageRoot "icons\icon-$size.png"), [System.Drawing.Imaging.ImageFormat]::Png)
  $graphics.Dispose()
  $bitmap.Dispose()
}
$iconMaster.Dispose()

foreach ($browser in @("chrome", "edge")) {
  $archive = Join-Path $distRoot "lucky-wheel-$browser-v$Version.zip"
  if (Test-Path -LiteralPath $archive) {
    Remove-Item -LiteralPath $archive -Force
  }
  Compress-Archive -Path (Join-Path $packageRoot "*") -DestinationPath $archive -CompressionLevel Optimal
}

Write-Host "Built extension packages:"
Write-Host "  $(Join-Path $distRoot "lucky-wheel-chrome-v$Version.zip")"
Write-Host "  $(Join-Path $distRoot "lucky-wheel-edge-v$Version.zip")"
