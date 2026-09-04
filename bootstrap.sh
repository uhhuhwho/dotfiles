#!/usr/bin/env bash
# ==============================================================================
# dotfiles bootstrap & restore script
# Restores configurations, symlinks, themes, system settings, services & packages
# Supports Arch Linux, BlackArch, AUR (yay), and Flatpaks
# ==============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'

echo -e "${BLUE}======================================================${NC}"
echo -e "${BLUE}        Dotfiles & System Environment Restore         ${NC}"
echo -e "${BLUE}======================================================${NC}"

# 1. Create standard user directories
mkdir -p "$HOME/.config" "$HOME/.themes" "$HOME/.icons" "$HOME/.local/bin" \
         "$HOME/Pictures/Wallpapers/badreddine wallpapers"

# 2. Safety Backup Function
safe_link() {
    local target="$1"
    local link_path="$2"

    if [ -e "$link_path" ] && [ ! -L "$link_path" ]; then
        mkdir -p "$BACKUP_DIR"
        echo -e "${YELLOW}[BACKUP]${NC} Existing $link_path moved to $BACKUP_DIR"
        mv "$link_path" "$BACKUP_DIR/"
    elif [ -L "$link_path" ]; then
        rm -f "$link_path"
    fi

    mkdir -p "$(dirname "$link_path")"
    ln -s "$target" "$link_path"
    echo -e "${GREEN}[LINKED]${NC} $link_path -> $target"
}

echo -e "\n${BLUE}:: Step 1: Deploying user configurations & symlinks...${NC}"

# Link .config items
for item in "$DOTFILES_DIR/.config"/*; do
    name="$(basename "$item")"
    if [ "$name" = "Code" ]; then
        if [ -f "$item/User/settings.json" ]; then
            safe_link "$item/User/settings.json" "$HOME/.config/Code/User/settings.json"
        fi
    else
        safe_link "$item" "$HOME/.config/$name"
    fi
done

# Link home files
for item in "$DOTFILES_DIR/home"/.[!.]*; do
    name="$(basename "$item")"
    safe_link "$item" "$HOME/$name"
done

# Link themes
for item in "$DOTFILES_DIR/themes"/*; do
    [ -d "$item" ] || continue
    name="$(basename "$item")"
    safe_link "$item" "$HOME/.themes/$name"
done

# Link icons
for item in "$DOTFILES_DIR/icons"/*; do
    [ -d "$item" ] || continue
    name="$(basename "$item")"
    safe_link "$item" "$HOME/.icons/$name"
done

# Restore wallpaper
if [ -f "$DOTFILES_DIR/assets/wallpaper.jpeg" ]; then
    cp "$DOTFILES_DIR/assets/wallpaper.jpeg" "$HOME/Pictures/Wallpapers/badreddine wallpapers/a_view_of_the_ocean_from_a_balcony.jpeg"
    echo -e "${GREEN}[RESTORED]${NC} Active wallpaper placed in ~/Pictures/Wallpapers/"
fi

# Restore custom commands
if [ -d "$DOTFILES_DIR/commands" ]; then
    mkdir -p "$HOME/Documents/Commands"
    cp -rn "$DOTFILES_DIR/commands/"* "$HOME/Documents/Commands/" 2>/dev/null || true
    echo -e "${GREEN}[RESTORED]${NC} Custom helper scripts restored to ~/Documents/Commands/"
fi

# Load Dconf desktop settings (GTK app styles, Mission Center, Blueman)
if [ -f "$DOTFILES_DIR/system/dconf-settings.ini" ] && command -v dconf &>/dev/null; then
    dconf load / < "$DOTFILES_DIR/system/dconf-settings.ini"
    echo -e "${GREEN}[APPLIED]${NC} Dconf desktop preferences restored."
fi

# Provision ~/.bashrc.local template if missing
if [ ! -f "$HOME/.bashrc.local" ]; then
    cat << 'LOCAL_EOF' > "$HOME/.bashrc.local"
# ~/.bashrc.local
# Machine-local environment variables and secrets (NOT tracked in git)
# export ANTHROPIC_AUTH_TOKEN=""
# export ANTHROPIC_BASE_URL="https://xixiapi.io"
LOCAL_EOF
    chmod 600 "$HOME/.bashrc.local"
    echo -e "${GREEN}[CREATED]${NC} Clean ~/.bashrc.local template created for private keys."
fi

# 3. System Configurations (pacman.conf, hardware)
echo -e "\n${BLUE}:: Step 2: System Settings & Hardware Configurations${NC}"
read -rp "Deploy optimized /etc/pacman.conf (Colors, ILoveCandy, ParallelDownloads, Multilib)? [y/N]: " deploy_pacman
if [[ "$deploy_pacman" =~ ^[Yy]$ ]]; then
    if [ -f "$DOTFILES_DIR/system/etc/pacman.conf" ]; then
        sudo cp /etc/pacman.conf /etc/pacman.conf.bak."$(date +%s)"
        sudo cp "$DOTFILES_DIR/system/etc/pacman.conf" /etc/pacman.conf
        echo -e "${GREEN}[APPLIED]${NC} /etc/pacman.conf successfully updated."
    fi
fi

# ThinkPad hardware tweaks
is_thinkpad=false
if [ -d "/sys/devices/platform/thinkpad_acpi" ] || grep -qi "thinkpad" /sys/class/dmi/id/product_version 2>/dev/null; then
    is_thinkpad=true
fi

if [ "$is_thinkpad" = true ]; then
    read -rp "ThinkPad detected! Apply ThinkLight udev rules and fan control modules? [Y/n]: " deploy_tp
    deploy_tp="${deploy_tp:-Y}"
else
    read -rp "Apply ThinkPad hardware configurations (ThinkLight, fan controls)? [y/N]: " deploy_tp
fi

if [[ "$deploy_tp" =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}:: Applying hardware rules...${NC}"
    sudo mkdir -p /etc/modprobe.d /etc/udev/rules.d
    [ -f "$DOTFILES_DIR/system/hardware/thinkpad/modprobe.d/thinkpad_acpi.conf" ] && sudo cp "$DOTFILES_DIR/system/hardware/thinkpad/modprobe.d/"* /etc/modprobe.d/
    [ -f "$DOTFILES_DIR/system/hardware/thinkpad/udev/99-thinklight.rules" ] && sudo cp "$DOTFILES_DIR/system/hardware/thinkpad/udev/99-thinklight.rules" /etc/udev/rules.d/
    [ -f "$DOTFILES_DIR/system/hardware/thinkpad/etc/thinkfan.conf" ] && sudo cp "$DOTFILES_DIR/system/hardware/thinkpad/etc/thinkfan.conf" /etc/
    sudo udevadm control --reload-rules && sudo udevadm trigger || true
    echo -e "${GREEN}[APPLIED]${NC} ThinkPad hardware rules deployed."
fi

# 4. Package Installation Menu
echo -e "\n${BLUE}:: Step 3: Package Installation${NC}"
echo -e "Select package installation mode:"
echo -e "  ${YELLOW}1)${NC} Full System (Standard Arch + BlackArch + AUR + Flatpaks)"
echo -e "  ${YELLOW}2)${NC} Standard Desktop (Arch Core/Extra + AUR only)"
echo -e "  ${YELLOW}3)${NC} Skip package installation (Configs & Settings only)"
read -rp "Select option [1-3] (default: 3): " choice
choice="${choice:-3}"

case "$choice" in
    1|2)
        # Ensure yay is installed
        if ! command -v yay &>/dev/null; then
            echo -e "${YELLOW}:: yay not found. Bootstrapping yay from AUR...${NC}"
            sudo pacman -S --needed --noconfirm base-devel git
            tmp_yay="$(mktemp -d)"
            git clone https://aur.archlinux.org/yay-bin.git "$tmp_yay"
            (cd "$tmp_yay" && makepkg -si --noconfirm)
            rm -rf "$tmp_yay"
        fi

        # Standard Arch packages
        if [ -f "$DOTFILES_DIR/packages/pacman.txt" ]; then
            echo -e "${BLUE}:: Installing Standard Arch packages...${NC}"
            sudo pacman -S --needed - < "$DOTFILES_DIR/packages/pacman.txt"
        fi

        # BlackArch tools (if Option 1 selected)
        if [ "$choice" = "1" ] && [ -f "$DOTFILES_DIR/packages/blackarch.txt" ]; then
            echo -e "${BLUE}:: Setting up BlackArch repository...${NC}"
            if ! grep -q "\[blackarch\]" /etc/pacman.conf 2>/dev/null; then
                tmp_ba="$(mktemp -d)"
                (
                    cd "$tmp_ba"
                    echo -e "${YELLOW}:: Fetching and executing official strap.sh from blackarch.org...${NC}"
                    curl -sSO https://blackarch.org/strap.sh
                    chmod +x strap.sh
                    sudo ./strap.sh
                )
                rm -rf "$tmp_ba"
            fi
            echo -e "${BLUE}:: Installing BlackArch security & OSINT packages...${NC}"
            sudo pacman -S --needed - < "$DOTFILES_DIR/packages/blackarch.txt"
        fi

        # AUR packages
        if [ -f "$DOTFILES_DIR/packages/aur.txt" ]; then
            echo -e "${BLUE}:: Installing AUR packages...${NC}"
            yay -S --needed - < "$DOTFILES_DIR/packages/aur.txt"
        fi

        # Flatpaks (if Option 1 selected)
        if [ "$choice" = "1" ] && [ -f "$DOTFILES_DIR/packages/flatpak.txt" ]; then
            echo -e "${BLUE}:: Restoring Flatpak applications...${NC}"
            if ! command -v flatpak &>/dev/null; then
                sudo pacman -S --needed --noconfirm flatpak
            fi
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            xargs -r flatpak install -y flathub < "$DOTFILES_DIR/packages/flatpak.txt"

            # Restore Flatseal overrides
            if [ -d "$DOTFILES_DIR/packages/flatpak-overrides" ]; then
                mkdir -p "$HOME/.local/share/flatpak/overrides"
                cp -r "$DOTFILES_DIR/packages/flatpak-overrides/"* "$HOME/.local/share/flatpak/overrides/"
                echo -e "${GREEN}[RESTORED]${NC} Flatseal permissions and overrides applied."
            fi
        fi
        ;;
    *)
        echo -e "${YELLOW}:: Skipping package installation.${NC}"
        ;;
esac

# 5. Services Enablement
echo -e "\n${BLUE}:: Step 4: Systemd Services Enablement${NC}"
read -rp "Enable and activate configured system services (NetworkManager, Bluetooth, Power Profiles, etc.)? [Y/n]: " enable_services
enable_services="${enable_services:-Y}"

if [[ "$enable_services" =~ ^[Yy]$ ]]; then
    if [ -f "$DOTFILES_DIR/packages/services-system.txt" ]; then
        echo -e "${BLUE}:: Enabling System Services...${NC}"
        while IFS= read -r svc; do
            [ -z "$svc" ] && continue
            if systemctl list-unit-files "$svc" &>/dev/null; then
                echo -e "  ${GREEN}✓${NC} Enabling $svc"
                sudo systemctl enable --now "$svc" 2>/dev/null || sudo systemctl enable "$svc" 2>/dev/null || true
            fi
        done < "$DOTFILES_DIR/packages/services-system.txt"
    fi

    if [ -f "$DOTFILES_DIR/packages/services-user.txt" ]; then
        echo -e "${BLUE}:: Enabling User Services...${NC}"
        while IFS= read -r svc; do
            [ -z "$svc" ] && continue
            if systemctl --user list-unit-files "$svc" &>/dev/null; then
                echo -e "  ${GREEN}✓${NC} Enabling (user) $svc"
                systemctl --user enable --now "$svc" 2>/dev/null || systemctl --user enable "$svc" 2>/dev/null || true
            fi
        done < "$DOTFILES_DIR/packages/services-user.txt"
    fi
fi

# 6. Optional Offline Secrets Prompt
if [ -f "$DOTFILES_DIR/scripts/restore-secrets-offline.sh" ]; then
    echo -e "\n${BLUE}:: Step 5: Offline Secrets & Wi-Fi Restore${NC}"
    read -rp "Do you have an encrypted secrets archive (from backup-secrets-offline.sh)? [y/N]: " has_secrets
    if [[ "$has_secrets" =~ ^[Yy]$ ]]; then
        read -rp "Enter path to encrypted archive (e.g. /mnt/usb/system_secrets.tar.gz.gpg): " secrets_path
        if [ -f "$secrets_path" ]; then
            "$DOTFILES_DIR/scripts/restore-secrets-offline.sh" "$secrets_path"
        else
            echo -e "${RED}[ERROR]${NC} File not found: $secrets_path"
        fi
    fi
fi

echo -e "\n${GREEN}======================================================${NC}"
echo -e "${GREEN}✓ Complete system replication finished! Welcome back.${NC}"
echo -e "${GREEN}======================================================${NC}"
