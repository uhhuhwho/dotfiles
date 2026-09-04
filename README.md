# 🌌 Badreddine's Arch Linux Setup & System Replication Framework

A high-performance, minimalist, zero-copy configuration and full-system replication framework for **Arch Linux** running **Hyprland**, **Wayle**, **Vicinae**, **Kitty**, and **Starship**.

---

## ⚡ Key Highlights & Architecture

- **Zero-Copy Symlinks**: User configurations reside directly in `~/dotfiles/` and are symlinked to `~/.config` and `~`. Editing files in your daily life modifies the Git repo directly with zero copying or exporting required.
- **System-Level Settings Synced**: Preserves critical `/etc` configurations:
  - `/etc/pacman.conf` (Color, ILoveCandy, ParallelDownloads = 5, Multilib, BlackArch)
  - Hardware rules (`thinkpad_acpi.conf`, `ec_sys.conf`, `99-thinklight.rules`, `thinkfan.conf`)
  - Reference bootloader settings (`grub.reference`)
- **Automated Systemd Services Management**:
  - Automatically snapshots all enabled system daemons (`packages/services-system.txt`)
  - Automatically snapshots enabled user daemons (`packages/services-user.txt`)
  - Enables and starts them automatically on a clean machine during bootstrap.
- **Four-Tier Package Management**:
  1. **Standard Arch Linux** (`packages/pacman.txt`)
  2. **BlackArch Security & OSINT** (`packages/blackarch.txt`)
  3. **AUR Packages via yay** (`packages/aur.txt`)
  4. **Flatpaks & Flatseal Permissions** (`packages/flatpak.txt` & `packages/flatpak-overrides/`)
- **Safe Secret Decoupling**: API keys and tokens are isolated in `~/.bashrc.local` (mode `600`, gitignored) and sourced dynamically. Your secrets never touch Git.
- **1-Command Daily Snapshot**: `dotsync` automatically refreshes packages, system settings, services, stages changes, and pushes to GitHub.
- **1-Command Bootstrap**: `bootstrap.sh` non-destructively deploys configs, system settings, services, and packages on any fresh device.

---

## 🖥️ The Desktop Environment & Stack

| Component | Tool / Package | Role & Description |
| :--- | :--- | :--- |
| **Window Manager** | **Hyprland** (`hyprland.lua`) | Dynamic Wayland compositor configured entirely via modern Lua syntax with custom bezier animations, blur, and dwindle layout. |
| **Status Bar & Panel** | **Wayle** (`~/.config/wayle`) | Sleek Wayland bar & system panel providing active workspaces, clock, and battery monitor. |
| **App Launcher & Tools** | **Vicinae** (`~/.config/vicinae`) | High-speed native launcher, command palette, and clipboard history running `zenwritten-dark` theme with 0.8 opacity. |
| **Terminal Emulator** | **Kitty** (`~/.config/kitty`) | Fast GPU-accelerated terminal bound to `SUPER + Z`. |
| **Shell & Prompt** | **Bash + Starship** | Robust Bash environment with fast Starship prompt (`starship.toml`) displaying git status and path context. |
| **Wallpaper Engine** | **Hyprpaper + Waypaper** | Wallpaper switcher daemon cycling curated wallpapers from `~/Pictures/Wallpapers/`. |
| **Night Light** | **Hyprsunset** | Blue-light filter for eye strain reduction. |
| **Idle & Lockscreen** | **Hypridle + Hyprlock** | Automated screen locking and session power management. |
| **GTK & Icon Themes** | **Dracula-pink-accent** | Consistent dark purple/pink styling across GTK3, GTK4, and XWayland apps. |
| **Cursor Theme** | **Future-Cyan-Hyprcursor** | High-DPI Wayland cursor theme with WhiteSur fallback for XWayland apps. |
| **Hardware Tweaks** | **ThinkPad X230 Mods** | Custom ThinkLight keyboard light toggle script, fan controls, and trackpoint tuning. |

---

## ⌨️ Hyprland Keybindings Reference

All keybindings are defined cleanly in `.config/hypr/hyprland.lua`:

### 🚀 Applications & Launchers
- `SUPER + Z` ➔ Launch **Kitty Terminal**
- `SUPER + Space` or `SUPER + R` ➔ Toggle **Vicinae Launcher**
- `SUPER + B` ➔ Open **Clipboard History** (via Vicinae)
- `SUPER + D` ➔ Open **Thunar File Manager**
- `XF86Launch1` (ThinkVantage button) ➔ Toggle **ThinkLight** (`thinklight-toggle.sh`)

### 🪟 Window Management
- `SUPER + Q` ➔ Close active window
- `SUPER + V` ➔ Toggle floating mode
- `SUPER + F` ➔ Toggle fullscreen
- `SUPER + P` ➔ Toggle pseudo-tiling
- `SUPER + Left / Right / Up / Down` ➔ Move focus between windows
- `SUPER + SHIFT + Left / Right / Up / Down` ➔ Swap window positions
- `SUPER + Left Click + Drag` ➔ Move window
- `SUPER + Right Click + Drag` ➔ Resize window

### 🧭 Workspaces & Navigation
- `SUPER + F1` to `SUPER + F5` ➔ Switch to workspaces 1 through 5
- `SUPER + SHIFT + F1` to `SUPER + SHIFT + F5` ➔ Move window to workspace 1 through 5
- `SUPER + E` / `SUPER + A` ➔ Next / Previous workspace
- `SUPER + Mouse Scroll` ➔ Cycle through active workspaces
- `SUPER + S` ➔ Toggle Special Workspace (Scratchpad)
- `SUPER + SHIFT + S` ➔ Move active window to scratchpad
- `SUPER + TAB` ➔ Toggle **Hyprexpo** (Workspace overview grid)

### 📸 Screenshots
- `Print` ➔ Fullscreen screenshot (saved to `~/Pictures/Screenshots/`)
- `SHIFT + Print` ➔ Region select screenshot with `grim` + `slurp`

### 🔊 Audio & Brightness
- `XF86AudioRaiseVolume` / `LowerVolume` ➔ Adjust volume (`wpctl`)
- `XF86AudioMute` / `MicMute` ➔ Toggle mute with notification
- `XF86MonBrightnessUp` / `Down` ➔ Screen brightness (`brightnessctl`)
- `SUPER + Volume Up / Down` ➔ Secondary screen brightness control

---

## 📂 Repository File Tree

```
~/dotfiles/
├── .config/
│   ├── hypr/               # Hyprland (hyprland.lua, lock, idle, paper, sunset, scripts)
│   ├── wayle/              # Wayle status panel & theme settings
│   ├── vicinae/            # Vicinae launcher, search, and clipboard history
│   ├── kitty/              # Kitty terminal configuration
│   ├── fastfetch/          # Fastfetch config & custom Berserker logo
│   ├── waypaper/           # Waypaper wallpaper frontend settings
│   ├── starship.toml       # Starship shell prompt config
│   ├── gtk-3.0/, gtk-4.0/  # GTK themes, colors.css, and settings.ini
│   ├── xsettingsd/         # Cursor and icon scaling for XWayland
│   ├── nvim/               # Neovim editor setup
│   ├── btop/, cava/        # Resource monitor & audio visualizer
│   └── Code/User/          # VS Code settings.json
├── home/
│   ├── .bashrc             # Clean interactive bash config (sources ~/.bashrc.local)
│   ├── .bash_profile       # Login environment
│   ├── .gitconfig          # Git user credentials & settings
│   ├── .gtkrc-2.0          # GTK2 appearance settings
│   └── .face               # Account profile picture
├── system/
│   ├── etc/
│   │   ├── pacman.conf     # Pacman config (ILoveCandy, ParallelDownloads, Multilib, BlackArch)
│   │   └── pacman.d/       # Mirrorlists
│   ├── hardware/thinkpad/  # ThinkPad fan control, ThinkLight udev rules, thinkfan.conf
│   └── boot/grub.reference # Reference GRUB styling configuration
├── themes/                 # Dracula-pink-accent GTK theme
├── icons/                  # Future-Cyan-Hyprcursor, WhiteSur-cursors, default
├── assets/                 # Active ocean balcony wallpaper
├── commands/               # Custom scripts (ThinkPad light, fans, turbo-boost, etc.)
├── packages/
│   ├── pacman.txt          # Standard Arch Linux packages
│   ├── blackarch.txt       # BlackArch security/OSINT tools
│   ├── aur.txt             # AUR packages
│   ├── flatpak.txt         # Flatpak applications
│   ├── flatpak-overrides/  # Custom Flatseal permission profiles
│   ├── services-system.txt # Enabled systemd system services
│   └── services-user.txt   # Enabled systemd user services
├── sync.sh                 # 1-command snapshot script (aliased to `dotsync`)
├── bootstrap.sh            # Automated installer for clean machines
└── .gitignore              # Ignores secrets, caches, and machine-local files
```

---

## ⚙️ System Settings & Services Synced

### 1. `/etc/pacman.conf`
Synced with:
- `Color` and `ILoveCandy` enabled.
- `ParallelDownloads = 5`.
- `[multilib]` enabled for 32-bit compatibility (Wine, Steam).
- `[blackarch]` repository integration.

### 2. Systemd Services
Automatically tracked and restored:
- **Core System**: `NetworkManager`, `bluetooth`, `power-profiles-daemon`, `systemd-timesyncd`, `reflector`, `ufw`.
- **Virtualization & Tools**: `docker`, `libvirtd`, `waydroid-container`, `proton.VPN`.
- **ThinkPad Hardware**: `thinkfan`, `thinkfan-sleep`, `thinkfan-wakeup`.
- **User Daemons**: `hyprpaper`, `vicinae`, `wireplumber`, `pipewire`, `gnome-keyring-daemon`.

---

## 🔄 Daily Backup Workflow

Whenever you change your configurations, install packages, or enable new services:

```bash
dotsync "Description of updates"
```

Behind the scenes, `dotsync`:
1. Separates and writes `pacman.txt` and `blackarch.txt`.
2. Updates `aur.txt`, `flatpak.txt`, and Flatseal overrides.
3. Snapshots all enabled system and user services.
4. Refreshes `/etc/pacman.conf` and hardware configs.
5. Stages all modified dotfiles and pushes to your private GitHub repo (`uhhuhwho/dotfiles`).

### Shell Aliases Included in `.bashrc`:
- `dotsync "msg"` ➔ Snapshot system, packages, commit, and push.
- `dotstatus` ➔ Run `git status` on your dotfiles.
- `dotdiff` ➔ Show changes made to your configs.
- `dotcd` ➔ Quickly `cd` into `~/dotfiles`.

---

## 💻 Replicating on a Fresh Device

To replicate your entire system onto a new machine:

```bash
# 1. Clone your private repository
git clone https://github.com/uhhuhwho/dotfiles.git ~/dotfiles

# 2. Run the bootstrap installer
cd ~/dotfiles
./bootstrap.sh
```

### What `bootstrap.sh` does:
1. **Safety Backup**: Backs up any conflicting files on the target machine to `~/.dotfiles_backup_<timestamp>/`.
2. **User Configurations**: Links all configs, home files, themes, and cursors.
3. **System Settings**: Offers to apply optimized `/etc/pacman.conf` and ThinkPad hardware rules.
4. **Wallpaper & Commands**: Restores active wallpaper to `~/Pictures/Wallpapers/` and scripts to `~/Documents/Commands/`.
5. **Secrets Template**: Generates `~/.bashrc.local` for private API keys.
6. **Package Restore**:
   - `[1] Full System`: Installs Standard Arch, bootstraps BlackArch tools, installs AUR packages via `yay`, restores Flatpaks, and applies Flatseal overrides.
   - `[2] Standard Desktop`: Installs Standard Arch + AUR packages only.
   - `[3] Configs & Settings`: Deploys dotfiles and system settings without packages.
7. **Services Enablement**: Automatically enables and starts your configured system and user systemd services.
