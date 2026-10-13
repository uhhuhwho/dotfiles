#!/usr/bin/env bash
# ==============================================================================
# Script: launch-antigravity.sh
# Category: Desktop / Application Launchers
# Description:
#   Launches Antigravity IDE inside an isolated user systemd scope with native
#   Wayland Ozone flags. Monitors the application's journal logs and sends
#   SIGKILL to the entire cgroup as soon as shutdown completes so no orphan
#   Electron/worker processes linger in the background.
#
# Usage:
#   ./launch-antigravity.sh
# ==============================================================================

set -euo pipefail

readonly UNIT_NAME="antigravity-$(date +%s)"
readonly APP_BIN="/usr/bin/antigravity --verbose --enable-features=UseOzonePlatform --ozone-platform=wayland"
readonly SHUTDOWN_TRIGGER="Lifecycle#onWillShutdown - end 'antigravityAnalytics'"

echo "[*] Launching Antigravity in isolated unit: ${UNIT_NAME}"

systemd-run --user \
    --scope \
    --unit="$UNIT_NAME" \
    --property=KillMode=control-group \
    /bin/bash -c "exec prlimit --core=0 $APP_BIN 2>&1 | systemd-cat --identifier=$UNIT_NAME" &

journalctl --user --identifier="$UNIT_NAME" --follow | \
    grep --line-buffered --max-count=1 "$SHUTDOWN_TRIGGER" && \
    systemctl --user kill --signal=SIGKILL "${UNIT_NAME}.scope"

echo "[*] Shutdown complete. All remaining processes in ${UNIT_NAME}.scope terminated."

