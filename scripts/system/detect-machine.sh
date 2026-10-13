#!/usr/bin/env bash
# ==============================================================================
# Script: detect-machine.sh
# Category: System / Multi-Machine Profile Detection
# Description:
#   Automatically identifies the current machine profile based on DMI hardware
#   vendor/model identifiers and kernel platform drivers rather than relying
#   solely on hostname.
#
# Profiles:
#   - honor     : Honor MagicBook (HUAWEI HLYL-WXX9 / AMD Ryzen + Radeon)
#   - thinkpad  : Lenovo ThinkPad X230 (Intel + ThinkPad ACPI/EC)
#   - hp-omen   : HP Omen Laptop (Intel + NVIDIA + hp-wmi)
#   - <host>    : Fallback sanitized hostname for any unknown machine
#
# Usage:
#   ./detect-machine.sh           # Prints profile slug (e.g., "honor")
#   ./detect-machine.sh --info    # Prints detailed hardware & profile summary
# ==============================================================================

set -euo pipefail

read_dmi() {
    local file="/sys/class/dmi/id/$1"
    if [[ -r "$file" ]]; then
        tr -d '\0' < "$file" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
    fi
}

SYS_VENDOR="$(read_dmi sys_vendor)"
PRODUCT_NAME="$(read_dmi product_name)"
PRODUCT_FAMILY="$(read_dmi product_family)"
PRODUCT_VERSION="$(read_dmi product_version)"

detect_profile() {
    # 1. Explicit environment or config override
    if [[ -n "${DOTFILES_MACHINE:-}" ]]; then
        echo "$DOTFILES_MACHINE"
        return
    fi
    if [[ -f "$HOME/.config/dotfiles-machine" ]]; then
        head -n 1 "$HOME/.config/dotfiles-machine" | tr -d '[:space:]'
        return
    fi

    # 2. Honor / Huawei MagicBook detection
    if [[ "$SYS_VENDOR" =~ (HUAWEI|HONOR) ]] || [[ "$PRODUCT_FAMILY" =~ MagicBook ]] || [[ "$PRODUCT_NAME" =~ HLYL ]]; then
        echo "honor"
        return
    fi

    # 3. Lenovo ThinkPad detection
    if [[ -d "/sys/devices/platform/thinkpad_acpi" ]] || [[ "$SYS_VENDOR" =~ LENOVO ]] || [[ "$PRODUCT_VERSION" =~ ThinkPad ]]; then
        echo "thinkpad"
        return
    fi

    # 4. HP Omen detection
    if [[ -d "/sys/devices/platform/hp-wmi" ]] || [[ "$SYS_VENDOR" =~ (HP|Hewlett-Packard) ]]; then
        echo "hp-omen"
        return
    fi

    # 5. Fallback to sanitized hostname
    hostname -s 2>/dev/null | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9-' || echo "generic"
}

PROFILE="$(detect_profile)"

if [[ "${1:-}" == "--info" ]]; then
    CPU_MODEL="$(lscpu 2>/dev/null | awk -F: '/Model name/ {gsub(/^[ \t]+/, "", $2); print $2; exit}')"
    echo "${PROFILE} (${SYS_VENDOR:-Unknown} ${PRODUCT_NAME:-Unknown}${CPU_MODEL:+ - $CPU_MODEL})"
else
    echo "$PROFILE"
fi

