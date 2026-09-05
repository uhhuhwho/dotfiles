export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="/usr/sbin:$PATH"
#
# ~/.bashrc
#

# ==============================================================================
# 1. SHELL BEHAVIOR & INTERACTIVE INITIALIZATION
# ==============================================================================

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Fallback prompt (if starship is not initialized or fails)
PS1='[\u@\h \W]\$ '


# ==============================================================================
# 2. SYSTEM ENVIRONMENT VARIABLES & EXPORTS
# ==============================================================================

# MangoHUD (enables FPS overlay for Vulkan/OpenGL games)
export MANGOHUD=0

# Package Config Path (helps pkg-config locate library metadata)
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

# Dotnet CLI telemetry opt-out and path configuration
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export PATH="$HOME/.dotnet/tools:$PATH"

# Virtualization (libvirt connection default)
export LIBVIRT_DEFAULT_URI="qemu:///system"

# Local machine secrets & environment (gitignored)
if [[ -f "$HOME/.bashrc.local" ]]; then
    source "$HOME/.bashrc.local"
fi

### DEV ###
# Java
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk/
export PATH=$JAVA_HOME/bin:$PATH

# Android SDK cmdline-tools
export ANDROID_HOME=~/android-sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/build-tools/35.0.0:$PATH
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/27.2.12479018
export PATH=~/gradle/gradle-9.5.1/bin:$PATH

# Flutter
export PATH="$PATH:$HOME/flutter/3.41.7/bin"

# ==============================================================================
# 3. SHELL & UTILITY ALIASES
# ==============================================================================

# Safety & clarity defaults
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias grep='grep --color=auto'
alias ip='ip -color=auto'

# Modern ls replacement (eza)
alias ls='eza --all --long --tree --level=3 -m --grid --icons --color=auto'
alias clr='clear'

# Quick navigation & shell control
alias q='exit'
alias cc='clear'
alias CLEAR='clear'
alias sourcebash="source ~/.bashrc & echo Done!"

# Launch file manager in current directory silently in the background
alias fm="xdg-open . >/dev/null 2>&1 & disown"


# ==============================================================================
# 4. GIT & DEVELOPMENT
# ==============================================================================

# Git clone recursive
alias gcr='git clone --recursive'

# Dotfiles workflow (Zero-copy symlinked repository)
alias dotsync="$HOME/dotfiles/sync.sh"
alias dotstatus='git -C $HOME/dotfiles status'
alias dotdiff='git -C $HOME/dotfiles diff'
alias dotcd='cd $HOME/dotfiles'

# Set Thunar as the default
# xdg-mime default thunar.desktop inode/directory

# Remove all cached packages except the last 3 versions (Default & Recommended)
# sudo paccache -r

# Keep only the single latest version (if you are tight on space)
# sudo paccache -rk 1

# Remove cache for uninstalled packages only
# sudo paccache -rvu

# Nuclear option! Delete everything
# sudo pacman -Scc


# ==============================================================================
# 5. HARDWARE, SYSTEM OPERATIONS & PACKAGES
# ==============================================================================

# Power, Boot & Mounts
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias mountntfs='sudo mount -t ntfs-3g'
alias fixntfs='sudo ntfsfix -d'
alias gp='sudo -E gparted'

# Diagnostics & Stats
alias zsstats='sudo grep -r . /sys/kernel/debug/zswap/'
alias whousegpu='watch -n 1 nvidia-smi'
alias sysctlinfo='systemctl list-unit-files --type=service --state=enabled'

# Fonts
alias rebuildfontscach='fc-cache -f -v'

# User & Permission Helper
alias addtogroup='sudo usermod -aG $USER'

# Fan Control
alias fans='sudo python3 $HOME/Documents/Commands/Fans/hp_fan_cli.py'
alias FANS='fans'

# Shut Down
alias fuckoff='shutdown now'

# Arch Linux Package Management (Reference/Disabled)
# alias syu="sudo pacman -Syu"
# alias pupd='pacman -Qqd | pacman -Rsu --print -'
# alias pqe='pacman -Qe'
# alias yqm='yay -Qm'
alias cleanorphanpackages='sudo pacman -Rns $(pacman -Qdtq)'
alias listorhpanpackages='pacman -Qtd'
alias changepackageinstallreasontoexplicit='sudo pacman -D --asexplicit '
alias changepackageinstallreasontodependency='sudo pacman -D --asdeps '

# ==============================================================================
# 6. DOCKER CONTAINERS
# ==============================================================================

alias dstart='cd $HOME/Documents/Docker/; docker compose up -d'
alias dstop='cd $HOME/Documents/Docker/; docker compose down'
alias dlogs='cd $HOME/Documents/Docker/; docker compose logs'
alias dupdate='cd $HOME/Documents/Docker/; docker compose pull'


# ==============================================================================
# 7. APPLICATIONS & THIRD-PARTY TOOLS
# ==============================================================================

# Neovim
alias v='nvim'
alias sv='sudo nvim'

# Fastfetch system info
alias ff='fastfetch'
alias FF='fastfetch'

# NoiseTorch (Microphone noise suppression)
alias nt='noisetorch -i'
alias xnt='noisetorch -u'

# Local AI (Ollama & Custom Scripts)
alias deepseek='ollama run deepseek-r1:8b'

# Wallpaper Changer
alias changewallpaper='cd $HOME/Documents/Commands/; ./random-change-wallpaper.sh'

# Youtube Downloader
alias ytdl='yt-dlp -f "bestvideo+bestaudio/best" -o "%(title)s.%(ext)s"'


# ==============================================================================
# 8. HARDWARE MONITORING & STATS FUNCTIONS
# ==============================================================================

alias TEMP='temp'

# Display detailed CPU temperature, fan speeds, scaling, and GPU temperature
temp() {
    echo "---"
    echo "Power Profile: $(powerprofilesctl get)"
    echo "---"
    echo "GPU Temp:      $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)°C"
    echo "---"
    echo "CPU(s) scaling MHz: $(lscpu | grep 'CPU(s) scaling MHz' | awk '{print $NF}')"
    echo "CPU(s) scaling GHz: $(awk -v max_mhz=$(lscpu | grep "CPU max MHz" | awk '{print $NF}') -v scale=$(lscpu | grep "CPU(s) scaling MHz" | awk '{print $NF}' | tr -d '%') 'BEGIN {printf "%.2f", (max_mhz * scale / 100) / 1000}') GHz"
    
    # Extract CPU temperature
    sensors | grep 'Package id 0' | awk -F':' '{
        gsub(/Package id 0/, "CPU Temp");
        print $1 ": " $2
    }'
    echo "----"
    
    # Extract fan speeds
    sensors | grep 'fan' | awk -F':' '{
        gsub(/fan1/, "FAN 1 (CPU)");
        gsub(/fan2/, "FAN 2 (GPU)");
        print $1 ": " $2
    }'
    echo "---"
}


# ==============================================================================
# 9. SHELL COMPLETION & PROMPT INTEGRATION
# ==============================================================================

# Enable programmable bash-completion if installed
if [[ $PS1 && -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
fi

# Starship Prompt Initialization (Keep at the very end of the file)
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi


# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
# End of LM Studio CLI section


. "$HOME/.local/bin/env"


# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"

# kimi-code
export PATH="$HOME/.kimi-code/bin:$PATH"

# Flutter SDK
export PATH="$HOME/development/flutter/bin:$PATH"

# OpenClaw Completion
[ -f "$HOME/.openclaw/completions/openclaw.bash" ] && source "$HOME/.openclaw/completions/openclaw.bash"

# ==============================================================================
# 6. DOTFILES STATUS REMINDER
# ==============================================================================
if [[ $- == *i* && -d "$HOME/dotfiles/.git" ]]; then
    if [[ -n "$(git -C "$HOME/dotfiles" status --porcelain 2>/dev/null)" ]]; then
        echo -e "\033[1;33m💡 Dotfiles have unsaved changes. Run '\033[1;36mdotsync\033[1;33m' to backup.\033[0m"
    fi
fi
