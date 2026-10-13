#!/usr/bin/env bash
# ==============================================================================
# Script: random-wallpaper.sh
# Category: Desktop / Wallpaper Management
# Description:
#   Selects a random wallpaper from ~/Pictures/Wallpapers (excluding the
#   currently loaded wallpaper) and applies it via hyprpaper (or waypaper).
#
# Usage:
#   ./random-wallpaper.sh [wallpaper_directory]
# ==============================================================================

set -euo pipefail

WALLPAPER_DIR="${1:-$HOME/Pictures/Wallpapers}"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
    echo "Error: Wallpaper directory '$WALLPAPER_DIR' does not exist." >&2
    exit 1
fi

# Prefer hyprpaper direct reload if hyprpaper is running
if pgrep -x hyprpaper >/dev/null 2>&1; then
    CURRENT_WALL="$(hyprctl hyprpaper listloaded 2>/dev/null | head -n 1 || true)"
    WALLPAPER="$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) ! -name "$(basename "${CURRENT_WALL:-none}")" | shuf -n 1)"

    if [[ -n "$WALLPAPER" ]]; then
        hyprctl hyprpaper reload ,"$WALLPAPER"
        echo "✓ Applied wallpaper: $WALLPAPER"
    else
        echo "No wallpapers found in $WALLPAPER_DIR" >&2
        exit 1
    fi
elif command -v waypaper >/dev/null 2>&1; then
    waypaper --random
    echo "✓ Applied random wallpaper via waypaper"
else
    echo "Error: Neither hyprpaper nor waypaper is running/installed." >&2
    exit 1
fi

