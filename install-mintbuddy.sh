#!/usr/bin/env bash
# MintBuddy one-file installer for Linux Mint
# Download and run:
#   curl -fsSL https://raw.githubusercontent.com/ahamdmurad02-dev/mintbuddy/main/install-mintbuddy.sh | bash
set -euo pipefail

REPO="ahamdmurad02-dev/mintbuddy"
BRANCH="main"
DEST="${HOME}/mintbuddy"

echo "MintBuddy installer"
echo "Repo: https://github.com/${REPO}"

need() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing program: $1"
    echo "Install with: sudo apt install $2"
    exit 1
  fi
}

need python3 python3
need curl curl

if command -v unzip >/dev/null 2>&1; then
  UNPACK=unzip
elif command -v tar >/dev/null 2>&1; then
  UNPACK=tar
else
  echo "Need unzip or tar. Install with: sudo apt install unzip"
  exit 1
fi

TMP="$(mktemp -d)"
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

echo "Downloading project..."
ZIP_URL="https://github.com/${REPO}/archive/refs/heads/${BRANCH}.zip"
TAR_URL="https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz"

mkdir -p "$DEST"

if [ "$UNPACK" = unzip ]; then
  curl -fsSL "$ZIP_URL" -o "$TMP/mintbuddy.zip"
  unzip -qo "$TMP/mintbuddy.zip" -d "$TMP"
else
  curl -fsSL "$TAR_URL" -o "$TMP/mintbuddy.tar.gz"
  tar -xzf "$TMP/mintbuddy.tar.gz" -C "$TMP"
fi

SRC="$(find "$TMP" -maxdepth 1 -type d -name 'mintbuddy-*' | head -n 1)"
if [ -z "$SRC" ]; then
  echo "Download failed."
  exit 1
fi

cp -a "$SRC"/. "$DEST"/
chmod +x "$DEST"/install.sh "$DEST"/mintbuddy.sh "$DEST"/run.sh "$DEST"/mintbuddy.py "$DEST"/install-mintbuddy.sh 2>/dev/null || true

echo "Installing for this user..."
"$DEST/install.sh"

echo
echo "Done."
echo "Start from the Menu: search MintBuddy"
echo "Or run:  $DEST/mintbuddy.sh"
