# 🌌 Badreddine's Multi-Machine Arch Linux & Hyprland Dotfiles

A high-performance, minimalist, zero-copy configuration and multi-machine system replication framework for **Arch Linux** running **Hyprland**, **Wayle**, **Vicinae**, **Kitty**, and **Starship** across multiple laptops (**Honor MagicBook**, **ThinkPad X230**, **HP Omen**).

---

## ⚡ Key Highlights & Multi-Machine Architecture

- **Zero-Copy Symlinks**: User configurations reside directly in `~/dotfiles/` and are symlinked to `~/.config`, `~/.themes`, `~/.icons`, and `~`. Editing files in your daily workflow modifies the Git repo directly with zero copying required.
- **Hardware-Aware Machine Profiles (`machines/<profile>/`)**:
  - `scripts/system/detect-machine.sh` automatically identifies the current laptop via kernel DMI vendor/model and platform drivers (`honor`, `thinkpad`, `hp-omen`).
  - Hardware-specific drivers (e.g., `amd-ucode` + `vulkan-radeon` on Honor vs `intel-ucode` + `vulkan-intel` + `thinkfan` on ThinkPad vs `nvidia` + `optimus-manager` on HP Omen), kernel module rules, and hardware services are isolated under `machines/<profile>/`.
  - **Non-Destructive `dotsync`**: Running `dotsync` on any machine union-merges shared packages and services while writing hardware-specific items only to `machines/<current-machine>/`, so syncing on a new laptop **never** overwrites or deletes packages belonging to your other machines (pass `dotsync --prune` only when you intentionally want to prune the shared lists to match the active machine).
- **Unified Rice (`rice/`)**: GTK themes (`Dracula-pink-accent`) and cursor/icon themes (`Future-Cyan-Hyprcursor_Theme`, `WhiteSur-cursors`, `default`) live cleanly together under `rice/themes/` and `rice/icons/`.
- **Categorized Scripts & Cheatsheet (`scripts/`)**:
  - `scripts/system/`: Machine detection, Btrfs Snapper setup, GRUB chroot recovery, and disk mounting.
  - `scripts/desktop/`: Isolated Wayland Antigravity launcher, random wallpaper switcher, and default browser manager.
  - `scripts/hardware/`: Cross-vendor (`common/`) CPU Turbo Boost & Power Profile scripts, plus machine-specific controls (`thinkpad/thinklight-toggle.sh`, `hp-omen/hp-fan-control.py`).
  - `scripts/security/`: Offline GPG AES-256 encrypted backup and restore for SSH keys, GPG, Wi-Fi passwords, and `~/.bashrc.local`.
  - `scripts/NOTES.md`: Consolidated quick-reference cheatsheet for Wayland flags, Vulkan ICD GPU selection, GameMode, NTFS, and Git.
- **Comprehensive Package & Tool Management**:
  1. **Shared Standard Arch Linux** (`packages/pacman.txt`) + **Machine Drivers** (`machines/<profile>/pacman.txt`)
  2. **BlackArch Security & OSINT** (`packages/blackarch.txt`)
  3. **Shared AUR Packages** (`packages/aur.txt`) + **Machine AUR** (`machines/<profile>/aur.txt`)
  4. **Flatpaks & Flatseal Permissions** (`packages/flatpak.txt` & `packages/flatpak-overrides/`)
  5. **Global NPM Packages** (`packages/npm.txt` via `~/.npm-global`)
  6. **Python UV Tools** (`packages/uv.txt` via `uv tool`)
- **Safe Secret Decoupling**: API keys and tokens are isolated in `~/.bashrc.local` (mode `600`, gitignored) and sourced dynamically.

---

## 🖥️ The Desktop Environment & Stack

| Component | Tool / Package | Role & Description |
| :--- | :--- | :--- |
| **Window Manager** | **Hyprland** (`hyprland.lua`) | Dynamic Wayland compositor configured via modern Lua syntax with multi-device touchpad/TrackPoint rules. |
| **Status Bar & Panel** | **Wayle** (`~/.config/wayle`) | Sleek Wayland bar & system panel providing active workspaces, clock, and battery monitor. |
| **App Launcher & Tools** | **Vicinae** (`~/.config/vicinae`) | High-speed native launcher, command palette, and clipboard history running `zenwritten-dark` theme. |
| **Terminal Emulator** | **Kitty** (`~/.config/kitty`) | Fast GPU-accelerated terminal bound to `SUPER + Z`. |
| **Shell & Prompt** | **Bash + Starship** | Robust Bash environment with hardware-aware `temp` monitor and fast Starship prompt (`starship.toml`). |
| **Wallpaper Engine** | **Hyprpaper + Waypaper** | Wallpaper switcher daemon cycling wallpapers from `~/Pictures/Wallpapers/`. |
| **Night Light** | **Hyprsunset** | Blue-light filter for eye strain reduction. |
| **Idle & Lockscreen** | **Hypridle + Hyprlock** | Automated screen locking and session power management. |
| **Rice (Themes & Icons)** | **Dracula-pink + Future-Cyan** | Unified dark styling (`rice/themes/`) and Wayland/XWayland cursors (`rice/icons/`). |

---

## 📂 Repository File Tree

```
~/dotfiles/
├── .config/
│   ├── hypr/                        # Hyprland (hyprland.lua, lock, idle, paper, sunset, scripts)
│   ├── wayle/                       # Wayle status panel & theme settings
│   ├── vicinae/                     # Vicinae launcher, search, and clipboard history
│   ├── kitty/                       # Kitty terminal configuration
│   ├── fastfetch/                   # Fastfetch config & custom Berserker logo
│   ├── waypaper/                    # Waypaper wallpaper frontend settings
│   ├── starship.toml                # Starship shell prompt config
│   ├── gtk-3.0/, gtk-4.0/           # GTK themes, colors.css, and settings.ini
│   ├── xsettingsd/                  # Cursor and icon scaling for XWayland
│   ├── nvim/                        # Neovim editor setup
│   ├── btop/, cava/                 # Resource monitor & audio visualizer
│   └── Code/User/                   # VS Code settings.json
├── home/
│   ├── .bashrc                      # Interactive bash config (multi-machine temp/aliases, sources ~/.bashrc.local)
│   ├── .bash_profile                # Login environment
│   ├── .gitconfig                   # Git user credentials & settings
│   ├── .gtkrc-2.0                   # GTK2 appearance settings
│   └── .face                        # Account profile picture
├── rice/
│   ├── themes/                      # Dracula-pink-accent GTK theme (-> ~/.themes/)
│   └── icons/                       # Future-Cyan-Hyprcursor, WhiteSur-cursors, default (-> ~/.icons/)
├── scripts/
│   ├── NOTES.md                     # Consolidated command & launch-flag cheatsheet
│   ├── system/
│   │   ├── detect-machine.sh        # Hardware-based machine profile detector (honor, thinkpad, hp-omen)
│   │   ├── setup-btrfs-snapper.sh   # Automated Btrfs Snapper + snap-pac setup
│   │   ├── fix-grub-chroot.sh       # GRUB UEFI recovery helper for Arch ISO chroot
│   │   └── mount-games-disk.sh      # External/secondary games disk mount helper
│   ├── desktop/
│   │   ├── launch-antigravity.sh    # Isolated systemd-scope Wayland launcher for Antigravity
│   │   ├── random-wallpaper.sh      # Random wallpaper switcher via hyprpaper/waypaper
│   │   └── set-default-browser.sh   # XDG default web browser setter
│   ├── hardware/
│   │   ├── common/
│   │   │   ├── cpu-turbo-boost.sh   # Intel & AMD CPU turbo boost toggle/status CLI
│   │   │   └── power-profile.sh     # Power-profiles-daemon status/set/cycle CLI
│   │   ├── thinkpad/
│   │   │   └── thinklight-toggle.sh # ThinkPad X230 EC 0x3B ThinkLight toggle
│   │   └── hp-omen/
│   │       └── hp-fan-control.py    # HP Omen hp-wmi fan status/auto/max/toggle CLI
│   └── security/
│       ├── backup-secrets-offline.sh  # Encrypted GPG offline backup of SSH, GPG, Wi-Fi & .bashrc.local
│       └── restore-secrets-offline.sh # Decrypt & restore offline secrets archive
├── machines/
│   ├── honor/                       # Honor MagicBook (AMD Ryzen + Radeon drivers & services)
│   ├── thinkpad/                    # ThinkPad X230 (Intel drivers, thinkfan, udev & modprobe rules)
│   └── hp-omen/                     # HP Omen (Intel + NVIDIA drivers & optimus-manager)
├── system/
│   ├── etc/
│   │   ├── pacman.conf              # Pacman config (ILoveCandy, ParallelDownloads, Multilib, BlackArch)
│   │   ├── pacman.d/                # Mirrorlists
│   │   └── snapper/                 # Btrfs Snapper root retention policy
│   ├── dconf-settings.ini           # Dconf desktop preferences snapshot
│   └── boot/grub.reference          # Reference GRUB styling configuration
├── packages/
│   ├── pacman.txt                   # Shared Standard Arch Linux packages
│   ├── blackarch.txt                # Shared BlackArch security/OSINT tools
│   ├── aur.txt                      # Shared AUR packages
│   ├── flatpak.txt                  # Shared Flatpak applications
│   ├── flatpak-overrides/           # Custom Flatseal permission profiles
│   ├── npm.txt                      # Global NPM packages
│   ├── uv.txt                       # Python UV CLI tools
│   ├── services-system.txt          # Shared enabled systemd system services
│   └── services-user.txt            # Shared enabled systemd user services
├── ai/
│   ├── agents/                      # Universal agent skill lockfile & rules
│   ├── claude/                      # Claude Code plugins & sanitized settings
│   ├── gemini/                      # Gemini hooks, plugins & Antigravity MCP config
│   ├── cursor/                      # Cursor MCP settings & skill manifest
│   └── codex/                       # Codex model configurations
├── sync.sh                          # Multi-machine snapshot & push script (aliased to `dotsync`)
├── bootstrap.sh                     # Hardware-aware installer for fresh machines
└── .gitignore                       # Ignores secrets, caches, and machine-local files
```

---

## 🔄 Daily Multi-Machine Workflow

Whenever you change configurations, install packages, or enable new services on **any** of your laptops:

```bash
dotsync "Description of updates"
```

### Shell Aliases Included in `.bashrc`:
- `dotsync "msg"` ➔ Snapshot machine profile + shared packages, commit, and push.
- `dotsync --prune "msg"` ➔ Prune shared package lists to match only currently installed packages.
- `dotmachine` ➔ Show detected hardware profile (`honor`, `thinkpad`, `hp-omen`).
- `dotstatus` / `dotdiff` / `dotcd` ➔ Inspect or jump into `~/dotfiles`.
- `temp` ➔ Hardware-aware CPU/GPU thermal, frequency, and fan monitor (AMD, Intel, NVIDIA).
- `turbo [status|enable|disable|toggle]` ➔ Control CPU Turbo Boost (AMD & Intel).
- `pprofile [status|cycle|performance|balanced|power-saver]` ➔ Switch power profiles.
- `fans [toggle|status|max|auto]` ➔ Control HP Omen fans.
