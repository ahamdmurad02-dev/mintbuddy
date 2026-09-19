#!/usr/bin/env bash
# Install MintBuddy for the current user on Linux Mint / Ubuntu.
set -euo pipefail

APP_NAME="mintbuddy"
SRC="$(cd "$(dirname "$0")" && pwd)"
DEST="${HOME}/.local/share/${APP_NAME}"
APP_DIR="${HOME}/.local/share/applications"
BIN_DIR="${HOME}/.local/bin"

mkdir -p "$DEST" "$APP_DIR" "$BIN_DIR"
cp -a "$SRC/mintbuddy.py" "$SRC/web" "$SRC/icons" "$DEST/"
chmod +x "$DEST/mintbuddy.py"

cat > "${BIN_DIR}/mintbuddy" <<EOF
#!/usr/bin/env bash
exec python3 "${DEST}/mintbuddy.py" "\$@"
EOF
chmod +x "${BIN_DIR}/mintbuddy"

cat > "${APP_DIR}/mintbuddy.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=MintBuddy
Comment=Friendly Linux Mint helper for students
Exec=python3 ${DEST}/mintbuddy.py
Icon=${DEST}/icons/mintbuddy.svg
Terminal=false
Categories=Education;Utility;
StartupNotify=true
Keywords=mint;study;notes;linux;
EOF
chmod +x "${APP_DIR}/mintbuddy.desktop"

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$APP_DIR" >/dev/null 2>&1 || true
fi

echo "MintBuddy installed."
echo "Start it from the Menu (search MintBuddy) or run: mintbuddy"
echo "If the command is not found, log out/in or add ~/.local/bin to PATH."
