# 🚀 Badreddine's Arch Linux Dotfiles & System Setup

A streamlined, zero-copy, minimal-effort dotfiles and system replication framework for Arch Linux running Hyprland, Wayle, Vicinae, Kitty, and Starship.

---

## 🌟 Core Features

- **Zero-Copy Symlink Editing**: All configuration files are symlinked to `~/.config` and `~`. Any changes made in your day-to-day workflow are instantly tracked inside git without copying.
- **No Junk / Pure Configs**: Heavy Electron caches (VS Code, Ferdium, browsers) and dead configs are excluded. The repository stays lightweight (~15MB).
- **1-Command Sync (`dotsync`)**: Automatically dumps clean package lists (Pacman, AUR, Flatpak), snapshots Flatseal permissions, and commits/pushes to GitHub.
- **1-Command Bootstrap (`bootstrap.sh`)**: Fully automates deploying symlinks, creating safety backups of existing files, and optionally restoring all Native, AUR, and Flatpak packages on a new machine.
- **Decoupled Secrets (`~/.bashrc.local`)**: Sensitive API keys and machine tokens are isolated into `~/.bashrc.local` (gitignored), ensuring zero risk of credential leaks.

---

## 📂 Repository Structure

```
~/dotfiles/
├── .config/
│   ├── hypr/               # Hyprland (hyprland.lua, lock, idle, paper, sunset, scripts)
│   ├── wayle/              # Wayle status bar & panel
│   ├── vicinae/            # Vicinae launcher, search, and clipboard
│   ├── kitty/              # Kitty terminal configuration
│   ├── fastfetch/          # Fastfetch configuration & Berserker logo
│   ├── waypaper/           # Waypaper wallpaper picker
│   ├── starship.toml       # Starship prompt configuration
│   ├── gtk-3.0/, gtk-4.0/  # GTK themes & colors
│   ├── xsettingsd/         # Cursor & theme scaling for XWayland
│   ├── nvim/               # Neovim editor setup
│   ├── btop/, cava/        # System monitor & audio visualizer
│   └── Code/User/          # VS Code User settings.json
├── home/
│   ├── .bashrc             # Shell configuration (sources ~/.bashrc.local)
│   ├── .bash_profile       # Login shell profile
│   ├── .gitconfig          # Git user configuration
│   ├── .gtkrc-2.0          # GTK2 theme settings
│   └── .face               # User profile picture
├── themes/                 # Dracula-pink-accent GTK theme
├── icons/                  # Future-Cyan-Hyprcursor, WhiteSur, default
├── assets/                 # Active desktop wallpaper
├── commands/               # Custom helper scripts (ThinkPad mods, fans, etc.)
├── packages/
│   ├── pacman.txt          # Explicit native packages (pacman -Qeqn)
│   ├── aur.txt             # Explicit AUR packages (pacman -Qeqm)
│   ├── flatpak.txt         # Flatpak application IDs
│   └── flatpak-overrides/  # Flatseal permissions & global overrides
├── sync.sh                 # Daily backup & push script (aliased as 'dotsync')
├── bootstrap.sh            # Complete installer for fresh machines
└── .gitignore              # Ignores secrets, caches, and local overrides
```

---

## 🔄 Daily Workflow (Backing up Changes)

Whenever you tweak your configs or install new applications, run:

```bash
dotsync "Description of what you changed"
```

Or run directly:
```bash
~/dotfiles/sync.sh "Updated hyprland shortcuts"
```

This will automatically:
1. Refresh `pacman.txt`, `aur.txt`, and `flatpak.txt`.
2. Sync Flatseal overrides.
3. Commit and push everything to GitHub.

---

## 💻 Replicating on a New Device

On a fresh Arch Linux installation:

```bash
# 1. Clone your private repository
git clone https://github.com/uhhuhwho/dotfiles.git ~/dotfiles

# 2. Run the bootstrap installer
cd ~/dotfiles
./bootstrap.sh
```

### What `bootstrap.sh` will do:
1. Safely backup any conflicting default files to `~/.dotfiles_backup_<timestamp>/`.
2. Deploy all symlinks to `~/.config/`, `~/`, `~/.themes/`, and `~/.icons/`.
3. Create a clean `~/.bashrc.local` template for your private keys.
4. Place the active wallpaper into `~/Pictures/Wallpapers/`.
5. Provide an interactive menu to install all your Native packages, AUR utilities (bootstrapping `yay` if needed), and Flatpak applications.

---

## 🔐 Secrets & Machine-Local Configuration

Machine-specific tokens (such as `ANTHROPIC_AUTH_TOKEN`) live in `~/.bashrc.local`:
```bash
# ~/.bashrc.local
export ANTHROPIC_BASE_URL="https://xixiapi.io"
export ANTHROPIC_AUTH_TOKEN="your-secret-token"
```
This file is gitignored and will never be tracked or pushed to remote repositories.
