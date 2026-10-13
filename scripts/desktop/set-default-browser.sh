#!/usr/bin/env bash
# ==============================================================================
# Script: set-default-browser.sh
# Category: Desktop / XDG MIME & Defaults
# Description:
#   Views or updates the default web browser via xdg-settings.
#
# Usage:
#   ./set-default-browser.sh              # Show current default browser
#   ./set-default-browser.sh chromium     # Set Chromium as default
#   ./set-default-browser.sh firefox      # Set Firefox as default
# ==============================================================================

set -euo pipefail

if [[ $# -eq 0 ]]; then
    echo "Current default browser: $(xdg-settings get default-web-browser)"
    echo "Usage: $0 <chromium|firefox|brave|librewolf|browser.desktop>"
    exit 0
fi

INPUT="$1"
case "$INPUT" in
    *.desktop) DESKTOP_FILE="$INPUT" ;;
    *)         DESKTOP_FILE="${INPUT}.desktop" ;;
esac

xdg-settings set default-web-browser "$DESKTOP_FILE"
echo "✓ Default browser set to: $(xdg-settings get default-web-browser)"

