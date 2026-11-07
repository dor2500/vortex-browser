# ==============================================================================
# Vortex Browser - Dedicated Gecko Engine Launcher
# Boots an isolated Gecko environment with Vortex Cyber-Chrome
# ==============================================================================

$ErrorActionPreference = "Stop"

$RootDir = Split-Path -Parent $PSScriptRoot
$ProfileDir = Join-Path $RootDir ".profile"
$ChromeDir = Join-Path $ProfileDir "chrome"
$NewTabPage = (Join-Path $RootDir "src\pages\newtab\index.html").Replace("\", "/")
$NewTabUri = "file:///$NewTabPage"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "         🌪️  VORTEX BROWSER (Gecko Quantum Engine)         " -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Locate Gecko Engine Executable (Firefox / Portable Gecko)
$GeckoCandidates = @(
  "C:\Program Files\Mozilla Firefox\firefox.exe",
  "C:\Program Files (x86)\Mozilla Firefox\firefox.exe",
  "$env:LOCALAPPDATA\Mozilla Firefox\firefox.exe",
  (Get-Command firefox -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source)
)

$GeckoExe = $null
foreach ($path in $GeckoCandidates) {
  if ($path -and (Test-Path $path)) {
    $GeckoExe = $path
    break
  }
}

if (-not $GeckoExe) {
  Write-Host "❌ Error: Could not find Mozilla Firefox or Gecko engine runtime on this machine." -ForegroundColor Red
  Write-Host "Please install Firefox or download a portable Gecko engine." -ForegroundColor Yellow
  exit 1
}

Write-Host "✔️ Found Gecko Engine: $GeckoExe" -ForegroundColor Green

# 2. Setup Isolated Profile
if (-not (Test-Path $ChromeDir)) {
  New-Item -ItemType Directory -Path $ChromeDir -Force | Out-Null
}

# Sync userChrome.css and userContent.css
Copy-Item (Join-Path $RootDir "src\chrome\userChrome.css") (Join-Path $ChromeDir "userChrome.css") -Force
Copy-Item (Join-Path $RootDir "src\chrome\userContent.css") (Join-Path $ChromeDir "userContent.css") -Force

# Generate user.js with dynamic paths
$BaseUserJs = Get-Content (Join-Path $RootDir "src\config\user.js") -Raw
$DynamicPrefs = @"

// Dynamic Vortex Settings
user_pref("browser.startup.homepage", "$NewTabUri");
user_pref("browser.newtab.url", "$NewTabUri");
"@

$FinalUserJs = $BaseUserJs + "`n" + $DynamicPrefs
Set-Content -Path (Join-Path $ProfileDir "user.js") -Value $FinalUserJs -Encoding UTF8

Write-Host "✔️ Vortex Profile prepared at: $ProfileDir" -ForegroundColor Green
Write-Host "🚀 Launching Vortex Browser..." -ForegroundColor Cyan

# 3. Launch Gecko in Isolated Mode
Start-Process -FilePath $GeckoExe -ArgumentList "-no-remote", "-profile `"$ProfileDir`"", "$NewTabUri"

Write-Host "✔️ Vortex Browser running!" -ForegroundColor Green

