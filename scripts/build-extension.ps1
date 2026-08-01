param(
  [string]$Version = "1.0.0"
)

# Backward-compatible entry point. New automation should call build-release.ps1.
& (Join-Path $PSScriptRoot "build-release.ps1") -Version $Version
if ($LASTEXITCODE) {
  exit $LASTEXITCODE
}
