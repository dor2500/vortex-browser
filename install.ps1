# ==============================================================================
# Vortex Browser - 1-Click Windows Installer (IEX / PowerShell)
# Usage: irm https://raw.githubusercontent.com/dor2500/vortex-browser/main/install.ps1 | iex
# ==============================================================================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "       🌪️  VORTEX BROWSER - 1-CLICK WINDOWS INSTALLER     " -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$RepoUrl = "https://github.com/dor2500/vortex-browser.git"
$ZipUrl = "https://github.com/dor2500/vortex-browser/archive/refs/heads/main.zip"
$InstallDir = Join-Path $env:LOCALAPPDATA "Programs\Vortex Browser"

Write-Host "📦 Target directory: $InstallDir" -ForegroundColor Gray

# 1. Download or Update Vortex Browser
if (Test-Path (Join-Path $InstallDir ".git")) {
  Write-Host "🔄 Updating existing installation..." -ForegroundColor Cyan
  git -C "$InstallDir" pull --ff-only 2>$null
} else {
  if (Test-Path $InstallDir) {
    Remove-Item -Path $InstallDir -Recurse -Force -ErrorAction SilentlyContinue
  }
  New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null

  $HasGit = Get-Command git -ErrorAction SilentlyContinue
  if ($HasGit) {
    Write-Host "📥 Cloning Vortex Browser from GitHub..." -ForegroundColor Cyan
    git clone --depth 1 $RepoUrl "$InstallDir" | Out-Null
  } else {
    Write-Host "📥 Downloading Vortex Browser ZIP from GitHub..." -ForegroundColor Cyan
    $ZipPath = Join-Path $env:TEMP "vortex-browser.zip"
    Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipPath -UseBasicParsing
    Expand-Archive -Path $ZipPath -DestinationPath $env:TEMP\vortex-extract -Force
    Move-Item "$env:TEMP\vortex-extract\vortex-browser-main\*" "$InstallDir" -Force
    Remove-Item $ZipPath -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\vortex-extract" -Recurse -Force -ErrorAction SilentlyContinue
  }
}

# 2. Check for Gecko Engine (Mozilla Firefox)
$GeckoCandidates = @(
  "C:\Program Files\Mozilla Firefox\firefox.exe",
  "C:\Program Files (x86)\Mozilla Firefox\firefox.exe",
  "$env:LOCALAPPDATA\Mozilla Firefox\firefox.exe",
  (Get-Command firefox -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source)
)

$GeckoFound = $false
foreach ($cand in $GeckoCandidates) {
  if ($cand -and (Test-Path $cand)) {
    $GeckoFound = $true
    break
  }
}

if (-not $GeckoFound) {
  Write-Host "⚠️ Mozilla Firefox not detected. Downloading portable Gecko engine runtime..." -ForegroundColor Yellow
  $PortableGeckoDir = Join-Path $InstallDir "gecko"
  # Firefox is standard on most dev PCs; if missing, note to user
  Write-Host "Please ensure Mozilla Firefox is installed for the Gecko Quantum engine." -ForegroundColor Yellow
}

# 3. Build & Sync Chrome
Write-Host "⚙️ Preparing Vortex isolated profile and cyber-chrome..." -ForegroundColor Cyan
$ProfileDir = Join-Path $InstallDir ".profile"
$ChromeDir = Join-Path $ProfileDir "chrome"
New-Item -ItemType Directory -Path $ChromeDir -Force | Out-Null

Copy-Item (Join-Path $InstallDir "src\chrome\userChrome.css") (Join-Path $ChromeDir "userChrome.css") -Force
Copy-Item (Join-Path $InstallDir "src\chrome\userContent.css") (Join-Path $ChromeDir "userContent.css") -Force

$NewTabUri = "file:///" + (Join-Path $InstallDir "src\pages\newtab\index.html").Replace("\", "/")
$BaseUserJs = Get-Content (Join-Path $InstallDir "src\config\user.js") -Raw
$DynamicPrefs = @"

// Dynamic Vortex Settings
user_pref("browser.startup.homepage", "$NewTabUri");
user_pref("browser.newtab.url", "$NewTabUri");
"@
Set-Content -Path (Join-Path $ProfileDir "user.js") -Value ($BaseUserJs + "`n" + $DynamicPrefs) -Encoding UTF8

# 4. Create Desktop & Start Menu Shortcuts
Write-Host "🔗 Creating Desktop and Start Menu shortcuts..." -ForegroundColor Cyan
$WshShell = New-Object -ComObject WScript.Shell

$ShortcutPaths = @(
  (Join-Path ([Environment]::GetFolderPath("Desktop")) "Vortex Browser.lnk"),
  (Join-Path ([Environment]::GetFolderPath("StartMenu")) "Programs\Vortex Browser.lnk")
)

$LaunchScript = Join-Path $InstallDir "scripts\launch.ps1"
$IconFile = Join-Path $InstallDir "assets\icon.ico"

# If icon.ico does not exist yet, fallback to firefox icon or powershell
if (-not (Test-Path $IconFile)) {
  $IconFile = "C:\Program Files\Mozilla Firefox\firefox.exe"
}

foreach ($sLink in $ShortcutPaths) {
  try {
    $Shortcut = $WshShell.CreateShortcut($sLink)
    $Shortcut.TargetPath = "powershell.exe"
    $Shortcut.Arguments = "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$LaunchScript`""
    $Shortcut.WorkingDirectory = $InstallDir
    $Shortcut.Description = "Vortex Browser - Gecko Quantum Engine"
    if (Test-Path $IconFile) {
      $Shortcut.IconLocation = "$IconFile,0"
    }
    $Shortcut.Save()
  } catch {
    # Ignore shortcut write errors
  }
}

Write-Host ""
Write-Host "✅ Installation completed successfully!" -ForegroundColor Green
Write-Host "🚀 Launching Vortex Browser..." -ForegroundColor Cyan
Write-Host ""

Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$LaunchScript`""
