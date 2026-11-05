#!/usr/bin/env bash
# ==============================================================================
# Script: random-fastfetch.sh
# Category: Desktop / System Information
# Description:
#   Runs fastfetch with a randomized layout (preset) and a randomized logo
#   (custom images, ASCII art, or built-in logos) on every invocation.
#
# Usage:
#   random-fastfetch.sh [fastfetch_options]
#   random-fastfetch.sh --default   # Run standard fastfetch config
# ==============================================================================

set -euo pipefail

FASTFETCH_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/fastfetch"
IMG_DIR="$FASTFETCH_DIR/images"

# If the user asks for --default or -d, bypass randomness and run standard fastfetch
for arg in "$@"; do
    if [[ "$arg" == "--default" || "$arg" == "-d" ]]; then
        args=()
        for a in "$@"; do
            [[ "$a" != "--default" && "$a" != "-d" ]] && args+=("$a")
        done
        exec fastfetch "${args[@]}"
    fi
    if [[ "$arg" == "-h" || "$arg" == "--help" || "$arg" == "-v" || "$arg" == "--version" ]]; then
        exec fastfetch "$@"
    fi
done

# ------------------------------------------------------------------------------
# 1. Preset Selection (Layout)
# ------------------------------------------------------------------------------
# Check if user already supplied a config flag (-c or --config)
has_config=false
for ((i=1; i<=$#; i++)); do
    arg="${!i}"
    if [[ "$arg" == "-c" || "$arg" == "--config" || "$arg" =~ ^--config= ]]; then
        has_config=true
        break
    fi
done

preset_args=()
if [[ "$has_config" == false ]]; then
    # Curated selection of distinct fastfetch layouts
    # "config" is the user's custom layout in ~/.config/fastfetch/config.jsonc
    presets=(
        "config"
        "config"        # Double weight for custom layout
        "examples/13"   # Rounded card
        "examples/2"    # Partitioned Hardware / Software
        "examples/6"    # Tree hierarchy
        "examples/11"   # Minimalist clean
        "examples/12"   # Wide header card
        "examples/18"   # Double-box frame
        "archey"        # Classic Archey
        "neofetch"      # Classic Neofetch
    )
    chosen_preset="${presets[RANDOM % ${#presets[@]}]}"
    if [[ "$chosen_preset" != "config" ]]; then
        preset_args=("-c" "$chosen_preset")
    fi
fi

# ------------------------------------------------------------------------------
# 2. Logo Selection
# ------------------------------------------------------------------------------
# Check if user already supplied a logo flag (-l, --logo, etc.)
has_logo=false
for ((i=1; i<=$#; i++)); do
    arg="${!i}"
    if [[ "$arg" == "-l" || "$arg" == "--logo" || "$arg" =~ ^--logo= ]]; then
        has_logo=true
        break
    fi
done

logo_args=()
if [[ "$has_logo" == false ]]; then
    logos=()
    shopt -s nullglob

    # Custom Images (~/.config/fastfetch/images/*)
    if [[ -d "$IMG_DIR" ]]; then
        for img in "$IMG_DIR"/*.{png,jpg,jpeg,webp}; do
            logos+=("img:$img")
        done
    fi

    # Custom ASCII Art files (~/.config/fastfetch/*.txt)
    for txt in "$FASTFETCH_DIR"/*.txt; do
        logos+=("file:$txt")
    done

    shopt -u nullglob

    # Builtin ASCII logos
    logos+=("builtin:arch" "builtin:arch_small" "builtin:arch2")

    # Native preset logo (keeps whatever logo the preset was designed with)
    logos+=("none:preset_default")

    if [[ ${#logos[@]} -gt 0 ]]; then
        chosen_logo="${logos[RANDOM % ${#logos[@]}]}"
        type="${chosen_logo%%:*}"
        path="${chosen_logo#*:}"

        case "$type" in
            img)
                logo_args=("--logo" "$path" "--logo-type" "auto" "--logo-width" "30")
                ;;
            file)
                logo_args=("--logo" "$path" "--logo-type" "file")
                ;;
            builtin)
                logo_args=("--logo" "$path")
                ;;
            none)
                logo_args=()
                ;;
        esac
    fi
fi

# ------------------------------------------------------------------------------
# 3. Execute Fastfetch
# ------------------------------------------------------------------------------
exec fastfetch "${preset_args[@]}" "${logo_args[@]}" "$@"
