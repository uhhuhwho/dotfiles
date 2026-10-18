#!/usr/bin/env bash
# ==============================================================================
# dotfiles bootstrap & restore script
# Restores configurations, symlinks, rice (themes & icons), machine-specific
# hardware profiles, system settings, services & packages.
# Supports Arch Linux, BlackArch, AUR (yay), and Flatpaks across multiple laptops.
# ==============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m'

MACHINE_PROFILE="$("$DOTFILES_DIR/scripts/system/detect-machine.sh")"
MACHINE_INFO="$("$DOTFILES_DIR/scripts/system/detect-machine.sh" --info)"
MACHINE_DIR="$DOTFILES_DIR/machines/$MACHINE_PROFILE"

echo -e "${BLUE}======================================================${NC}"
echo -e "${BLUE}        Dotfiles & System Environment Restore         ${NC}"
echo -e "${BLUE}======================================================${NC}"
echo -e "${CYAN}Detected Machine:${NC} ${MACHINE_INFO}"

# 1. Create standard user directories
mkdir -p "$HOME/.config" "$HOME/.themes" "$HOME/.icons" "$HOME/.local/bin" \
         "$HOME/Pictures/Wallpapers" "$HOME/Pictures/Screenshots"

# 2. Safety Backup & Symlink Function
safe_link() {
    local target="$1"
    local link_path="$2"

    if [[ -e "$link_path" ]] && [[ ! -L "$link_path" ]]; then
        mkdir -p "$BACKUP_DIR"
        echo -e "${YELLOW}[BACKUP]${NC} Existing $link_path moved to $BACKUP_DIR"
        mv "$link_path" "$BACKUP_DIR/"
    elif [[ -L "$link_path" ]]; then
        rm -f "$link_path"
    fi

    mkdir -p "$(dirname "$link_path")"
    ln -s "$target" "$link_path"
    echo -e "${GREEN}[LINKED]${NC} $link_path -> $target"
}

echo -e "\n${BLUE}:: Step 1: Deploying user configurations, symlinks & rice...${NC}"

# Link .config items
for item in "$DOTFILES_DIR/.config"/*; do
    name="$(basename "$item")"
    if [[ "$name" == "Code" ]]; then
        if [[ -f "$item/User/settings.json" ]]; then
            safe_link "$item/User/settings.json" "$HOME/.config/Code/User/settings.json"
        fi
    else
        safe_link "$item" "$HOME/.config/$name"
    fi
done

# Link home dotfiles
for item in "$DOTFILES_DIR/home"/.[!.]*; do
    name="$(basename "$item")"
    safe_link "$item" "$HOME/$name"
done

# Link GTK themes from rice/themes
for item in "$DOTFILES_DIR/rice/themes"/*; do
    [[ -d "$item" ]] || continue
    name="$(basename "$item")"
    safe_link "$item" "$HOME/.themes/$name"
done

# Link icon & cursor themes from rice/icons
for item in "$DOTFILES_DIR/rice/icons"/*; do
    [[ -d "$item" ]] || continue
    name="$(basename "$item")"
    safe_link "$item" "$HOME/.icons/$name"
done

# Load Dconf desktop settings (GTK app styles, Mission Center, Blueman)
if [[ -f "$DOTFILES_DIR/system/dconf-settings.ini" ]] && command -v dconf &>/dev/null; then
    dconf load / < "$DOTFILES_DIR/system/dconf-settings.ini"
    echo -e "${GREEN}[APPLIED]${NC} Dconf desktop preferences restored."
fi

# Restore Qt/KDE theming (qt6ct, kdeglobals, Trolltech.conf)
if [[ -d "$DOTFILES_DIR/system/qt" ]]; then
    mkdir -p "$HOME/.config/qt6ct"
    for f in qt6ct/qt6ct.conf kdeglobals Trolltech.conf; do
        [[ -f "$DOTFILES_DIR/system/qt/$f" ]] && cp "$DOTFILES_DIR/system/qt/$f" "$HOME/.config/$f"
    done
    echo -e "${GREEN}[APPLIED]${NC} Qt/KDE theme settings restored."
fi

# Provision ~/.bashrc.local template if missing
if [[ ! -f "$HOME/.bashrc.local" ]]; then
    cat << 'LOCAL_EOF' > "$HOME/.bashrc.local"
# ~/.bashrc.local
# Machine-local environment variables and secrets (NOT tracked in git)
# export DOTFILES_MACHINE="honor"
# export ANTHROPIC_AUTH_TOKEN=""
# export ANTHROPIC_BASE_URL="https://xixiapi.io"
# export CLAUDE_MEM_GEMINI_API_KEY=""
LOCAL_EOF
    chmod 600 "$HOME/.bashrc.local"
    echo -e "${GREEN}[CREATED]${NC} Clean ~/.bashrc.local template created for private keys."
fi

# Restore AI Assistant configs & skills manifests
if [[ -d "$DOTFILES_DIR/ai" ]]; then
    echo -e "${BLUE}:: Restoring AI Assistant configurations & manifests...${NC}"
    mkdir -p "$HOME/.agents/rules" "$HOME/.claude/plugins" "$HOME/.gemini/antigravity" "$HOME/.codex"
    [[ -f "$DOTFILES_DIR/ai/agents/.skill-lock.json" ]] && cp "$DOTFILES_DIR/ai/agents/.skill-lock.json" "$HOME/.agents/.skill-lock.json"
    [[ -f "$DOTFILES_DIR/ai/agents/rules/claude-mem-context.md" ]] && cp "$DOTFILES_DIR/ai/agents/rules/claude-mem-context.md" "$HOME/.agents/rules/claude-mem-context.md"
    [[ -f "$DOTFILES_DIR/ai/claude/installed_plugins.json" ]] && cp "$DOTFILES_DIR/ai/claude/installed_plugins.json" "$HOME/.claude/plugins/installed_plugins.json"
    [[ -f "$DOTFILES_DIR/ai/claude/settings.json" ]] && [[ ! -f "$HOME/.claude/settings.json" ]] && cp "$DOTFILES_DIR/ai/claude/settings.json" "$HOME/.claude/settings.json"
    [[ -f "$DOTFILES_DIR/ai/gemini/settings.json" ]] && [[ ! -f "$HOME/.gemini/settings.json" ]] && cp "$DOTFILES_DIR/ai/gemini/settings.json" "$HOME/.gemini/settings.json"
    [[ -f "$DOTFILES_DIR/ai/gemini/mcp_config.json" ]] && cp "$DOTFILES_DIR/ai/gemini/mcp_config.json" "$HOME/.gemini/antigravity/mcp_config.json"
    [[ -f "$DOTFILES_DIR/ai/codex/config.toml" ]] && [[ ! -f "$HOME/.codex/config.toml" ]] && cp "$DOTFILES_DIR/ai/codex/config.toml" "$HOME/.codex/config.toml"
    echo -e "${GREEN}[RESTORED]${NC} AI Assistant configurations deployed."
fi

# Restore Docker compose configurations
if [[ -d "$DOTFILES_DIR/docker" ]]; then
    mkdir -p "$HOME/Documents/Docker"
    for stack_dir in "$DOTFILES_DIR/docker"/*; do
        if [[ -d "$stack_dir" ]]; then
            stack_name="$(basename "$stack_dir")"
            mkdir -p "$HOME/Documents/Docker/$stack_name"
            for extra in "$stack_dir"/*; do
                if [[ -f "$extra" ]]; then
                    fname="$(basename "$extra")"
                    if [[ ! -f "$HOME/Documents/Docker/$stack_name/$fname" ]]; then
                        cp "$extra" "$HOME/Documents/Docker/$stack_name/"
                    fi
                fi
            done
            echo -e "${GREEN}[RESTORED]${NC} Docker stack '$stack_name' deployed."
        fi
    done
fi

# 3. System Configurations (pacman.conf, machine-specific hardware rules)
echo -e "\n${BLUE}:: Step 2: System Settings & Hardware Profile ($MACHINE_PROFILE)${NC}"
read -rp "Deploy optimized /etc/pacman.conf (Colors, ILoveCandy, ParallelDownloads, Multilib)? [y/N]: " deploy_pacman
if [[ "$deploy_pacman" =~ ^[Yy]$ ]]; then
    if [[ -f "$DOTFILES_DIR/system/etc/pacman.conf" ]]; then
        sudo cp /etc/pacman.conf /etc/pacman.conf.bak."$(date +%s)"
        sudo cp "$DOTFILES_DIR/system/etc/pacman.conf" /etc/pacman.conf
        echo -e "${GREEN}[APPLIED]${NC} /etc/pacman.conf successfully updated."
    fi
fi

# Deploy machine-specific hardware configs if present in machines/<profile>/
if [[ -d "$MACHINE_DIR/modprobe.d" ]] || [[ -d "$MACHINE_DIR/udev" ]] || [[ -d "$MACHINE_DIR/etc" ]]; then
    read -rp "Hardware rules found for profile '$MACHINE_PROFILE'. Apply them now? [Y/n]: " deploy_hw
    deploy_hw="${deploy_hw:-Y}"
    if [[ "$deploy_hw" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}:: Applying '$MACHINE_PROFILE' hardware rules...${NC}"
        sudo mkdir -p /etc/modprobe.d /etc/udev/rules.d
        [[ -d "$MACHINE_DIR/modprobe.d" ]] && sudo cp "$MACHINE_DIR/modprobe.d/"* /etc/modprobe.d/ 2>/dev/null || true
        [[ -d "$MACHINE_DIR/udev" ]] && sudo cp "$MACHINE_DIR/udev/"* /etc/udev/rules.d/ 2>/dev/null || true
        [[ -f "$MACHINE_DIR/etc/thinkfan.conf" ]] && sudo cp "$MACHINE_DIR/etc/thinkfan.conf" /etc/
        sudo udevadm control --reload-rules && sudo udevadm trigger || true
        echo -e "${GREEN}[APPLIED]${NC} Hardware rules for '$MACHINE_PROFILE' deployed."
    fi
fi

# Deploy Scaled Ly DM & Plymouth Boot Splash
if [[ -f "$DOTFILES_DIR/scripts/system/setup-ly-plymouth.sh" ]]; then
    read -rp "Deploy scaled Ly display manager (Doom animation) & Plymouth boot splash (Cuts Alt)? [y/N]: " deploy_ly
    if [[ "$deploy_ly" =~ ^[Yy]$ ]]; then
        bash "$DOTFILES_DIR/scripts/system/setup-ly-plymouth.sh"
    fi
fi

# 4. Package Installation Menu
echo -e "\n${BLUE}:: Step 3: Package Installation${NC}"
echo -e "Select package installation mode for profile [${CYAN}${MACHINE_PROFILE}${NC}]:"
echo -e "  ${YELLOW}1)${NC} Full System (Shared Arch + Machine Drivers + BlackArch + AUR + Flatpaks)"
echo -e "  ${YELLOW}2)${NC} Standard Desktop (Shared Arch + Machine Drivers + AUR only)"
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

        # Shared Standard Arch packages + Machine-specific Arch packages
        if [[ -f "$DOTFILES_DIR/packages/pacman.txt" ]]; then
            echo -e "${BLUE}:: Installing Shared Arch packages...${NC}"
            sudo pacman -S --needed - < "$DOTFILES_DIR/packages/pacman.txt"
        fi
        if [[ -s "$MACHINE_DIR/pacman.txt" ]]; then
            echo -e "${BLUE}:: Installing '$MACHINE_PROFILE' hardware drivers & packages...${NC}"
            sudo pacman -S --needed - < "$MACHINE_DIR/pacman.txt"
        fi

        # BlackArch tools (if Option 1 selected)
        if [[ "$choice" == "1" ]] && [[ -s "$DOTFILES_DIR/packages/blackarch.txt" ]]; then
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

        # Shared AUR packages + Machine-specific AUR packages
        if [[ -s "$DOTFILES_DIR/packages/aur.txt" ]]; then
            echo -e "${BLUE}:: Installing Shared AUR packages...${NC}"
            yay -S --needed - < "$DOTFILES_DIR/packages/aur.txt"
        fi
        if [[ -s "$MACHINE_DIR/aur.txt" ]]; then
            echo -e "${BLUE}:: Installing '$MACHINE_PROFILE' hardware AUR packages...${NC}"
            yay -S --needed - < "$MACHINE_DIR/aur.txt"
        fi

        # Flatpaks (if Option 1 selected)
        if [[ "$choice" == "1" ]] && [[ -s "$DOTFILES_DIR/packages/flatpak.txt" ]]; then
            echo -e "${BLUE}:: Restoring Flatpak applications...${NC}"
            if ! command -v flatpak &>/dev/null; then
                sudo pacman -S --needed --noconfirm flatpak
            fi
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            xargs -r flatpak install -y flathub < "$DOTFILES_DIR/packages/flatpak.txt"

            # Restore Flatseal overrides
            if [[ -d "$DOTFILES_DIR/packages/flatpak-overrides" ]]; then
                mkdir -p "$HOME/.local/share/flatpak/overrides"
                cp -r "$DOTFILES_DIR/packages/flatpak-overrides/"* "$HOME/.local/share/flatpak/overrides/"
                echo -e "${GREEN}[RESTORED]${NC} Flatseal permissions and overrides applied."
            fi
        fi

        # Bun runtime
        if ! command -v bun &>/dev/null; then
            echo -e "${BLUE}:: Installing Bun runtime...${NC}"
            curl -fsSL https://bun.sh/install | bash || true
        fi

        # NPM global packages
        if [[ -s "$DOTFILES_DIR/packages/npm.txt" ]] && command -v npm &>/dev/null; then
            echo -e "${BLUE}:: Restoring NPM global packages...${NC}"
            while IFS= read -r pkg; do
                [[ -n "$pkg" ]] && npm install -g "$pkg" 2>/dev/null || true
            done < "$DOTFILES_DIR/packages/npm.txt"
            if command -v rea &>/dev/null; then
                rea setup 2>/dev/null || true
            fi
        fi

        # Python UV tools
        if [[ -s "$DOTFILES_DIR/packages/uv.txt" ]] && command -v uv &>/dev/null; then
            echo -e "${BLUE}:: Restoring Python UV tools...${NC}"
            while IFS= read -r tool; do
                [[ -n "$tool" ]] && uv tool install "$tool" 2>/dev/null || true
            done < "$DOTFILES_DIR/packages/uv.txt"
        fi

        # Hyprland hyprpm plugins
        if [[ -s "$DOTFILES_DIR/packages/hyprpm.txt" ]] && command -v hyprpm &>/dev/null; then
            echo -e "${BLUE}:: Restoring Hyprland plugins...${NC}"
            hyprpm update 2>/dev/null || true
            while IFS= read -r repo; do
                [[ -n "$repo" ]] && [[ ! "$repo" =~ ^# ]] && hyprpm add "$repo" 2>/dev/null && hyprpm enable all 2>/dev/null || true
            done < "$DOTFILES_DIR/packages/hyprpm.txt"
            hyprpm reload 2>/dev/null || true
        fi

        # Ensure user belongs to input group for Wayle Caps/Num Lock OSD monitoring
        if ! groups "$USER" | grep -qw "input"; then
            echo -e "${YELLOW}:: Adding $USER to 'input' group for hardware toggle monitoring (Wayle Caps Lock OSD)...${NC}"
            sudo usermod -aG input "$USER" 2>/dev/null || true
        fi
        ;;
    *)
        echo -e "${YELLOW}:: Skipping package installation.${NC}"
        ;;
esac

# 5. Services Enablement (Shared + Machine Profile)
echo -e "\n${BLUE}:: Step 4: Systemd Services Enablement${NC}"
read -rp "Enable and activate configured system & user services? [Y/n]: " enable_services
enable_services="${enable_services:-Y}"

if [[ "$enable_services" =~ ^[Yy]$ ]]; then
    for svc_file in "$DOTFILES_DIR/packages/services-system.txt" "$MACHINE_DIR/services-system.txt"; do
        [[ -f "$svc_file" ]] || continue
        echo -e "${BLUE}:: Enabling System Services from $(basename "$(dirname "$svc_file")")/$(basename "$svc_file")...${NC}"
        while IFS= read -r svc; do
            [[ -z "$svc" ]] && continue
            if systemctl list-unit-files "$svc" &>/dev/null; then
                echo -e "  ${GREEN}✓${NC} Enabling $svc"
                sudo systemctl enable --now "$svc" 2>/dev/null || sudo systemctl enable "$svc" 2>/dev/null || true
            fi
        done < "$svc_file"
    done

    if [[ -f "$DOTFILES_DIR/packages/services-user.txt" ]]; then
        echo -e "${BLUE}:: Enabling User Services...${NC}"
        while IFS= read -r svc; do
            [[ -z "$svc" ]] && continue
            if systemctl --user list-unit-files "$svc" &>/dev/null; then
                echo -e "  ${GREEN}✓${NC} Enabling (user) $svc"
                systemctl --user enable --now "$svc" 2>/dev/null || systemctl --user enable "$svc" 2>/dev/null || true
            fi
        done < "$DOTFILES_DIR/packages/services-user.txt"
    fi
fi

# 6. Optional Offline Secrets Prompt
if [[ -f "$DOTFILES_DIR/scripts/security/restore-secrets-offline.sh" ]]; then
    echo -e "\n${BLUE}:: Step 5: Offline Secrets & Wi-Fi Restore${NC}"
    read -rp "Do you have an encrypted secrets archive (from backup-secrets-offline.sh)? [y/N]: " has_secrets
    if [[ "$has_secrets" =~ ^[Yy]$ ]]; then
        read -rp "Enter path to encrypted archive (e.g. /mnt/usb/system_secrets.tar.gz.gpg): " secrets_path
        if [[ -f "$secrets_path" ]]; then
            "$DOTFILES_DIR/scripts/security/restore-secrets-offline.sh" "$secrets_path"
        else
            echo -e "${RED}[ERROR]${NC} File not found: $secrets_path"
        fi
    fi
fi

echo -e "\n${GREEN}======================================================${NC}"
echo -e "${GREEN}✓ Complete system replication finished for [$MACHINE_PROFILE]!${NC}"
echo -e "${GREEN}======================================================${NC}"
