#!/usr/bin/env bash
# MintBuddy launcher for Linux Mint / Ubuntu
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
APP="$DIR/mintbuddy.py"

if ! command -v python3 >/dev/null 2>&1; then
  echo "Python 3 is not installed."
  echo "Install it with: sudo apt install python3"
  exit 1
fi

if [ ! -f "$APP" ]; then
  echo "Cannot find mintbuddy.py next to this script."
  echo "Folder should contain: mintbuddy.sh, mintbuddy.py, web/, icons/"
  exit 1
fi

chmod +x "$APP" 2>/dev/null || true
echo "Starting MintBuddy..."
exec python3 "$APP"
