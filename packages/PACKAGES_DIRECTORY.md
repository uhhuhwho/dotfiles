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

