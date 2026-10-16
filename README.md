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
│   ├── xdg-desktop-portal/          # XDG Desktop Portal backend preferences (hyprland-portals.conf)
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
│   ├── icons/                       # Future-Cyan-Hyprcursor, WhiteSur-cursors, default (-> ~/.icons/)
│   └── plymouth/                    # Plymouth boot splash themes (cuts_alt with Arch Linux logo)
├── docker/
│   ├── OpenClaw/                    # OpenClaw agentic AI assistant container & gateway
│   ├── openGym/                     # openGym self-hosted fitness tracking & AI coach stack
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
│   │   ├── setup-ly-plymouth.sh     # Scaled Ly DM (Doom fire) & Plymouth (Cuts Alt) installer
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
│   │   ├── ly/                      # Ly display manager config (Doom fire, big clock, 2x scaled geometry)
│   │   ├── vconsole.conf            # Virtual console font scaling (ter-v32n)
│   │   ├── pacman.conf              # Pacman config (ILoveCandy, ParallelDownloads, Multilib, BlackArch)
│   │   ├── pacman.d/                # Mirrorlists
│   │   ├── snapper/                 # Btrfs Snapper root retention policy
│   │   └── mkinitcpio.conf.reference# Reference initramfs with early KMS & plymouth hook
│   ├── dconf-settings.ini           # Dconf desktop preferences snapshot
│   └── boot/
│       ├── grub.reference           # Reference GRUB styling configuration
│       └── grub.default.reference   # Reference /etc/default/grub with splash parameter
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
| **Blender 4.2.24** | Standalone Suite (`Standalone/Blender/blender-4.2.23-linux-x64/blender`) | [blender.org/download](https://www.blender.org/download/) | Primary 3D modeling, texturing, animation, and rendering suite. Uses isolated `portable/` config. |
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
| **LM Studio** | AppImage (`AppImages/LM-Studio-0.4.26-4-x64.AppImage`) | [lmstudio.ai](https://lmstudio.ai/) | Run local LLMs (DeepSeek, Llama 3, Qwen) with hardware acceleration. |
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

### 6. Node / NPM & NPX CLI Tools (`~/.npm-global/bin/` & `packages/npm.txt`)
| Tool | Format / Path | Source / Link | Purpose & How to Run |
| :--- | :--- | :--- | :--- |
| **`rea-agents` (`rea`)** | Global NPM / NPX (`~/.npm-global/bin/rea`, `~/.npm-global/bin/rea-agents`) | [npmjs.com/package/rea-agents](https://www.npmjs.com/package/rea-agents) / [GitHub](https://github.com/) | **Reverse Engineer Anything (REA)** agent toolkit. Reverse engineers native binaries, Electron apps, browser bundles, Android APKs, and firmware. Auto-configures REA skills and MCP tools across Claude, Gemini, and Codex. Run via `rea`, `rea-agents`, or `npx rea-agents@latest setup`. |
| **`oh-my-mermaid` (`omm`)** | Global NPM (`~/.npm-global/bin/omm`) | [npmjs.com/package/oh-my-mermaid](https://www.npmjs.com/package/oh-my-mermaid) | Command-line CLI tool to render, preview, and generate Mermaid diagrams and SVG/PNG charts directly from markdown or code. |
| **`omniroute`** | Global NPM (`~/.npm-global/bin/omniroute`) | [npmjs.com/package/omniroute](https://www.npmjs.com/package/omniroute) | Multi-provider AI model proxy and API routing gateway for routing LLM traffic across providers. |
| **`@electron/asar`** | System NPM (`/usr/bin/asar`) | [npmjs.com/package/@electron/asar](https://www.npmjs.com/package/@electron/asar) | Electron Archive unpacker and inspector for inspecting `.asar` bundles inside Electron desktop applications. |

### 7. Python UV CLI Tools (`packages/uv.txt`)
| Tool | Format / Path | Source / Link | Purpose & How to Run |
| :--- | :--- | :--- | :--- |
| **`hackingtool`** | UV Tool (`~/.local/bin/hackingtool`) | [GitHub Z4nzu/hackingtool](https://github.com/Z4nzu/hackingtool) | Ethical hacking all-in-one suite. Installed via `uv tool install hackingtool`. |
| **`mvt` (Mobile Verification Toolkit)** | UV Tool (`~/.local/bin/mvt-*`) | [mvt-project/mvt](https://github.com/mvt-project/mvt) | Forensic analysis toolkit to inspect Android and iOS devices for potential malware and Pegasus spyware indicators. |
| **`pixelrag`** | UV Tool (`~/.local/bin/pixelrag`) | [PyPI pixelrag](https://pypi.org/project/pixelrag/) | Local multimodal RAG (Retrieval-Augmented Generation) document search and indexing tool. |

### 8. Original Archives & Installers (`~/Documents/Apps/Archives/`)
| Archive | Format | Description |
| :--- | :--- | :--- |
| `GDstudio-0.3.2-alpha-6403-linux-x86_64.tar.gz` | tar.gz | Compressed distribution tarball for GDstudio. |
| `ngrok-v3-stable-linux-amd64.tgz` | tgz | Upstream release archive for Ngrok v3. |
| `nuclei_3.11.1_linux_amd64.zip` | zip | Upstream distribution zip for Nuclei v3.11.1. |

### 9. Docker Stacks (`~/Documents/Docker/` ➔ `~/dotfiles/docker/`)
| Stack | Compose Path | Upstream Repository | Purpose |
| :--- | :--- | :--- | :--- |
| **OpenClaw** | `docker/OpenClaw/docker-compose.yml` | [openclaw.ai](https://openclaw.ai/) / [GitHub](https://github.com/openclaw/openclaw) | Agentic AI desktop assistant gateway container (`ghcr.io/openclaw/openclaw`). Run via `./start.sh` or `docker compose up -d`. |
| **openGym** | `docker/openGym/docker-compose.yml` | [GitHub duartesantos8/opengym](https://github.com/duartesantos8/opengym) | Self-hosted fitness, workout logging, and AI coaching platform with passkey authentication and clean web UI. |
| **Project NOMAD** | `docker/Project-Nomad/docker-compose.yml` | [project-nomad.net](https://project-nomad.net/) / [GitHub](https://github.com/crosstalk-solutions/project-nomad) | Self-contained, offline digital resilience library and knowledge hub. |
| **SillyTavern** | `docker/SillyTavern/docker-compose.yml` | [sillytavern.app](https://sillytavern.app/) / [GitHub](https://github.com/SillyTavern/SillyTavern) | User interface for local LLM character conversation and AI roleplay. |

---

## 📦 Explicitly Installed Packages & AUR Directory

Complete inventory of all explicitly installed packages on the system (`pacman -Qe` and `yay`), organized into logical categories with a concise description of what each package does.

### 🏛️ Official Arch Linux Packages (`pacman -Qen` — 311 packages)

#### Desktop Environments, Wayland Compositors & Shell Tools (46 packages)
| Package | Purpose / Description |
| :--- | :--- |
| **`brightnessctl`** | Lightweight brightness control tool |
| **`cliphist`** | wayland clipboard manager |
| **`drkonqi`** | The KDE crash handler |
| **`grim`** | Screenshot utility for Wayland |
| **`hypridle`** | hyprland’s idle daemon |
| **`hyprland`** | a highly customizable dynamic tiling Wayland compositor |
| **`hyprlock`** | hyprland’s GPU-accelerated screen locking utility |
| **`hyprpaper`** | a blazing fast wayland wallpaper utility with IPC controls |
| **`hyprpicker`** | A wlroots-compatible Wayland color picker that does not suck |
| **`hyprpm`** | Plugin manager for Hyprland |
| **`hyprpolkitagent`** | Simple polkit authentication agent for Hyprland, written in QT/QML |
| **`hyprpwcenter`** | A GUI Pipewire control center |
| **`hyprsunset`** | An application to enable a blue-light filter on Hyprland |
| **`kde-gtk-config`** | Syncs KDE settings to GTK applications |
| **`kdeplasma-addons`** | All kind of addons to improve your Plasma experience |
| **`kinfocenter`** | A utility that provides information about a computer system |
| **`kscreen`** | KDE screen management software |
| **`kwallet-pam`** | KWallet PAM integration |
| **`kwrited`** | KDE daemon listening for wall and write messages |
| **`mako`** | Lightweight notification daemon for Wayland |
| **`nwg-look`** | GTK settings editor adapted to work on wlroots-based compositors |
| **`plasma-bigscreen`** | Plasma shell for TVs |
| **`plasma-browser-integration`** | Components necessary to integrate browsers into the Plasma Desktop |
| **`plasma-desktop`** | KDE Plasma Desktop |
| **`plasma-disks`** | Monitors S.M.A.R.T. capable devices for imminent failure |
| **`plasma-firewall`** | Control Panel for your system firewall |
| **`plasma-keyboard`** | Virtual Keyboard for Qt based desktops |
| **`plasma-login-manager`** | Plasma Login Manager |
| **`plasma-nm`** | Plasma applet written in QML for managing network connections |
| **`plasma-pa`** | Plasma applet for audio volume management using PulseAudio |
| **`plasma-sdk`** | Applications useful for Plasma development |
| **`plasma-systemmonitor`** | An interface for monitoring system sensors, process information and other system resources |
| **`plasma-thunderbolt`** | Plasma integration for controlling Thunderbolt devices |
| **`plasma-vault`** | Plasma applet and services for creating encrypted vaults |
| **`plasma-welcome`** | A friendly onboarding wizard for Plasma |
| **`plasma-workspace-wallpapers`** | Additional wallpapers for the Plasma Workspace |
| **`plymouth-kcm`** | KCM to manage the Plymouth (Boot) theme |
| **`qt6-wayland`** | Provides APIs for Wayland |
| **`quickshell`** | Flexible toolkit for making desktop shells with QtQuick |
| **`sddm-kcm`** | KDE Config Module for SDDM |
| **`slurp`** | Select a region in a Wayland compositor |
| **`spectacle`** | KDE screenshot capture utility |
| **`wdisplays`** | Graphical application for configuring Wayland displays |
| **`wev`** | A tool for debugging wayland events on a Wayland window, analagous to the X11 tool xev |
| **`wl-clipboard`** | Command-line copy/paste utilities for Wayland |
| **`xdg-desktop-portal-hyprland`** | xdg-desktop-portal backend for hyprland |

#### Security, Forensics, Reverse Engineering & OSINT (34 packages)
| Package | Purpose / Description |
| :--- | :--- |
| **`aircrack-ng`** | Key cracker for the 802.11 WEP and WPA-PSK protocols |
| **`androguard`** | Reverse engineering, Malware and goodware analysis of Android applications and more. |
| **`android-apktool`** | A tool for reverse engineering Android apk files. |
| **`apkleaks`** | Scanning APK file for URIs, endpoints & secrets. |
| **`apkstudio`** | An IDE for decompiling/editing & then recompiling of android application binaries. |
| **`blackarch-keyring`** | BlackArch Linux PGP keyring. |
| **`blackarch-mirrorlist`** | BlackArch Linux mirror list file. |
| **`detect-it-easy`** | A program for determining types of files. |
| **`dmde`** | Disk Editor and Data Recovery Software. |
| **`dotpeek`** | Free .NET Decompiler and Assembly Browser. |
| **`email2phonenumber`** | A OSINT tool to obtain a target's phone number just by having his email address. |
| **`foremost`** | A console program to recover files based on their headers, footers, and internal data structures |
| **`ghidra`** | Software reverse engineering framework |
| **`httrack`** | An easy-to-use offline browser utility |
| **`maigret`** | OSINT username checker. Collect a dossier on a person by username from a huge number of sites. |
| **`metasploit`** | Advanced open-source platform for developing, testing, and using exploit code |
| **`mimikatz`** | A little tool to play with Windows security. |
| **`mobsf`** | An intelligent, all-in-one open source mobile application (Android/iOS) automated pen-testing framework capable of performing static, dynamic analysis and web API testing. |
| **`nmap`** | Utility for network discovery and security auditing |
| **`phoneinfoga`** | Information gathering & OSINT framework for phone numbers. |
| **`radare2`** | Open-source tools to disasm, debug, analyze and manipulate binary files |
| **`recon-ng`** | A full-featured Web Reconnaissance framework written in Python. |
| **`rz-cutter`** | Qt and C++ GUI for rizin reverse engineering framework |
| **`rz-ghidra`** | Deep ghidra decompiler integration for rizin and rz-cutter |
| **`seekr`** | A multi-purpose OSINT toolkit with a neat web-interface. |
| **`sherlock`** | Find usernames across social networks. |
| **`sniffnet`** | Application to comfortably monitor your network traffic |
| **`social-analyzer`** | Analyzing & finding a person's profile across social media websites. |
| **`trape`** | People tracker on the Internet: OSINT analysis and research tool by Jose Pino. |
| **`user-scanner`** | OSINT tool that analyzes username and email presence across multiple platforms, intended for security research, investigations, legitimate analysis. |
| **`wavemon`** | Ncurses-based monitoring application for wireless network devices |
| **`whatbreach`** | OSINT tool to find breached emails and databases. |
| **`wireshark-qt`** | Network traffic and protocol analyzer/sniffer - Qt GUI |
| **`zenmap`** | Utility for network discovery and security auditing (GUI) |

#### Software Development, Compilers, Debuggers & AI CLI (59 packages)
| Package | Purpose / Description |
| :--- | :--- |
| **`assimp`** | Library to import various well-known 3D model formats in an uniform manner |
| **`base-devel`** | Basic tools to build Arch Linux packages |
| **`cgdb`** | Curses-based interface to the GNU Debugger |
| **`clang`** | C language family frontend for LLVM |
| **`cmake`** | A cross-platform open-source make system |
| **`cppcheck`** | A tool for static C/C++ code analysis |
| **`directx-shader-compiler`** | Compiler for HLSL to DXIL (DirectX Intermediate Language) |
| **`dotnet-sdk`** | The .NET Core SDK |
| **`doxygen`** | Documentation system for C++, C, Java, IDL and PHP |
| **`freecad`** | Feature based parametric 3D CAD modeler |
| **`gemini-cli`** | Open-source AI agent that brings the power of Gemini directly into your terminal |
| **`ggml-vulkan`** | Tensor library for machine learning |
| **`git`** | the fast distributed version control system |
| **`github-cli`** | The GitHub CLI |
| **`glad`** | Multi-Language Vulkan/GL/GLES/EGL/GLX/WGL Loader-Generator based on the official specs |
| **`hugo`** | Fast and Flexible Static Site Generator in Go |
| **`jdk21-openjdk`** | OpenJDK Java 21 development kit |
| **`kdevelop`** | C++ IDE using KDE technologies |
| **`kommit`** | Git gui client |
| **`lazygit`** | Simple terminal UI for git commands |
| **`lib32-vulkan-radeon`** | Open-source Vulkan driver for AMD GPUs - 32-bit |
| **`libc++`** | LLVM C++ standard library |
| **`libc++abi`** | Low level support for the LLVM C++ standard library |
| **`llama-cpp`** | LLM inference in C/C++ |
| **`lld`** | Linker from the LLVM project |
| **`lldb`** | Next generation, high-performance debugger |
| **`mesa`** | Open-source OpenGL drivers |
| **`mesa-utils`** | Essential Mesa utilities |
| **`nano`** | Pico editor clone with enhancements |
| **`neovim`** | Fork of Vim aiming to improve user experience, plugins, and GUIs |
| **`npm`** | JavaScript package manager |
| **`ollama`** | Create, run and share large language models (LLMs) |
| **`openai-codex`** | OpenAIs lightweight coding agent that runs in your terminal |
| **`opengl-man-pages`** | OpenGL Man Pages - OpenGL 4.x |
| **`php`** | A general-purpose scripting language that is especially suited to web development |
| **`pyenv`** | Easily switch between multiple versions of Python |
| **`python-virtualenv`** | Virtual Python Environment builder |
| **`qtcreator`** | Lightweight, cross-platform integrated development environment |
| **`renderdoc`** | OpenGL and Vulkan debugging tool |
| **`scons`** | Extensible Python-based build utility |
| **`sdl3_image`** | SDL3 image loading library |
| **`sdl3_mixer`** | A simple multi-channel audio mixer (Version 3) |
| **`sdl3_ttf`** | A library that allows you to use TrueType fonts in your SDL applications (Version 3) |
| **`spirv-cross`** | Tool and library for parsing and converting SPIR-V to other shader languages |
| **`spirv-headers`** | SPIR-V header files and registry |
| **`stb`** | Single-file public domain (or MIT licensed) libraries for C/C++ |
| **`tiled`** | A general purpose tile map editor, built to be flexible and easy to use |
| **`tinyxxd`** | Standalone version of the hex dump utility that comes with ViM |
| **`uv`** | An extremely fast Python package installer and resolver written in Rust |
| **`volk`** | Meta loader for Vulkan API |
| **`vulkan-extra-layers`** | Extra layers for Vulkan development |
| **`vulkan-extra-tools`** | Vulkan Configurator and Installation Analyzer |
| **`vulkan-headers`** | Vulkan header files and API registry |
| **`vulkan-html-docs`** | Vulkan and Vulkan SC API Documentation - HTML |
| **`vulkan-profiles`** | Vulkan profiles tools |
| **`vulkan-radeon`** | Open-source Vulkan driver for AMD GPUs |
| **`vulkan-tools`** | Vulkan tools and utilities |
| **`vulkan-utility-libraries`** | Vulkan Utility Libraries |
| **`vulkan-validation-layers`** | Vulkan Validation Layers |

#### Virtualization, Emulation & Gaming (25 packages)
| Package | Purpose / Description |
| :--- | :--- |
| **`docker`** | Pack, ship and run any application as a lightweight container |
| **`docker-compose`** | Fast, isolated development environments using Docker |
| **`gamemode`** | A daemon/lib combo that allows games to request a set of optimisations be temporarily applied to the host OS |
| **`gamescope`** | SteamOS session compositing window manager |
| **`gnome-boxes`** | Simple GNOME application to access virtual systems |
| **`lazydocker`** | A simple terminal UI for docker and docker-compose, written in Go with the gocui library. |
| **`lib32-gamemode`** | A daemon/lib combo that allows games to request a set of optimisations be temporarily applied to the host OS |
| **`lib32-mangohud`** | 32-bit libraries for MangoHud and MangoApp |
| **`lutris`** | Open Gaming Platform |
| **`mangohud`** | A Vulkan overlay layer for monitoring FPS, temperatures, CPU/GPU load and more. |
| **`openrazer-daemon`** | Userspace daemon that abstracts access to the kernel driver. Provides a DBus service for applications to use |
| **`qemu-full`** | A full QEMU setup |
| **`scrcpy`** | Display and control your Android device |
| **`steam`** | Valve's digital software delivery system |
| **`virt-manager`** | Desktop user interface for managing virtual machines |
| **`virt-viewer`** | A lightweight interface for interacting with the graphical display of virtualized guest OS. |
| **`virtualbox`** | Powerful x86 virtualization for enterprise as well as home use |
| **`virtualbox-guest-iso`** | The official VirtualBox Guest Additions ISO image |
| **`virtualbox-guest-utils`** | VirtualBox Guest userspace utilities |
| **`virtualbox-host-dkms`** | VirtualBox Host kernel modules sources |
| **`waydroid`** | A container-based approach to boot a full Android system on a regular Linux system |
| **`wine`** | A compatibility layer for running Windows programs |
| **`wine-gecko`** | Wine's built-in replacement for Microsoft's Internet Explorer |
| **`wine-mono`** | Wine's built-in replacement for Microsoft's .NET Framework |
| **`winetricks`** | Script to install various redistributable runtime libraries in Wine. |

#### Audio, Video, 2D/3D Graphics & Creative Multimedia (25 packages)
| Package | Purpose / Description |
| :--- | :--- |
| **`audacity`** | A program that lets you manipulate digital audio waveforms |
| **`cava`** | Console-based Audio Visualizer with support for multiple backends |
| **`darktable`** | Utility to organize and develop raw images |
| **`digikam`** | An advanced digital photo management application |
| **`ffmpegthumbnailer`** | Lightweight video thumbnailer that can be used by file managers |
| **`fontforge`** | Outline and bitmap font editor |
| **`gimp`** | GNU Image Manipulation Program |
| **`handbrake`** | Multithreaded video transcoder |
| **`inkscape`** | Professional vector graphics editor |
| **`krita`** | Edit and paint images |
| **`lib32-libpulse`** | A featureful, general-purpose sound server (32-bit client libraries) |
| **`libopenraw`** | Library for decoding RAW files |
| **`libresprite`** | Animated sprite editor and pixel art tool, based on the last GPL2 commit of Aseprite |
| **`lmms`** | The Linux MultiMedia Studio |
| **`obs-studio`** | Free, open source software for live streaming and recording |
| **`opentoonz`** | A full-featured 2D animation creation software |
| **`pavucontrol`** | PulseAudio Volume Control |
| **`pipewire-alsa`** | Low-latency audio/video router and processor - ALSA configuration |
| **`pipewire-pulse`** | Low-latency audio/video router and processor - PulseAudio replacement |
| **`ristretto`** | A fast and lightweight picture viewer for Xfce |
| **`rosegarden`** | MIDI/audio sequencer and notation editor |
| **`synfigstudio`** | Professional vector animation program (GUI) |
| **`vlc`** | Free and open source cross-platform multimedia player and framework |
| **`vlc-plugins-all`** | Free and open source cross-platform multimedia player and framework - all plugins |
| **`yt-dlp`** | A youtube-dl fork with additional features and fixes |

#### Productivity, Office, Communication & Daily Applications (24 packages)
| Package | Purpose / Description |
| :--- | :--- |
| **`baobab`** | A graphical directory tree analyzer |
| **`calibre`** | Ebook management application |
| **`chromium`** | A web browser built for speed, simplicity, and security |
| **`dolphin`** | KDE File Manager |
| **`filezilla`** | Fast and reliable FTP, FTPS and SFTP client |
| **`firefox`** | Fast, Private & Safe Web Browser |
| **`gnome-calculator`** | GNOME Scientific calculator |
| **`gnome-calendar`** | Simple and beautiful calendar application designed to perfectly fit the GNOME desktop |
| **`gnome-characters`** | A character map application |
| **`gnome-clocks`** | Clocks applications for GNOME |
| **`gnome-font-viewer`** | A font viewer utility for GNOME |
| **`gnome-logs`** | A log viewer for the systemd journal |
| **`gspell`** | Spell-checking library for GTK applications |
| **`kiwix-desktop`** | Offline reader for Web content, especially intended to make Wikipedia available offline |
| **`libreoffice-still`** | LibreOffice maintenance branch |
| **`links`** | A text WWW browser, similar to Lynx |
| **`obsidian`** | A powerful knowledge base that works on top of a local folder of plain text Markdown files |
| **`okular`** | Document Viewer |
| **`proton-vpn-gtk-app`** | ProtonVPN GTK app, Maintained by Community |
| **`protonmail-bridge`** | Integrate ProtonMail paid account with any program that supports IMAP and SMTP (Qt desktop application) |
| **`qbittorrent`** | An advanced BitTorrent client programmed in C++, based on Qt toolkit and libtorrent-rasterbar |
| **`spotify-launcher`** | Client for spotify's apt repository in Rust for Arch Linux |
| **`texlive-langarabic`** | TeX Live - Arabic |
| **`texlive-meta`** | Metapackage to install Tex Live |

#### Terminal Emulators, Shells & CLI Productivity Utilities (20 packages)
| Package | Purpose / Description |
| :--- | :--- |
| **`aria2`** | Download utility that supports HTTP(S), FTP, BitTorrent, and Metalink |
| **`bash-completion`** | Programmable completion for the bash shell |
| **`bat`** | Cat clone with syntax highlighting and git integration |
| **`btop`** | A monitor of system resources, bpytop ported to C++ |
| **`cpu-x`** | A Free software that gathers information on CPU, motherboard and more |
| **`dialog`** | A tool to display dialog boxes from shell scripts |
| **`eza`** | A modern replacement for ls (community fork of exa) |
| **`fastfetch`** | A feature-rich and performance oriented neofetch like system information tool |
| **`fd`** | Simple, fast and user-friendly alternative to find |
| **`fsearch`** | A fast file search utility for Unix-like systems based on GTK3 |
| **`fzf`** | Command-line fuzzy finder |
| **`kitty`** | A modern, hackable, featureful, OpenGL-based terminal emulator |
| **`konsole`** | KDE terminal emulator |
| **`mission-center`** | Monitor your CPU, Memory, Disk, Network and GPU usage |
| **`sl`** | Steam Locomotive runs across your terminal when you type "sl" as you meant to type "ls" |
| **`starship`** | The cross-shell prompt for astronauts |
| **`tldr`** | Command line client for tldr, a collection of simplified man pages. |
| **`tree`** | A directory listing program displaying a depth indented list of files |
| **`wget`** | Network utility to retrieve files from the web |
| **`xfce4-terminal`** | A modern terminal emulator primarily for the Xfce desktop environment |

#### System Core, Kernel, Storage, Hardware & Boot (62 packages)
| Package | Purpose / Description |
| :--- | :--- |
| **`amd-ucode`** | Microcode update image for AMD CPUs |
| **`arch-wiki-docs`** | Pages from Arch Wiki optimized for offline browsing |
| **`base`** | Minimal package set to define a basic Arch Linux installation |
| **`bluedevil`** | Integrate the Bluetooth technology within KDE workspace and applications |
| **`blueman`** | GTK+ Bluetooth Manager |
| **`bluez`** | Daemons for the bluetooth protocol stack |
| **`bluez-deprecated-tools`** | Deprecated tools that are no longer maintained |
| **`bluez-utils`** | Development and debugging utilities for the bluetooth protocol stack |
| **`btrfs-progs`** | Btrfs filesystem utilities |
| **`cups`** | OpenPrinting CUPS - daemon package |
| **`cups-filters`** | OpenPrinting CUPS Filters |
| **`ddrescue`** | GNU data recovery tool |
| **`discover`** | KDE and Plasma resources management GUI |
| **`dosfstools`** | DOS filesystem utilities |
| **`efibootmgr`** | Linux user-space application to modify the EFI Boot Manager |
| **`evtest`** | Input device event monitor and query tool |
| **`exfatprogs`** | exFAT filesystem userspace utilities for the Linux Kernel exfat driver |
| **`flatpak`** | Linux application sandboxing and distribution framework (formerly xdg-app) |
| **`flatpak-kcm`** | Flatpak Permissions Management KCM |
| **`gparted`** | A Partition Magic clone, frontend to GNU Parted |
| **`grub`** | GNU GRand Unified Bootloader (2) |
| **`gufw`** | Uncomplicated way to manage your Linux firewall |
| **`gvfs`** | Virtual filesystem implementation for GIO |
| **`gvfs-gphoto2`** | Virtual filesystem implementation for GIO - gphoto2 backend (PTP camera, MTP media player) |
| **`gvfs-mtp`** | Virtual filesystem implementation for GIO - MTP backend (Android, media player) |
| **`isoimagewriter`** | Program to write hybrid ISO files onto USB disks |
| **`kdeconnect`** | Adds communication between KDE and your smartphone |
| **`krdp`** | Library and examples for creating an RDP server |
| **`ksshaskpass`** | ssh-add helper that uses kwallet and kpassworddialog |
| **`linux`** | The Linux kernel and modules |
| **`linux-firmware`** | Firmware files for Linux - Default set |
| **`linux-headers`** | Headers and scripts for building modules for the Linux kernel |
| **`linux-zen`** | The Linux ZEN kernel and modules |
| **`linux-zen-headers`** | Headers and scripts for building modules for the Linux ZEN kernel |
| **`ly`** | TUI display manager |
| **`man-db`** | A utility for reading man pages |
| **`man-pages`** | Linux man pages |
| **`mtools`** | A collection of utilities to access MS-DOS disks |
| **`network-manager-applet`** | Applet for managing network connections |
| **`networkmanager`** | Network connection manager and user applications |
| **`ngrok`** | A tunneling, reverse proxy for developing and understanding networked, HTTP services. |
| **`ntfs-3g`** | NTFS FUSE driver |
| **`os-prober`** | Utility to detect other OSes on a set of drives |
| **`pacman-contrib`** | Contributed scripts and tools for pacman systems |
| **`partitionmanager`** | A KDE utility that allows you to manage disks, partitions, and file systems |
| **`plymouth`** | Graphical boot splash screen |
| **`power-profiles-daemon`** | Makes power profiles handling available over D-Bus |
| **`print-manager`** | A tool for managing print jobs and printers |
| **`reflector`** | A Python 3 module and script to retrieve and filter the latest Pacman mirror list. |
| **`smartmontools`** | Control and monitor S.M.A.R.T. enabled ATA and SCSI Hard Drives |
| **`snap-pac`** | Pacman hooks that use snapper to create pre/post btrfs snapshots like openSUSE's YaST |
| **`snapper`** | A tool for managing BTRFS and LVM snapshots |
| **`testdisk`** | Checks and undeletes partitions + PhotoRec, signature based recovery tool |
| **`udiskie`** | Removable disk automounter using udisks |
| **`ufw`** | Uncomplicated and easy to use CLI tool for managing a netfilter firewall |
| **`unrar`** | The RAR uncompression program |
| **`unzip`** | For extracting and viewing files in .zip archives |
| **`usb_modeswitch`** | Activating switchable USB devices on Linux. |
| **`wimlib`** | A library and program to extract, create, and modify WIM files |
| **`xarchiver`** | GTK frontend to various command line archivers |
| **`yay`** | Yet another yogurt. Pacman wrapper and AUR helper written in go. |
| **`zip`** | Compressor/archiver for creating and modifying zipfiles |

#### Fonts, Themes, Icons & UI Toolkits (16 packages)
| Package | Purpose / Description |
| :--- | :--- |
| **`breeze-gtk`** | Breeze widget theme for GTK 2 and 3 |
| **`breeze-plymouth`** | Plymouth theme for the Breeze visual style for the Plasma Desktop |
| **`gnome-themes-extra`** | Extra GNOME themes (legacy HighContrast icon theme and index files for Adwaita) |
| **`kvantum`** | SVG-based theme engine for Qt6 (including config tool and extra themes) |
| **`kvantum-qt5`** | SVG-based theme engine for Qt5 |
| **`noto-fonts-cjk`** | Google Noto CJK fonts |
| **`otf-font-awesome`** | Iconic font designed for Bootstrap - otf format |
| **`oxygen`** | KDE Oxygen style |
| **`oxygen-cursors`** | Oxygen cursors |
| **`oxygen-sounds`** | The Oxygen Sound Theme |
| **`papirus-icon-theme`** | Papirus icon theme |
| **`qt6ct`** | Qt 6 Configuration Utility |
| **`terminus-font`** | Monospace bitmap font (for X11 and console) |
| **`ttf-firacode-nerd`** | Patched font Fira (Fura) Code from nerd fonts library |
| **`ttf-jetbrains-mono-nerd`** | Patched font JetBrains Mono from nerd fonts library |
| **`union`** | A Qt style supporting both QtQuick and QtWidgets |

### 🔮 AUR (Arch User Repository) Packages (`yay -Qe` / `pacman -Qem` — 23 packages)

#### Desktop, Wayland Shell & Hyprland Extensions (8 packages)
| Package | Purpose / Description |
| :--- | :--- |
| **`hyprmod`** | Native GTK4/libadwaita settings app for Hyprland |
| **`hyprsysteminfo`** | A tiny qt6/qml application to display information about the running system |
| **`kgamma`** | Adjust your monitor gamma settings |
| **`kwin-x11`** | An easy to use, but flexible, X Window Manager |
| **`vicinae-bin`** | A focused launcher for your desktop — native, fast, extensible |
| **`waybar-git`** | Highly customizable Wayland bar for Sway and Wlroots based compositors |
| **`wayle-bin`** | A configurable desktop shell for Wayland compositors |
| **`waypaper`** | GUI wallpaper setter for Wayland and Xorg window managers. It works as a frontend for popular wallpaper backends like swaybg, swww, wallutils, hyprpaper and feh. |

#### Development, Code Editors & AI Agents (7 packages)
| Package | Purpose / Description |
| :--- | :--- |
| **`android-studio`** | The official Android IDE (Stable branch) |
| **`claude-code`** | An agentic coding tool that lives in your terminal |
| **`claude-desktop-extra`** | Claude Desktop (official Linux build) with extra features: Computer Use, custom themes, multi-profile, Quick Entry - for distros upstream does not ship |
| **`codebase-memory-mcp-bin`** | High-performance code intelligence MCP server with persistent knowledge graph |
| **`unityhub`** | The Unity Hub is a standalone application that streamlines the way you find, download, and manage your Unity Projects and installations. |
| **`visual-studio-code-bin`** | Visual Studio Code (vscode): Editor for building and debugging modern web and cloud applications (official binary version) |
| **`yay-bin-debug`** | Detached debugging symbols for yay-bin |

#### Internet, Communication & Remote Access (6 packages)
| Package | Purpose / Description |
| :--- | :--- |
| **`betterbird-bin`** | EN-US // Betterbird is a fine-tuned version of Mozilla Thunderbird, Thunderbird on steroids, if you will. |
| **`binance`** | The Binance desktop application |
| **`ferdium-bin`** | A messaging browser that allows you to combine your favorite messaging services into one application (binary release). |
| **`google-earth-pro`** | 3D interface to explore the globe, terrain, streets, buildings and other planets (Pro version) |
| **`rustdesk`** | Yet another remote desktop software, written in Rust. Works out of the box, no configuration required. Great alternative to TeamViewer and AnyDesk! |
| **`winboat-bin`** | Run Windows apps on Linux with seamless integration |

#### Hardware & Peripherals Management (2 packages)
| Package | Purpose / Description |
| :--- | :--- |
| **`razergenie`** | Configure and control your Razer devices |
| **`wacomtablet`** | GUI for Wacom Linux drivers that supports different button/pen layout profiles |

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
- **XDG Desktop Portal & Native File Pickers (`.config/xdg-desktop-portal/hyprland-portals.conf`)**:
  - Configures default portal backends (`hyprland;gtk`) with `org.freedesktop.impl.portal.FileChooser = kde` to route file picker dialogs to KDE's dialogs across Wayland and GTK apps (`GTK_USE_PORTAL=1`).

---

## 🚀 Boot Experience & Login Manager (Plymouth & Ly)

- **Plymouth Boot Splash (`rice/plymouth/cuts_alt/`)**:
  - Integrated the animated **Cuts Alt** splash theme from the `adi1090x/plymouth-themes` collection.
  - Customized with an anti-aliased **Arch Linux logo** centered at the bottom of the screen.
  - Early Kernel Mode Setting (`MODULES=(amdgpu)` or `i915` in `/etc/mkinitcpio.conf`) ensures flicker-free, instant splash startup on native resolution before root filesystem mount.
  - Kernel command-line configured with `splash` in `/etc/default/grub`.
- **Ly Display Manager (`system/etc/ly/`)**:
  - **2x HiDPI Scaling**: Uses Terminus 32px font (`ter-v32n` in `/etc/vconsole.conf` and `/etc/ly/startup.sh`), transforming the 240x67 character TTY grid into a clean, legible 120x33 layout.
  - **Doom Fire Animation**: Classic PSX DOOM flames rising continuously from the screen bottom with `blank_box = false` for a transparent login box overlay.
  - **Clocks & Greeting**: Large ASCII digital clock (`bigclock = en`), formatted top-right clock (`clock = %a %d %b %H:%M`), and a customized greeting (*"Hello back ;)"*).
  - Managed by `ly@tty2.service` with conflicting `getty@tty2.service` disabled.
- **One-Command Deployment**:
  ```bash
  ~/dotfiles/scripts/system/setup-ly-plymouth.sh
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
- `dotmachine` ➔ Show detected hardware profile (`honor`, `thinkpad/x230`, `thinkpad/x1-yoga`, `hp-omen`).
- `dotstatus` / `dotdiff` / `dotcd` ➔ Inspect or jump into `~/dotfiles`.
- `temp` ➔ Hardware-aware CPU/GPU thermal, frequency, and fan monitor (AMD, Intel, NVIDIA).
- `turbo [status|enable|disable|toggle]` ➔ Control CPU Turbo Boost (AMD & Intel).
- `pprofile [status|cycle|performance|balanced|power-saver]` ➔ Switch power profiles.
- `fans [toggle|status|max|auto]` ➔ Control HP Omen fans.
