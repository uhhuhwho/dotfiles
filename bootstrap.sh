#!/usr/bin/env bash
# ==============================================================================
# dotfiles bootstrap & restore script
# Restores configurations, symlinks, themes, and packages on a new device
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

echo -e "\n${BLUE}:: Step 1: Linking configurations...${NC}"

# Link .config items
for item in "$DOTFILES_DIR/.config"/*; do
    name="$(basename "$item")"
    if [ "$name" = "Code" ]; then
        # Handle VS Code User settings specifically
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

# 3. Provision ~/.bashrc.local template if missing
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

echo -e "\n${GREEN}✓ Configurations and symlinks successfully deployed!${NC}"

# 4. Package Installation Menu
echo -e "\n${BLUE}:: Step 2: Package Installation${NC}"
echo -e "Select installation mode:"
echo -e "  ${YELLOW}1)${NC} Full System (Standard Arch + BlackArch + AUR + Flatpaks)"
echo -e "  ${YELLOW}2)${NC} Standard Desktop (Arch Core/Extra + AUR only)"
echo -e "  ${YELLOW}3)${NC} Skip package installation (Configs & Dotfiles only)"
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

        # 1. Standard Arch packages
        if [ -f "$DOTFILES_DIR/packages/pacman.txt" ]; then
            echo -e "${BLUE}:: Installing Standard Arch packages...${NC}"
            sudo pacman -S --needed - < "$DOTFILES_DIR/packages/pacman.txt"
        fi

        # 2. BlackArch tools (if Option 1 selected)
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

        # 3. AUR packages
        if [ -f "$DOTFILES_DIR/packages/aur.txt" ]; then
            echo -e "${BLUE}:: Installing AUR packages...${NC}"
            yay -S --needed - < "$DOTFILES_DIR/packages/aur.txt"
        fi

        # 4. Flatpaks (if Option 1 selected)
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

echo -e "\n${GREEN}======================================================${NC}"
echo -e "${GREEN}✓ System restoration complete! Welcome back.${NC}"
echo -e "${GREEN}======================================================${NC}"
