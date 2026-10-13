#!/usr/bin/env bash
# ==============================================================================
# Script: fix-grub-chroot.sh
# Category: System / Bootloader Recovery
# Description:
#   Helper script to repair and reinstall the GRUB UEFI bootloader from an
#   Arch Linux live ISO environment (inside arch-chroot).
#
# Usage:
#   ./fix-grub-chroot.sh              # Show partition layout & chroot guide
#   ./fix-grub-chroot.sh --install    # Execute grub-install & grub-mkconfig
# ==============================================================================

set -euo pipefail

EFI_DIR="${EFI_DIR:-/efi}"
BOOTLOADER_ID="${BOOTLOADER_ID:-GRUB}"

echo "=== Current Block Devices (lsblk) ==="
lsblk

if [[ "${1:-}" != "--install" ]]; then
    cat << 'EOF'

=== Arch ISO Chroot Recovery Steps ===
1. Mount your root partition (adjust device/subvolume as needed):
   mount /dev/nvme0n1p2 /mnt
   # (If using Btrfs subvolumes: mount -o subvol=@ /dev/nvme0n1p2 /mnt)

2. Mount your EFI System Partition (ESP):
   mount /dev/nvme0n1p1 /mnt/efi

3. Enter the chroot environment:
   arch-chroot /mnt

4. Run this script with --install inside the chroot:
   ./fix-grub-chroot.sh --install

5. Exit chroot and unmount:
   exit
   umount -R /mnt
EOF
    exit 0
fi

echo ":: Reinstalling GRUB for x86_64-efi to ${EFI_DIR} (ID: ${BOOTLOADER_ID})..."
sudo grub-install --target=x86_64-efi --efi-directory="$EFI_DIR" --bootloader-id="$BOOTLOADER_ID"

echo ":: Generating /boot/grub/grub.cfg..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo ":: Current EFI boot entries:"
efibootmgr

echo "✓ GRUB recovery complete! Remember to 'exit' chroot and 'umount -R /mnt'."

