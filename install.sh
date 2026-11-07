#!/usr/bin/env bash
# ==============================================================================
# Vortex Browser - 1-Click Installer for macOS and Linux
# Usage: curl -fsSL https://raw.githubusercontent.com/dor2500/vortex-browser/main/install.sh | bash
# ==============================================================================

set -e

echo ""
echo "=========================================================="
echo "    🌪️  VORTEX BROWSER - 1-CLICK MACOS & LINUX INSTALLER   "
echo "=========================================================="
echo ""

INSTALL_DIR="$HOME/.vortex-browser"
REPO_URL="https://github.com/dor2500/vortex-browser.git"

if [ -d "$INSTALL_DIR/.git" ]; then
  echo "🔄 Updating existing Vortex installation..."
  git -C "$INSTALL_DIR" pull --ff-only || true
else
  rm -rf "$INSTALL_DIR"
  echo "📥 Cloning Vortex Browser from GitHub..."
  git clone --depth 1 "$REPO_URL" "$INSTALL_DIR"
fi

# Build Profile
PROFILE_DIR="$INSTALL_DIR/.profile"
CHROME_DIR="$PROFILE_DIR/chrome"
mkdir -p "$CHROME_DIR"

cp "$INSTALL_DIR/src/chrome/userChrome.css" "$CHROME_DIR/userChrome.css"
cp "$INSTALL_DIR/src/chrome/userContent.css" "$CHROME_DIR/userContent.css"

NEWTAB_URI="file://$INSTALL_DIR/src/pages/newtab/index.html"
cat "$INSTALL_DIR/src/config/user.js" > "$PROFILE_DIR/user.js"
echo "" >> "$PROFILE_DIR/user.js"
echo "user_pref(\"browser.startup.homepage\", \"$NEWTAB_URI\");" >> "$PROFILE_DIR/user.js"
echo "user_pref(\"browser.newtab.url\", \"$NEWTAB_URI\");" >> "$PROFILE_DIR/user.js"

# Create symlink / CLI shortcut
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"
cat << 'EOF' > "$BIN_DIR/vortex"
#!/usr/bin/env bash
bash "$HOME/.vortex-browser/scripts/launch.sh" "$@"
EOF
chmod +x "$BIN_DIR/vortex"

# Linux Desktop Entry
if [ "$(uname)" = "Linux" ]; then
  DESKTOP_DIR="$HOME/.local/share/applications"
  mkdir -p "$DESKTOP_DIR"
  cat << EOF > "$DESKTOP_DIR/vortex-browser.desktop"
[Desktop Entry]
Name=Vortex Browser
Comment=Next-generation browser built on Mozilla Gecko engine
Exec=$BIN_DIR/vortex
Icon=$INSTALL_DIR/assets/icon.svg
Terminal=false
Type=Application
Categories=Network;WebBrowser;
EOF
  echo "✔️ Linux desktop launcher created."
fi

# macOS App Wrapper
if [ "$(uname)" = "Darwin" ]; then
  APP_DIR="/Applications/Vortex Browser.app/Contents/MacOS"
  mkdir -p "$APP_DIR"
  cat << EOF > "$APP_DIR/Vortex Browser"
#!/usr/bin/env bash
bash "$HOME/.vortex-browser/scripts/launch.sh"
EOF
  chmod +x "$APP_DIR/Vortex Browser"
  echo "✔️ macOS application launcher created."
fi

echo ""
echo "✅ Vortex Browser installed successfully!"
echo "🚀 Launching Vortex Browser..."
echo ""

bash "$INSTALL_DIR/scripts/launch.sh" &
