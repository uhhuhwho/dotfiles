#!/usr/bin/env bash
# ==============================================================================
# Script: cpu-turbo-boost.sh
# Category: Hardware (Common) / CPU Frequency Scaling
# Description:
#   Checks, enables, disables, or toggles CPU Turbo Boost / Core Performance
#   Boost across both Intel (intel_pstate) and AMD (amd-pstate / acpi-cpufreq)
#   processors.
#
# Usage:
#   ./cpu-turbo-boost.sh [status|enable|disable|toggle]
# ==============================================================================

set -euo pipefail

ACTION="${1:-status}"

INTEL_NO_TURBO="/sys/devices/system/cpu/intel_pstate/no_turbo"
GENERIC_BOOST="/sys/devices/system/cpu/cpufreq/boost"

get_state() {
    if [[ -f "$INTEL_NO_TURBO" ]]; then
        # Intel: 0 = turbo enabled, 1 = turbo disabled
        local val
        val="$(cat "$INTEL_NO_TURBO")"
        [[ "$val" == "0" ]] && echo "enabled" || echo "disabled"
    elif [[ -f "$GENERIC_BOOST" ]]; then
        # AMD / generic cpufreq: 1 = boost enabled, 0 = boost disabled
        local val
        val="$(cat "$GENERIC_BOOST")"
        [[ "$val" == "1" ]] && echo "enabled" || echo "disabled"
    else
        echo "unsupported"
    fi
}

set_state() {
    local target="$1" # "enable" or "disable"
    if [[ -f "$INTEL_NO_TURBO" ]]; then
        local val="0"
        [[ "$target" == "disable" ]] && val="1"
        echo "$val" | sudo tee "$INTEL_NO_TURBO" >/dev/null
    elif [[ -f "$GENERIC_BOOST" ]]; then
        local val="1"
        [[ "$target" == "disable" ]] && val="0"
        echo "$val" | sudo tee "$GENERIC_BOOST" >/dev/null
    else
        echo "Error: Neither intel_pstate/no_turbo nor cpufreq/boost sysfs interface found." >&2
        exit 1
    fi
    echo "✓ CPU Turbo Boost is now $(get_state)."
}

CURRENT="$(get_state)"
if [[ "$CURRENT" == "unsupported" ]]; then
    echo "Error: CPU turbo boost control is not supported by the active scaling driver." >&2
    exit 1
fi

case "$ACTION" in
    status)
        echo "CPU Turbo Boost: $CURRENT"
        ;;
    enable|on|1)
        set_state "enable"
        ;;
    disable|off|0)
        set_state "disable"
        ;;
    toggle)
        if [[ "$CURRENT" == "enabled" ]]; then
            set_state "disable"
        else
            set_state "enable"
        fi
        ;;
    *)
        echo "Usage: $0 [status|enable|disable|toggle]" >&2
        exit 1
        ;;
esac

