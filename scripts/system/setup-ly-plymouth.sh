#!/usr/bin/env bash
# ==============================================================================
# Script: setup-ly-plymouth.sh
# Category: System / Display Manager & Boot Splash
# Description:
#   Configures and deploys:
#   1. Ly TUI display manager scaled 2x on HiDPI displays via Terminus 32px font,
#      Doom fire animation, big clock, and "Hello back ;)" greeting.
#   2. Plymouth boot splash with early KMS (amdgpu/intel) and customized
#      Cuts Alt theme displaying the Arch Linux logo.
#
# Usage:
#   ./setup-ly-plymouth.sh
# ==============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m'

echo -e "${BLUE}======================================================${NC}"
echo -e "${BLUE}    Setup Scaled Ly DM & Plymouth (Cuts Alt)         ${NC}"
echo -e "${BLUE}======================================================${NC}"

# 1. Ensure required packages are installed
echo -e "\n${BLUE}:: Step 1: Checking required packages...${NC}"
PKGS_TO_INSTALL=()
for pkg in ly plymouth terminus-font; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
        PKGS_TO_INSTALL+=("$pkg")
    fi
done

if [[ ${#PKGS_TO_INSTALL[@]} -gt 0 ]]; then
    echo -e "${YELLOW}:: Installing missing packages: ${PKGS_TO_INSTALL[*]}${NC}"
    sudo pacman -S --needed --noconfirm "${PKGS_TO_INSTALL[@]}"
else
    echo -e "${GREEN}✓ All prerequisite packages (ly, plymouth, terminus-font) are installed.${NC}"
fi

# 2. Backups
echo -e "\n${BLUE}:: Step 2: Creating backups of existing system configurations...${NC}"
for file in /etc/vconsole.conf /etc/ly/config.ini /etc/ly/startup.sh /etc/mkinitcpio.conf /etc/default/grub; do
    if [[ -f "$file" ]]; then
        sudo cp -v "$file" "${file}.bak.$(date +%s)"
    fi
done

# 3. Deploy Ly & Console Font Scaling
echo -e "\n${BLUE}:: Step 3: Deploying Ly & Console font configurations...${NC}"
sudo mkdir -p /etc/ly
sudo cp -v "$DOTFILES_DIR/system/etc/vconsole.conf" /etc/vconsole.conf
sudo cp -v "$DOTFILES_DIR/system/etc/ly/config.ini" /etc/ly/config.ini
sudo cp -v "$DOTFILES_DIR/system/etc/ly/startup.sh" /etc/ly/startup.sh
sudo chmod +x /etc/ly/startup.sh

# 4. Deploy Plymouth Theme (Cuts Alt + Arch Logo)
echo -e "\n${BLUE}:: Step 4: Deploying Plymouth theme (Cuts Alt)...${NC}"
sudo mkdir -p /usr/share/plymouth/themes/cuts_alt
sudo cp -rf "$DOTFILES_DIR/rice/plymouth/cuts_alt/"* /usr/share/plymouth/themes/cuts_alt/

# If full adi1090x collection exists in /tmp or system, copy packs too
if [[ -d "/tmp/adi1090x-plymouth-themes" ]]; then
    echo -e "${CYAN}:: Found adi1090x collection in /tmp, installing remaining themes...${NC}"
    for pack in /tmp/adi1090x-plymouth-themes/pack_*/*; do
        theme_name="$(basename "$pack")"
        if [[ "$theme_name" != "cuts_alt" ]]; then
            sudo cp -rf "$pack" /usr/share/plymouth/themes/
        fi
    done
fi

# 5. Early KMS & Plymouth Hook in /etc/mkinitcpio.conf
echo -e "\n${BLUE}:: Step 5: Configuring /etc/mkinitcpio.conf for early KMS & splash...${NC}"
# Determine GPU driver (amdgpu, i915, xe)
GPU_DRIVER="amdgpu"
if lspci -k | grep -E 'VGA|3D' | grep -qi intel; then
    GPU_DRIVER="i915"
fi

sudo python3 - << PY_EOF
import re

with open('/etc/mkinitcpio.conf', 'r') as f:
    content = f.read()

# Add GPU module to MODULES if not present
gpu = "${GPU_DRIVER}"
def repl_modules(m):
    mods = m.group(1).split()
    if gpu not in mods:
        mods.append(gpu)
    return f'MODULES=({" ".join(mods)})'

content = re.sub(r'MODULES=\((.*?)\)', repl_modules, content)

# Add plymouth hook to HOOKS after kms/modconf/systemd if not present
def repl_hooks(m):
    hooks = m.group(1).split()
    if 'plymouth' not in hooks:
        if 'kms' in hooks:
            idx = hooks.index('kms') + 1
            hooks.insert(idx, 'plymouth')
        elif 'systemd' in hooks:
            idx = hooks.index('systemd') + 1
            hooks.insert(idx, 'plymouth')
        else:
            hooks.append('plymouth')
    return f'HOOKS=({" ".join(hooks)})'

content = re.sub(r'HOOKS=\((.*?)\)', repl_hooks, content)

with open('/etc/mkinitcpio.conf', 'w') as f:
    f.write(content)
print("Updated /etc/mkinitcpio.conf with early KMS (" + gpu + ") and plymouth hook.")
PY_EOF

# 6. Configure GRUB for splash
echo -e "\n${BLUE}:: Step 6: Configuring /etc/default/grub with splash parameter...${NC}"
sudo python3 - << 'PY_EOF'
import re

with open('/etc/default/grub', 'r') as f:
    content = f.read()

def repl_grub(m):
    params = m.group(1).split()
    if 'splash' not in params:
        params.append('splash')
    return f'GRUB_CMDLINE_LINUX_DEFAULT="{" ".join(params)}"'

content = re.sub(r'GRUB_CMDLINE_LINUX_DEFAULT="(.*?)"', repl_grub, content)

with open('/etc/default/grub', 'w') as f:
    f.write(content)
print("Updated /etc/default/grub with splash parameter.")
PY_EOF

# 7. Apply theme, rebuild initramfs and GRUB
echo -e "\n${BLUE}:: Step 7: Applying Plymouth theme & regenerating initramfs...${NC}"
sudo plymouth-set-default-theme -R cuts_alt

echo -e "\n${BLUE}:: Step 8: Updating GRUB bootloader configuration...${NC}"
sudo grub-mkconfig -o /boot/grub/grub.cfg

# 8. Configure Systemd Services
echo -e "\n${BLUE}:: Step 9: Configuring Ly display manager service...${NC}"
sudo systemctl disable getty@tty2.service 2>/dev/null || true
sudo systemctl enable ly@tty2.service

echo -e "\n${GREEN}======================================================${NC}"
echo -e "${GREEN}✓ Setup complete! Ly & Plymouth are ready.${NC}"
echo -e "${GREEN}======================================================${NC}"
echo -e "You can test Plymouth live without rebooting:"
echo -e "  ${YELLOW}sudo plymouthd; sudo plymouth --show-splash; sleep 5; sudo plymouth quit${NC}"
echo -e "Or reboot now to enjoy your new boot splash and login manager:"
echo -e "  ${YELLOW}systemctl reboot${NC}\n"
