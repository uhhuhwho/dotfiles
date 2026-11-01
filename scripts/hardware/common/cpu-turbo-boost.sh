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
#   ./cpu-turbo-boost.sh [status|enable|disable|toggle|wayle|json]
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

write_sysfs() {
    local val="$1"
    local path="$2"

    # 1. Direct write (works if /etc/tmpfiles.d/ permissions are 0666)
    if echo "$val" 2>/dev/null > "$path"; then
        return 0
    fi

    # 2. Non-interactive sudo (works if sudoers NOPASSWD is configured)
    if sudo -n tee "$path" >/dev/null 2>&1 <<< "$val"; then
        return 0
    fi

    # 3. Desktop polkit prompt (works from graphical environment / Wayle click)
    if command -v pkexec >/dev/null 2>&1; then
        pkexec sh -c "echo '$val' > '$path'" && return 0
    fi

    # 4. Interactive sudo fallback
    echo "$val" | sudo tee "$path" >/dev/null
}

set_state() {
    local target="$1" # "enable" or "disable"
    local new_state=""

    if [[ -f "$INTEL_NO_TURBO" ]]; then
        local val="0"
        [[ "$target" == "disable" ]] && val="1"
        write_sysfs "$val" "$INTEL_NO_TURBO"
    elif [[ -f "$GENERIC_BOOST" ]]; then
        local val="1"
        [[ "$target" == "disable" ]] && val="0"
        write_sysfs "$val" "$GENERIC_BOOST"
    else
        echo "Error: Neither intel_pstate/no_turbo nor cpufreq/boost sysfs interface found." >&2
        exit 1
    fi

    new_state="$(get_state)"
    echo "✓ CPU Turbo Boost is now ${new_state}."

    # Desktop notification
    if command -v notify-send >/dev/null 2>&1; then
        if [[ "$new_state" == "enabled" ]]; then
            notify-send -u normal -a "Wayle" -i "power-profile-performance-symbolic" \
                "CPU Turbo Boost Enabled" "High performance (up to 4.0GHz) active.\nMonitor power draw if on 65W charger." || true
        else
            notify-send -u normal -a "Wayle" -i "power-profile-power-saver-symbolic" \
                "CPU Turbo Boost Disabled" "Safe Eco Mode (3.0GHz base clock) active.\nBrownout protection active." || true
        fi
    fi
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
    wayle|json)
        if [[ "$CURRENT" == "enabled" ]]; then
            cat <<EOF
{"text":"Boost","alt":"on","class":"boost-on","tooltip":"CPU Turbo Boost: Enabled (Max 4.0GHz)\nClick to switch to Safe Eco Mode (3.0GHz Base)"}
EOF
        else
            cat <<EOF
{"text":"Eco","alt":"off","class":"boost-off","tooltip":"CPU Turbo Boost: Disabled (Safe 3.0GHz Base)\nBrownout Protection Active (65W Safe)\nClick to switch to Turbo Boost"}
EOF
        fi
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
        echo "Usage: $0 [status|enable|disable|toggle|wayle|json]" >&2
        exit 1
        ;;
esac

