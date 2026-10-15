# 🌌 Badreddine's Multi-Machine Arch Linux & Hyprland Dotfiles

A high-performance, minimalist, zero-copy configuration and multi-machine system replication framework for **Arch Linux** running **Hyprland**, **Wayle**, **Vicinae**, **Kitty**, and **Starship** across multiple laptops (**Honor MagicBook**, **ThinkPad X230**, **ThinkPad X1 Yoga**, **HP Omen**).

---

## ⚡ Key Highlights & Multi-Machine Architecture

- **Zero-Copy Symlinks**: User configurations reside directly in `~/dotfiles/` and are symlinked to `~/.config`, `~/.themes`, `~/.icons`, and `~`. Editing files in your daily workflow modifies the Git repo directly with zero copying required.
- **Hardware-Aware Machine Profiles (`machines/<vendor>/<model>/`)**:
  - `scripts/system/detect-machine.sh` automatically identifies the current laptop via kernel DMI vendor/model and platform drivers (`honor`, `thinkpad/x230`, `thinkpad/x1-yoga`, `hp-omen`).
  - Supports multiple ThinkPads individually: hardware rules, fan profiles, and drivers are separated per model (e.g., ThinkLight udev & `thinkfan` EC rules under `machines/thinkpad/x230/`).
  - **Non-Destructive `dotsync`**: Running `dotsync` on any machine union-merges shared packages and services while writing hardware-specific drivers (`amd-ucode`, `vulkan-radeon`, `intel-ucode`, `vulkan-intel`, `nvidia`) only to `machines/<profile>/`, so syncing on one laptop **never** deletes packages belonging to your other machines (pass `dotsync --prune` if you intentionally wish to prune).
- **Unified Rice (`rice/`)**: GTK themes (`Dracula-pink-accent`) and cursor/icon themes (`Future-Cyan-Hyprcursor_Theme`, `WhiteSur-cursors`, `default`) live together under `rice/themes/` and `rice/icons/`.
- **Docker Compose Stacks Tracked (`docker/`)**: Docker service configurations (`Project-Nomad`, `SillyTavern`) are tracked in Git while excluding container runtime databases and volumes.
- **Categorized Scripts & Cheatsheet (`scripts/`)**:
  - `scripts/system/`: Machine detection, Btrfs Snapper setup, GRUB chroot recovery, and disk mounting.
  - `scripts/desktop/`: Isolated Wayland Antigravity launcher, random wallpaper switcher, and default browser manager.
  - `scripts/hardware/`: Cross-vendor (`common/`) CPU Turbo Boost & Power Profile scripts, plus machine-specific controls (`thinkpad/thinklight-toggle.sh`, `hp-omen/hp-fan-control.py`).
  - `scripts/security/`: Offline GPG AES-256 encrypted backup and restore for SSH keys, GPG, Wi-Fi passwords, and `~/.bashrc.local`.
  - `scripts/NOTES.md`: Consolidated quick-reference cheatsheet for Wayland flags, Vulkan ICD GPU selection, GameMode, NTFS, and Git.

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
├── docker/
│   ├── Project-Nomad/               # Project NOMAD offline digital resilience library compose file
│   └── SillyTavern/                 # SillyTavern local AI frontend compose file
├── machines/
│   ├── honor/                       # Honor MagicBook (HUAWEI HLYL-WXX9 AMD Ryzen + Radeon drivers)
│   ├── thinkpad/
│   │   ├── x230/                    # ThinkPad X230 (Intel drivers, thinkfan, EC sys, 99-thinklight udev)
│   │   └── x1-yoga/                 # ThinkPad X1 Yoga profile
│   └── hp-omen/                     # HP Omen (Intel + NVIDIA drivers & optimus-manager)
├── scripts/
│   ├── NOTES.md                     # Consolidated command & launch-flag cheatsheet
│   ├── system/
│   │   ├── detect-machine.sh        # Hardware-based machine profile detector (honor, thinkpad/*, hp-omen)
│   │   ├── setup-btrfs-snapper.sh   # Automated Btrfs Snapper + snap-pac setup
│   │   ├── fix-grub-chroot.sh       # GRUB UEFI recovery helper for Arch ISO chroot
│   │   └── mount-games-disk.sh      # External/secondary games disk mount helper
│   ├── desktop/
│   │   ├── capslock-watcher.py      # Caps Lock real-time state change watcher daemon (systemd service)
│   │   ├── capslock-notify.sh       # Caps Lock status check & notification helper
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
│   ├── hyprpm.txt                   # Tracked Hyprland plugin repositories
│   ├── npm.txt                      # Global NPM packages
│   ├── uv.txt                       # Python UV CLI tools
│   ├── services-system.txt          # Shared enabled systemd system services
│   └── services-user.txt            # Shared enabled systemd user services
├── ai/
│   ├── agents/                      # Universal agent skill lockfile & rules
│   ├── claude/                      # Claude Code plugins & sanitized settings
│   ├── gemini/                      # Gemini hooks, plugins & Antigravity MCP config
│   └── codex/                       # Codex model configurations
├── sync.sh                          # Multi-machine snapshot & push script (aliased to `dotsync`)
├── bootstrap.sh                     # Hardware-aware installer for fresh machines
└── .gitignore                       # Ignores secrets, caches, and machine-local files
```

---

## 📦 Tools, AppImages & External Applications Catalog (`~/Documents/Apps/`)

All custom and portable applications located in `~/Documents/Apps/` are categorized into 5 clean directories (`AppImages/`, `Standalone/`, `CLI/`, `GitHub/`, and `Archives/`). They have desktop launchers in `~/.local/share/applications/` and icons in `~/.local/share/icons/custom-apps/`, searchable directly from **Vicinae** (`SUPER + Space`).

### 1. 3D & Creative Design
| Tool | Format / Path | Source / Link | Purpose & Notes |
| :--- | :--- | :--- | :--- |
| **Blender 4.2 LTS** | Standalone Suite (`Standalone/Blender/blender-4.2.7-linux-x64/blender`) | [blender.org/download](https://www.blender.org/download/) | Primary 3D modeling, texturing, animation, and rendering suite. Uses isolated `portable/` config. |
| **Blender 3.6 LTS** | Standalone Suite (`Standalone/Blender/blender-3.6.23-linux-x64/blender`) | [blender.org/download/lts/3-6/](https://www.blender.org/download/lts/3-6/) | Legacy LTS version for compatibility with specific mesh add-ons. |
| **Cascadeur** | Standalone Binary (`Standalone/cascadeur-linux/cascadeur`) | [cascadeur.com](https://cascadeur.com/) | AI and physics-assisted 3D character animation software by Nekki. |
| **PureRef** | AppImage (`AppImages/PureRef-2.0.3_x64.Appimage`) | [pureref.com](https://www.pureref.com/) | Standalone reference image viewer and moodboard tool for artists. |
| **Material Maker** | Standalone Binary (`Standalone/material_maker_1_6_linux/material_maker.x86_64`) | [materialmaker.org](https://www.materialmaker.org/) / [GitHub](https://github.com/rodzill4/material-maker) | Procedural PBR texture authoring and 3D painting tool based on the Godot engine. |
| **AutoRemesher** | AppImage (`AppImages/autoremesher-1.0.0.AppImage`) | [GitHub hars/autoremesher](https://github.com/hars/autoremesher) | Automatic quad mesh remeshing tool based on libhedra. |
| **Mesh2Motion** | AppImage (`AppImages/Mesh2Motion_0.1.6_amd64.AppImage`) | [Mesh2Motion](https://itch.io/) | Mesh animation and motion retargeting utility. |
| **Tahoma2D** | AppImage Suite (`AppImages/Tahoma2D/Tahoma2D.AppImage`) | [tahoma2d.org](https://tahoma2d.org/) / [GitHub](https://github.com/tahoma2d/tahoma2d) | Open-source 2D digital animation software derived from OpenToonz. |
| **RawTherapee** | AppImage (`AppImages/RawTherapee_5.12_release.AppImage`) | [rawtherapee.com](https://rawtherapee.com/) | Advanced non-destructive raw photo developer and processor. |
| **ArmorPaint** | GitHub Clone (`GitHub/armorpaint/`) | [armorpaint.org](https://armorpaint.org/) / [GitHub](https://github.com/armory3d/armorpaint) | 3D PBR texture painting software. |

### 2. ArtCraft Creative Suite
| Tool | Format / Path | Description |
| :--- | :--- | :--- |
| **ArtCraft Launcher** | AppImage (`AppImages/ArtCraft/artcraft-0.3.2-linux-x86_64.AppImage`) | Central launcher and manager for the ArtCraft creative suite. |
| **ArtCraft Apps** | Installed AppImages (`~/Applications/*craft*.AppImage`) | 13 specialized creative apps (DesignCraft, PhotoCraft, VectorCraft, FilmCraft, EffectCraft, LightCraft, PDFCraft, CADCraft, DeckCraft, FigCraft, GridCraft, SoundCraft, WordCraft) managed by ArtCraft Launcher. |

### 3. Game Development & Graphics Programming
| Tool | Format / Path | Source / Link | Purpose & Notes |
| :--- | :--- | :--- | :--- |
| **Godot Engine 4** | Standalone Binary (`Standalone/Godot/Godot_v4.7.1-stable_linux.x86_64/...`) | [godotengine.org](https://godotengine.org/) | Standard 2D/3D multi-platform game engine with GDScript. |
| **Godot Engine 4 (Mono)** | Standalone Binary (`Standalone/Godot/Godot_v4.7.1-stable_mono_linux_x86_64/...`) | [godotengine.org/download](https://godotengine.org/) | Godot 4 build with native C# / .NET solution support. |
| **GDstudio** | Standalone Binary (`Standalone/GDstudio-0.3.2-alpha-6403-linux-x86_64/GDstudio`) | [GitHub](https://github.com/) | Dedicated Godot Studio / IDE environment. |
| **KodeLife** | Standalone Binary (`Standalone/kodelife-1.2.6.208-linux-x64/KodeLife`) | [hexler.net/kodelife](https://hexler.net/kodelife) | Real-time GPU shader editor supporting GLSL/HLSL live coding. |

### 4. Security, OSINT & Reverse Engineering (`~/Documents/Apps/GitHub/Security/`)
| Tool | Format / Path | Source / Link | Purpose & How to Run |
| :--- | :--- | :--- | :--- |
| **IDA Free 9.3** | Standalone Binary (`Standalone/ida-free-9.3/ida`) | [hex-rays.com/ida-free](https://hex-rays.com/ida-free/) | Interactive Disassembler & Decompiler for x86-64 binary analysis. |
| **Social-Engineer Toolkit (SEToolkit)** | Python Tool (`GitHub/Security/setoolkit/`) | [GitHub trustedsec/social-engineer-toolkit](https://github.com/trustedsec/social-engineer-toolkit) | Advanced social engineering attack vector framework. Run via `sudo ./setoolkit/.venv/bin/setoolkit`. |
| **God's Eye View** | Node.js Dashboard (`GitHub/Security/gods-eye-view/`) | [GitHub bilawalsidhu/gods-eye-view](https://github.com/bilawalsidhu/gods-eye-view) | Real-time geospatial imagery and situational awareness dashboard. Run via `npm run dev`. |
| **HackingTool** | Python Framework (`GitHub/Security/hackingtool/`) | [GitHub Z4nzu/hackingtool](https://github.com/Z4nzu/hackingtool) | All-in-one hacking tool installer and manager for ethical hacking. |
| **Osintgram** | Python CLI (`GitHub/Security/Osintgram/`) | [GitHub Datalux/Osintgram](https://github.com/Datalux/Osintgram) | Instagram OSINT reconnaissance tool for profile analysis and data extraction. |
| **Seeker** | Python CLI (`GitHub/Security/seeker/`) | [GitHub thewhiteh4t/seeker](https://github.com/thewhiteh4t/seeker) | Accurately geolocates target devices using HTML5 Location API. |
| **CamPhish** | Bash / PHP Server (`GitHub/Security/CamPhish/`) | [GitHub techchipnet/CamPhish](https://github.com/techchipnet/CamPhish) | Webcam phishing reconnaissance framework using ngrok tunneling. |
| **SayCheese** | Bash CLI (`GitHub/Security/saycheese/`) | [GitHub hangetzzu/saycheese](https://github.com/hangetzzu/saycheese) | Webcam grabber tool for security research. |
| **MaskPhish** | Bash CLI (`GitHub/Security/maskphish/`) | [GitHub jaykali/maskphish](https://github.com/jaykali/maskphish) | URL phishing mask script hiding phishing links behind trusted domains. |
| **L0p4Map** | Python CLI (`GitHub/Security/L0p4Map/`) | [GitHub HaxL0p4/L0p4Map](https://github.com/HaxL0p4/L0p4Map) | IP location mapper and reconnaissance utility. |
| **Nuclei** | CLI Binary (`CLI/nuclei_3.11.1_linux_amd64/nuclei` -> `~/.local/bin/nuclei`) | [projectdiscovery.io](https://projectdiscovery.io/) / [GitHub](https://github.com/projectdiscovery/nuclei) | Fast vulnerability scanner based on community YAML templates. |
| **BlackArch Toolset** | Pacman Repo & Scripts (`GitHub/Security/BlackArch/`) | [blackarch.org](https://blackarch.org/) | Official strap bootstrap script and security/OSINT tools list. |

### 5. AI, Productivity & System Utilities
| Tool | Format / Path | Source / Link | Purpose & Notes |
| :--- | :--- | :--- | :--- |
| **LM Studio** | AppImage (`AppImages/LM-Studio-0.4.15-2-x64.AppImage`) | [lmstudio.ai](https://lmstudio.ai/) | Run local LLMs (DeepSeek, Llama 3, Qwen) with hardware acceleration. |
| **OpenClaw** | AppImage (`AppImages/OpenClaw-2026.9.5-amd64.AppImage`) | [openclaw.ai](https://openclaw.ai/) | Agentic AI desktop assistant and tool automation platform. |
| **GenOffice** | AppImage (`AppImages/GenOffice-0.8.440.AppImage`) | [GitHub](https://github.com/) | Generative AI document and workspace client. |
| **Hydra Launcher** | AppImage (`AppImages/hydralauncher-4.0.3.AppImage`) | [hydralinks.cloud](https://hydralinks.cloud/) / [GitHub](https://github.com/hydralauncher/hydra) | Open-source gaming client and catalog launcher. |
| **Epic Games Launcher** | AppImage (`AppImages/EpicGamesLauncher-x86_64.AppImage`) | [GitHub egl-v2](https://github.com/) / [epicgames.com](https://store.epicgames.com/) | Portable Epic Games Launcher & Unreal store client. Launches via `epic-games-launcher` or Vicinae launcher. |
| **SourceGit** | AppImage (`AppImages/sourcegit-2026.15.linux.amd64.AppImage`) | [sourcegit-scm.github.io](https://sourcegit-scm.github.io/) / [GitHub](https://github.com/sourcegit-scm/sourcegit) | Fast, lightweight Git GUI client for Linux. |
| **Redact** | AppImage (`AppImages/Redact-0.21.23.AppImage`) | [redact.dev](https://redact.dev/) | Privacy utility to mass-delete old posts and messages across social networks. |
| **World Monitor** | AppImage (`AppImages/World.Monitor_2.5.23_amd64.AppImage`) | [GitHub](https://github.com/) | Real-time global intelligence, news, and conflict monitoring feed. |
| **Winboat** | AppImage (`AppImages/winboat-0.9.0-x86_64.AppImage`) | [GitHub](https://github.com/) | Portable cross-platform helper utility. |
| **AnyDesk** | Standalone Binary (`Standalone/anydesk-8.0.2/anydesk`) | [anydesk.com](https://anydesk.com/) | Fast remote desktop and unattended access client. |
| **balenaEtcher** | Standalone Binary (`Standalone/balenaEtcher-linux-x64/balena-etcher`) | [etcher.balena.io](https://etcher.balena.io/) | Flashes OS images (.iso, .img) to USB flash drives and SD cards safely. |
| **Ventoy GUI** | Standalone Binary (`Standalone/ventoy-1.1.14/VentoyGUI.x86_64`) | [ventoy.net](https://ventoy.net/) / [GitHub](https://github.com/ventoy/Ventoy) | Multiboot USB creator. Launches via `pkexec` for block device access. |
| **JetBrains Toolbox** | Standalone Binary (`Standalone/jetbrains-toolbox-3.4.3.81140/bin/jetbrains-toolbox`) | [jetbrains.com/toolbox-app](https://www.jetbrains.com/toolbox-app/) | Manages JetBrains IDEs, CLI tools, and project workspaces. |
| **Antigravity IDE** | Standalone Binary (`Standalone/Antigravity-x64/antigravity`) | Google DeepMind | Next-generation agentic AI coding environment. |
| **RAR / UnRAR** | CLI Binaries (`CLI/rar/rar`, `CLI/rar/unrar`) | [rarlab.com](https://www.rarlab.com/) | Official archive manager for `.rar` compression and extraction. |
| **Ngrok** | CLI Binary (`/usr/sbin/ngrok`) | [ngrok.com](https://ngrok.com/) | Secure public URLs for exposing local development servers. |

### 6. Original Archives & Installers (`~/Documents/Apps/Archives/`)
| Archive | Format | Description |
| :--- | :--- | :--- |
| `GDstudio-0.3.2-alpha-6403-linux-x86_64.tar.gz` | tar.gz | Compressed distribution tarball for GDstudio. |
| `ngrok-v3-stable-linux-amd64.tgz` | tgz | Upstream release archive for Ngrok v3. |
| `nuclei_3.11.1_linux_amd64.zip` | zip | Upstream distribution zip for Nuclei v3.11.1. |

### 7. Docker Stacks (`~/Documents/Docker/` ➔ `~/dotfiles/docker/`)
| Stack | Compose Path | Upstream Repository | Purpose |
| :--- | :--- | :--- | :--- |
| **Project NOMAD** | `docker/Project-Nomad/docker-compose.yml` | [project-nomad.net](https://project-nomad.net/) / [GitHub](https://github.com/crosstalk-solutions/project-nomad) | Self-contained, offline digital resilience library and knowledge hub. |
| **SillyTavern** | `docker/SillyTavern/docker-compose.yml` | [sillytavern.app](https://sillytavern.app/) / [GitHub](https://github.com/SillyTavern/SillyTavern) | User interface for local LLM character conversation and AI roleplay. |

---

## 🖥️ Hyprland & Desktop Experience

- **Workspace Navigation & Hymission Alt+Tab**:
  - `ALT + TAB` ➔ Cycle smoothly between active windows across workspaces with **Hymission**.
  - `ALT + SHIFT + TAB` or `SUPER + TAB` ➔ Open Mission Control overview with a top workspace strip for visual drag-and-drop window repositioning across workspaces.
  - **8 Persistent Workspaces**: Workspaces 1 through 8 are permanently visible in Wayle (`min-workspace-count = 8`) and directly switchable with `SUPER + 1..8` or `SUPER + F1..F8`, with window moving via `SUPER + SHIFT + 1..8` / `SUPER + SHIFT + F1..F8`.
- **Flameshot Wayland Screenshots**:
  - `SHIFT + Print` ➔ Region screenshot with interactive annotations, drawings, arrows, text, and copy-to-clipboard (`flameshot gui`).
  - `Print` ➔ Full screenshot automatically copied to clipboard and saved to `~/Pictures/Screenshots/`.
  - Configured with XDG Desktop Portal integration and Hyprland floating window rules.
- **Caps Lock State Notifications**:
  - Background systemd user service (`capslock-watcher.service`) provides real-time "Caps Lock is ON" and "Caps Lock is OFF" desktop popups via sysfs hardware LED monitoring.
  - Wayle native toggle OSD enabled for users in the `input` group (`sudo usermod -aG input $USER`).
- **HyprPM Plugin Tracking**: Automatically tracks installed Hyprland plugins (`hymission`, `hyprglass`) in `packages/hyprpm.txt` during `dotsync`, and auto-restores them on fresh machines via `bootstrap.sh`.
- **System-Wide Icon Consistency**: Enforces Oxygen icons across GTK 3/4, KDE globals, and XSettings daemon.

---

## 🔄 Daily Multi-Machine Workflow

Whenever you change configurations, install packages, or enable new services on **any** of your laptops:

```bash
dotsync "Description of updates"
```

### Shell Aliases Included in `.bashrc`:
- `dotsync "msg"` ➔ Snapshot machine profile + shared packages, commit, and push.
- `dotsync --prune "msg"` ➔ Prune shared package lists to match only currently installed packages.
- `dotmachine` ➔ Show detected hardware profile (`honor`, `thinkpad/x230`, `thinkpad/x1-yoga`, `hp-omen`).
- `dotstatus` / `dotdiff` / `dotcd` ➔ Inspect or jump into `~/dotfiles`.
- `temp` ➔ Hardware-aware CPU/GPU thermal, frequency, and fan monitor (AMD, Intel, NVIDIA).
- `turbo [status|enable|disable|toggle]` ➔ Control CPU Turbo Boost (AMD & Intel).
- `pprofile [status|cycle|performance|balanced|power-saver]` ➔ Switch power profiles.
- `fans [toggle|status|max|auto]` ➔ Control HP Omen fans.
