#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
PROFILE_DIR="$DIR/.profile"
CHROME_DIR="$PROFILE_DIR/chrome"
NEWTAB_URI="file://$DIR/src/pages/newtab/index.html"

echo "=========================================================="
echo "         🌪️  VORTEX BROWSER (Gecko Quantum Engine)         "
echo "=========================================================="

# Locate Firefox binary
if command -v firefox >/dev/null 2>&1; then
  GECKO_EXE="firefox"
elif [ -f "/Applications/Firefox.app/Contents/MacOS/firefox" ]; then
  GECKO_EXE="/Applications/Firefox.app/Contents/MacOS/firefox"
else
  echo "❌ Error: Firefox executable not found."
  exit 1
fi

echo "✔️ Found Gecko Engine: $GECKO_EXE"

mkdir -p "$CHROME_DIR"
cp "$DIR/src/chrome/userChrome.css" "$CHROME_DIR/userChrome.css"
cp "$DIR/src/chrome/userContent.css" "$CHROME_DIR/userContent.css"

cat "$DIR/src/config/user.js" > "$PROFILE_DIR/user.js"
echo "" >> "$PROFILE_DIR/user.js"
echo "user_pref(\"browser.startup.homepage\", \"$NEWTAB_URI\");" >> "$PROFILE_DIR/user.js"
echo "user_pref(\"browser.newtab.url\", \"$NEWTAB_URI\");" >> "$PROFILE_DIR/user.js"

echo "✔️ Profile prepared at: $PROFILE_DIR"
echo "🚀 Launching Vortex Browser..."

exec "$GECKO_EXE" -no-remote -profile "$PROFILE_DIR" "$NEWTAB_URI"
