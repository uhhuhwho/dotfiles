import subprocess
import os

def parse_pacman_qi(pkgs):
    res = {}
    # Batch in chunks of 50 to avoid any potential arg length issues
    chunk_size = 50
    for i in range(0, len(pkgs), chunk_size):
        chunk = pkgs[i:i + chunk_size]
        out = subprocess.check_output(['/usr/bin/pacman', '-Qi'] + chunk, text=True)
        cur_pkg = None
        cur_key = None
        for line in out.splitlines():
            if not line:
                continue
            if ':' in line and not line.startswith(' '):
                parts = line.split(':', 1)
                key = parts[0].strip()
                val = parts[1].strip()
                if key == 'Name':
                    cur_pkg = val
                    res[cur_pkg] = {}
                if cur_pkg:
                    res[cur_pkg][key] = val
                    cur_key = key
            elif cur_pkg and cur_key and line.startswith(' '):
                res[cur_pkg][cur_key] += ' ' + line.strip()
    return res

native = [l.split()[0] for l in subprocess.check_output(['/usr/bin/pacman', '-Qen'], text=True).strip().splitlines() if l.strip()]
aur = [l.split()[0] for l in subprocess.check_output(['/usr/bin/pacman', '-Qem'], text=True).strip().splitlines() if l.strip()]

print(f"Native count: {len(native)}")
print(f"AUR count: {len(aur)}")

all_pkgs = list(set(native + aur))
pkg_info = parse_pacman_qi(all_pkgs)

native_categories = {
    'Desktop Environments, Wayland Compositors & Shell Tools': [
        'hyprland', 'hypridle', 'hyprlock', 'hyprpaper', 'hyprpicker', 'hyprpm', 
        'hyprpolkitagent', 'hyprpwcenter', 'hyprsunset', 'xdg-desktop-portal-hyprland', 
        'mako', 'cliphist', 'wl-clipboard', 'slurp', 'grim', 'spectacle', 'wdisplays', 'wev', 
        'brightnessctl', 'nwg-look', 'quickshell', 'plasma-desktop', 'plasma-bigscreen', 
        'plasma-browser-integration', 'plasma-disks', 'plasma-firewall', 'plasma-keyboard', 
        'plasma-login-manager', 'plasma-nm', 'plasma-pa', 'plasma-sdk', 'plasma-systemmonitor', 
        'plasma-thunderbolt', 'plasma-vault', 'plasma-welcome', 'plasma-workspace-wallpapers', 
        'kdeplasma-addons', 'kde-gtk-config', 'kscreen', 'kwallet-pam', 'kwrited', 
        'drkonqi', 'sddm-kcm', 'plymouth-kcm', 'kinfocenter', 'qt6-wayland'
    ],
    'Security, Forensics, Reverse Engineering & OSINT': [
        'aircrack-ng', 'androguard', 'android-apktool', 'apkleaks', 'apkstudio', 
        'blackarch-keyring', 'blackarch-mirrorlist', 'detect-it-easy', 'dmde', 'dotpeek', 
        'email2phonenumber', 'foremost', 'ghidra', 'httrack', 'maigret', 'metasploit', 
        'mimikatz', 'mobsf', 'nmap', 'phoneinfoga', 'radare2', 'recon-ng', 'rz-cutter', 
        'rz-ghidra', 'seekr', 'sherlock', 'sniffnet', 'social-analyzer', 'trape', 
        'user-scanner', 'wavemon', 'whatbreach', 'wireshark-qt', 'zenmap'
    ],
    'Software Development, Compilers, Debuggers & AI CLI': [
        'base-devel', 'cgdb', 'clang', 'cmake', 'cppcheck', 'doxygen', 'git', 'github-cli', 
        'glad', 'hugo', 'kommit', 'lazygit', 'libc++', 'libc++abi', 'lld', 'lldb', 'scons', 
        'stb', 'tinyxxd', 'dotnet-sdk', 'jdk21-openjdk', 'npm', 'php', 
        'pyenv', 'python-virtualenv', 'uv', 'kdevelop', 'nano', 'neovim', 'qtcreator', 
        'gemini-cli', 'llama-cpp', 'ggml-vulkan', 'ollama', 'openai-codex', 'assimp', 
        'directx-shader-compiler', 'freecad', 'tiled', 'renderdoc', 'sdl3_image', 
        'sdl3_mixer', 'sdl3_ttf', 'spirv-cross', 'spirv-headers', 'volk', 
        'vulkan-extra-layers', 'vulkan-extra-tools', 'vulkan-headers', 'vulkan-html-docs', 
        'vulkan-profiles', 'vulkan-radeon', 'vulkan-tools', 'vulkan-utility-libraries', 
        'vulkan-validation-layers', 'lib32-vulkan-radeon', 'opengl-man-pages', 'mesa', 
        'mesa-utils'
    ],
    'Virtualization, Emulation & Gaming': [
        'docker', 'docker-compose', 'lazydocker', 'gnome-boxes', 'qemu-full', 
        'virt-manager', 'virt-viewer', 'virtualbox', 'virtualbox-guest-iso', 
        'virtualbox-guest-utils', 'virtualbox-host-dkms', 'waydroid', 'scrcpy', 
        'wine', 'wine-gecko', 'wine-mono', 'winetricks', 'steam', 'lutris', 
        'gamemode', 'lib32-gamemode', 'gamescope', 'mangohud', 'lib32-mangohud', 
        'openrazer-daemon'
    ],
    'Audio, Video, 2D/3D Graphics & Creative Multimedia': [
        'audacity', 'cava', 'darktable', 'digikam', 'ffmpegthumbnailer', 'fontforge', 
        'gimp', 'handbrake', 'inkscape', 'krita', 'libopenraw', 'libresprite', 'lmms', 
        'obs-studio', 'opentoonz', 'pavucontrol', 'pipewire-alsa', 'pipewire-pulse', 
        'lib32-libpulse', 'ristretto', 'rosegarden', 'synfigstudio', 
        'vlc', 'vlc-plugins-all', 'yt-dlp'
    ],
    'Productivity, Office, Communication & Daily Applications': [
        'baobab', 'calibre', 'chromium', 'dolphin', 'filezilla', 'firefox', 
        'gnome-calculator', 'gnome-calendar', 'gnome-characters', 'gnome-clocks', 
        'gnome-font-viewer', 'gnome-logs', 'gspell', 'kiwix-desktop', 'libreoffice-still', 
        'links', 'obsidian', 'okular', 'proton-vpn-gtk-app', 'protonmail-bridge', 
        'qbittorrent', 'spotify-launcher', 'texlive-meta', 'texlive-langarabic'
    ],
    'Terminal Emulators, Shells & CLI Productivity Utilities': [
        'bash-completion', 'bat', 'btop', 'dialog', 'eza', 'fastfetch', 'fd', 
        'fsearch', 'fzf', 'kitty', 'konsole', 'mission-center', 'sl', 'starship', 
        'tldr', 'tree', 'wget', 'aria2', 'xfce4-terminal', 'cpu-x'
    ],
    'System Core, Kernel, Storage, Hardware & Boot': [
        'amd-ucode', 'base', 'linux', 'linux-firmware', 'linux-headers', 'linux-zen', 
        'linux-zen-headers', 'grub', 'os-prober', 'plymouth', 'ly', 'efibootmgr', 
        'btrfs-progs', 'snapper', 'snap-pac', 'partitionmanager', 'gparted', 
        'dosfstools', 'exfatprogs', 'mtools', 'ntfs-3g', 'udiskie', 'wimlib', 
        'xarchiver', 'unrar', 'unzip', 'zip', 'ddrescue', 'testdisk', 'smartmontools', 
        'bluez', 'bluez-deprecated-tools', 'bluez-utils', 'bluedevil', 'blueman', 
        'networkmanager', 'network-manager-applet', 'power-profiles-daemon', 'cups', 
        'cups-filters', 'print-manager', 'ufw', 'gufw', 'reflector', 'usb_modeswitch', 
        'evtest', 'gvfs', 'gvfs-gphoto2', 'gvfs-mtp', 'kdeconnect', 'krdp', 
        'ksshaskpass', 'flatpak', 'flatpak-kcm', 'discover', 'pacman-contrib', 
        'man-db', 'man-pages', 'arch-wiki-docs', 'yay', 'ngrok', 'isoimagewriter'
    ],
    'Fonts, Themes, Icons & UI Toolkits': [
        'breeze-gtk', 'breeze-plymouth', 'gnome-themes-extra', 'kvantum', 'kvantum-qt5', 
        'noto-fonts-cjk', 'otf-font-awesome', 'oxygen', 'oxygen-cursors', 'oxygen-sounds', 
        'papirus-icon-theme', 'qt6ct', 'terminus-font', 'ttf-firacode-nerd', 
        'ttf-jetbrains-mono-nerd', 'union'
    ]
}

aur_categories = {
    'Desktop, Wayland Shell & Hyprland Extensions': [
        'hyprmod', 'hyprsysteminfo', 'kgamma', 'kwin-x11', 'vicinae-bin', 
        'waybar-git', 'wayle-bin', 'waypaper'
    ],
    'Development, Code Editors & AI Agents': [
        'android-studio', 'claude-code', 'claude-desktop-extra', 
        'codebase-memory-mcp-bin', 'unityhub', 'visual-studio-code-bin', 'yay-bin-debug'
    ],
    'Internet, Communication & Remote Access': [
        'betterbird-bin', 'binance', 'ferdium-bin', 'google-earth-pro', 
        'rustdesk', 'winboat-bin'
    ],
    'Hardware & Peripherals Management': [
        'razergenie', 'wacomtablet'
    ]
}

# Verify coverage
assigned_native = set()
for cat, pkgs in native_categories.items():
    assigned_native.update(pkgs)
missing_native = set(native) - assigned_native
extra_native = assigned_native - set(native)
if missing_native or extra_native:
    print(f"ERROR: Native mismatch! Missing: {missing_native}, Extra: {extra_native}")
    exit(1)

assigned_aur = set()
for cat, pkgs in aur_categories.items():
    assigned_aur.update(pkgs)
missing_aur = set(aur) - assigned_aur
extra_aur = assigned_aur - set(aur)
if missing_aur or extra_aur:
    print(f"ERROR: AUR mismatch! Missing: {missing_aur}, Extra: {extra_aur}")
    exit(1)

md_lines = []
md_lines.append('## 📦 Explicitly Installed Packages & AUR Directory')
md_lines.append('')
md_lines.append('Complete inventory of all explicitly installed packages on the system (`pacman -Qe` and `yay`), organized into logical categories with a concise description of what each package does.')
md_lines.append('')
md_lines.append('### 🏛️ Official Arch Linux Packages (`pacman -Qen` — 311 packages)')
md_lines.append('')

for cat, pkgs in native_categories.items():
    md_lines.append(f'#### {cat} ({len(pkgs)} packages)')
    md_lines.append('| Package | Purpose / Description |')
    md_lines.append('| :--- | :--- |')
    for p in sorted(pkgs):
        desc = pkg_info.get(p, {}).get('Description', 'System package')
        desc = desc.replace('|', '\\|')
        md_lines.append(f'| **`{p}`** | {desc} |')
    md_lines.append('')

md_lines.append('### 🔮 AUR (Arch User Repository) Packages (`yay -Qe` / `pacman -Qem` — 23 packages)')
md_lines.append('')

for cat, pkgs in aur_categories.items():
    md_lines.append(f'#### {cat} ({len(pkgs)} packages)')
    md_lines.append('| Package | Purpose / Description |')
    md_lines.append('| :--- | :--- |')
    for p in sorted(pkgs):
        desc = pkg_info.get(p, {}).get('Description', 'AUR package')
        desc = desc.replace('|', '\\|')
        md_lines.append(f'| **`{p}`** | {desc} |')
    md_lines.append('')

output_path = os.path.expanduser('~/dotfiles/packages/PACKAGES_DIRECTORY.md')
with open(output_path, 'w') as f:
    f.write('\n'.join(md_lines) + '\n')

print(f"Successfully generated {output_path} with {len(md_lines)} lines!")
