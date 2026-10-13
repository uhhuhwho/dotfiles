#!/usr/bin/env bash
# ==============================================================================
# Script: mount-games-disk.sh
# Category: System / Storage & Disks
# Description:
#   Mounts a secondary/external games drive (defaults to /dev/sda1 -> /mnt/ssdtg1tb).
#
# Usage:
#   ./mount-games-disk.sh [device] [mountpoint]
#   Example: ./mount-games-disk.sh /dev/sda1 /mnt/ssdtg1tb
# ==============================================================================

set -euo pipefail

DEVICE="${1:-/dev/sda1}"
MOUNT_POINT="${2:-/mnt/ssdtg1tb}"

if [[ ! -b "$DEVICE" ]]; then
    echo "Error: Block device '$DEVICE' not found." >&2
    echo "Available block devices:" >&2
    lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINT >&2
    exit 1
fi

sudo mkdir -p "$MOUNT_POINT"
sudo mount "$DEVICE" "$MOUNT_POINT"
echo "✓ Mounted $DEVICE at $MOUNT_POINT"

