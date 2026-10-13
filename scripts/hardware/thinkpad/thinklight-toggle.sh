#!/usr/bin/env bash
# ==============================================================================
# Script: thinklight-toggle.sh
# Category: Hardware (ThinkPad X230) / Keyboard Illumination
# Description:
#   Toggles the ThinkPad X230 overhead keyboard ThinkLight LED by reading and
#   writing byte 0x3B of the Embedded Controller (/sys/kernel/debug/ec/ec0/io).
#   - 0x12: ThinkLight ON
#   - 0x10: ThinkLight OFF
#
# Bound to: XF86Launch1 (ThinkVantage button) in Hyprland.
# ==============================================================================

set -euo pipefail

EC_IO="/sys/kernel/debug/ec/ec0/io"

# Ensure the ec_sys kernel module is loaded with write support enabled
if ! lsmod | grep -q "^ec_sys"; then
    sudo modprobe ec_sys write_support=1
fi

if [[ ! -e "$EC_IO" ]]; then
    echo "Error: Embedded Controller interface ($EC_IO) not available." >&2
    exit 1
fi

# Read current hex byte at offset 0x3B (59)
CURRENT="$(sudo dd if="$EC_IO" bs=1 count=1 skip=$((0x3B)) 2>/dev/null | xxd -p)"

if [[ "$CURRENT" == "12" ]]; then
    printf '\x10' | sudo dd of="$EC_IO" bs=1 seek=$((0x3B)) conv=notrunc 2>/dev/null
    echo "ThinkLight: OFF"
else
    printf '\x12' | sudo dd of="$EC_IO" bs=1 seek=$((0x3B)) conv=notrunc 2>/dev/null
    echo "ThinkLight: ON"
fi

