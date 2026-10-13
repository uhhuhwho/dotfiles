#!/usr/bin/env bash
# ==============================================================================
# Script: power-profile.sh
# Category: Hardware (Common) / Power Management
# Description:
#   Wrapper around power-profiles-daemon (powerprofilesctl) to inspect, switch,
#   or cycle between 'power-saver', 'balanced', and 'performance' modes.
#
# Usage:
#   ./power-profile.sh                        # Show current profile
#   ./power-profile.sh cycle                  # Cycle to next profile
#   ./power-profile.sh <performance|balanced|power-saver>
# ==============================================================================

set -euo pipefail

if ! command -v powerprofilesctl >/dev/null 2>&1; then
    echo "Error: powerprofilesctl (power-profiles-daemon) is not installed." >&2
    exit 1
fi

ACTION="${1:-status}"
CURRENT="$(powerprofilesctl get)"

case "$ACTION" in
    status)
        echo "Active Power Profile: $CURRENT"
        echo ""
        powerprofilesctl list
        ;;
    performance|balanced|power-saver)
        powerprofilesctl set "$ACTION"
        echo "✓ Power profile set to: $ACTION"
        command -v notify-send >/dev/null 2>&1 && notify-send "Power Profile" "Switched to $ACTION" || true
        ;;
    cycle)
        case "$CURRENT" in
            power-saver) NEXT="balanced" ;;
            balanced)    NEXT="performance" ;;
            *)           NEXT="power-saver" ;;
        esac
        powerprofilesctl set "$NEXT"
        echo "✓ Power profile cycled: $CURRENT -> $NEXT"
        command -v notify-send >/dev/null 2>&1 && notify-send "Power Profile" "Switched to $NEXT" || true
        ;;
    *)
        echo "Usage: $0 [status|cycle|performance|balanced|power-saver]" >&2
        exit 1
        ;;
esac

