#!/usr/bin/env bash
# ==============================================================================
# Script: setup-btrfs-snapper.sh
# Category: System / Filesystem & Recovery
# Description:
#   Configures automated Btrfs snapshots using Snapper and snap-pac.
#   Automatically creates pre/post snapshots around every pacman transaction
#   and enables timeline + cleanup systemd timers.
#
# Usage:
#   ./setup-btrfs-snapper.sh
# ==============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo -e "\033[1;34m:: Setting up Btrfs Snapper & snap-pac...\033[0m"

# 1. Verify root filesystem is Btrfs
if ! findmnt -n -o FSTYPE / | grep -q "btrfs"; then
    echo -e "\033[0;31m[ERROR] Root filesystem is not Btrfs. Aborting.\033[0m"
    exit 1
fi

# 2. Ensure required packages are installed
sudo pacman -S --needed --noconfirm snapper snap-pac

# 3. Initialize root snapper configuration if missing
if [[ ! -f "/etc/snapper/configs/root" ]]; then
    if [[ -d "/.snapshots" ]] && ! findmnt -n /.snapshots &>/dev/null; then
        echo ":: Removing existing non-mounted /.snapshots directory..."
        sudo rm -rf /.snapshots
    fi

    echo ":: Creating root snapper configuration..."
    sudo snapper -c root create-config /
fi

# 4. Deploy tuned retention policy from dotfiles
if [[ -f "$DOTFILES_DIR/system/etc/snapper/configs/root" ]]; then
    echo ":: Applying optimized retention policy..."
    sudo cp "$DOTFILES_DIR/system/etc/snapper/configs/root" /etc/snapper/configs/root
fi

# 5. Grant wheel group read/search access to snapshots
sudo chown -R :wheel /.snapshots
sudo chmod 750 /.snapshots
sudo chmod a+rx /.snapshots

# 6. Enable automated timeline & cleanup timers
echo ":: Enabling automated snapshot & cleanup timers..."
sudo systemctl enable --now snapper-timeline.timer snapper-cleanup.timer

echo -e "\033[1;32m✓ Btrfs Snapper and snap-pac successfully configured!\033[0m"
echo -e "List snapshots anytime with: \033[1;36msnapper -c root list\033[0m"

