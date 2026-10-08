# 🤖 AI Assistant Operational Guide: Dotfiles & System Management

> **Audience**: This document is an instruction manual for AI coding assistants (Antigravity, Claude Code, Cursor, Copilot, etc.) operating on Badreddine's system.
> **Rule #1**: When asked to "sync my stuff", "backup my config", or modify dotfiles, you **MUST** follow the guidelines in this file.

---

## 1. System Profile & Identity

- **OS**: Arch Linux (Linux Zen Kernel) on a ThinkPad X230.
- **Filesystem**: Btrfs (`/@` root, `/@home` user data, `/@pkg` cache, `/@log` logs).
- **Core Desktop Stack**:
  - **Compositor**: Hyprland (configured via Lua: `~/.config/hypr/hyprland.lua`).
  - **Panel / Status Bar**: Wayle (`~/.config/wayle`). *(Note: `waybar` is obsolete/unused).*
  - **Launcher / Search / Clipboard**: Vicinae (`~/.config/vicinae`). *(Note: `rofi` is obsolete/unused).*
  - **Terminal**: Kitty (`~/.config/kitty`).
  - **Shell & Prompt**: Bash with Starship (`~/.config/starship.toml`). *(Note: `fish` is NOT used).*
  - **File Manager**: Thunar (`SUPER + D`).
  - **Theme**: Dracula-pink-accent GTK, Future-Cyan-Hyprcursor for Wayland, WhiteSur for XWayland.
  - **Active Wallpaper**: `~/Pictures/Wallpapers/badreddine wallpapers/a_view_of_the_ocean_from_a_balcony.jpeg`.

---

## 2. The Golden Architecture: Zero-Copy Symlinks

The repository at `$HOME/dotfiles/` is the **single source of truth**.

```
$HOME/dotfiles/.config/<app>/  <-- Real physical files tracked by Git
             ▲
             │  (Symlink: ln -s)
             │
~/.config/<app>/              <-- Transparent pointer used by applications
```

### ⚠️ Strict AI Invariants:
1. **Never break symlinks**: Do NOT delete a symlink and write a regular folder/file in `~/.config/`.
2. **Always use `$HOME`**: Never hardcode `/home/badreddine/`. Use `$HOME` or `~` so configurations remain portable across any machine or username.
3. **Secrets Isolation**:
   - `~/.bashrc` sources `~/.bashrc.local` dynamically.
   - API keys (e.g. Anthropic, OpenAI, custom tokens) must **ONLY** be placed in `~/.bashrc.local`.
   - `~/.bashrc.local` is gitignored (`*.local` in `.gitignore`). **NEVER** commit API tokens, passwords, or SSH keys to Git.
4. **Caches & Junk Exclusion**:
   - **NEVER** track heavy app directories: `Code`, `Code - OSS`, `Antigravity IDE`, `rpcs3`, `mozilla`, `chromium`, `Ferdium`, `Binance`, `hydralauncher`, `unityhub`, `redact`.
   - **NEVER** track dead leftovers: `wlogout`, `waybar`, `rofi`, `mako`, `xfce4`, `cosmic`, `fish`.

---

## 3. Package Management & Developer Ecosystem

Packages are categorized to ensure clean replication across tools and package managers:

| Tier / Category | File Path | Scope & Description |
| :--- | :--- | :--- |
| **Tier 1: Standard Arch** | `packages/pacman.txt` | Explicitly installed packages from official `core`, `extra`, and `multilib` repos only. |
| **Tier 2: BlackArch** | `packages/blackarch.txt` | Security & OSINT tools from the BlackArch repo (`androguard`, `maigret`, `sherlock`, etc.). **Do not merge into `pacman.txt`!** |
| **Tier 3: AUR** | `packages/aur.txt` | Foreign packages installed via `yay` (`wayle-bin`, `vicinae-bin`, `waypaper`, `claude-code`, etc.). |
| **Tier 4: Flatpaks** | `packages/flatpak.txt` | Flatpak application IDs + Flatseal permissions in `packages/flatpak-overrides/`. |
| **Tier 5: Global NPM** | `packages/npm.txt` | Globally installed NPM packages (`omniroute`, `oh-my-mermaid`, etc.) managed via `~/.npm-global`. |
| **Tier 6: Python UV Tools** | `packages/uv.txt` | Standalone Python CLI tools installed via `uv tool` (`hackingtool`, `pixelrag`, etc.). |

---

## 4. AI Ecosystem & Assistants Configuration

AI configurations and agent skills are snapshot into `ai/`:
- **Universal Agent Skills (`ai/agents/`)**: Tracks `.skill-lock.json` and rules (`claude-mem-context.md`).
- **Claude Code (`ai/claude/`)**: Tracks installed plugins (`installed_plugins.json`) and non-sensitive options (`settings.json`). *API tokens are strictly kept in `~/.bashrc.local`.*
- **Gemini / Antigravity (`ai/gemini/`)**: Tracks `settings.json` (claude-mem lifecycle hooks via Bun), `mcp_config.json`, and plugin manifest (`plugins.json`).
- **Cursor (`ai/cursor/`)**: Tracks MCP configurations (`mcp.json`) and custom skill manifests (`skills-manifest.json`).
- **Codex CLI (`ai/codex/`)**: Tracks model configurations (`config.toml`).

---

## 5. System Settings & Daemons Tracked

- **`/etc/pacman.conf`** ➔ Synced in `system/etc/pacman.conf` (Color, ILoveCandy, ParallelDownloads = 5, Multilib, BlackArch).
- **ThinkPad Tweaks** ➔ Synced in `system/hardware/thinkpad/` (`thinkpad_acpi.conf`, `ec_sys.conf`, `99-thinklight.rules`, `thinkfan.conf`).
- **System Services** ➔ Synced in `packages/services-system.txt` (`NetworkManager`, `bluetooth`, `power-profiles-daemon`, `docker`, `ufw`, etc.).
- **User Services** ➔ Synced in `packages/services-user.txt` (`hyprpaper`, `vicinae`, `wireplumber`, `pipewire`, etc.).
- **Desktop Settings** ➔ Synced in `system/dconf-settings.ini` via `dconf dump /`.

---

## 6. Standard AI Workflows & Commands

### Task 1: When user says "Sync my stuff", "Backup dotfiles", or "dotsync"
Run the automated snapshot script:
```bash
dotsync "Descriptive commit message"
```
Or directly:
```bash
$HOME/dotfiles/sync.sh "Descriptive commit message"
```
*This script automatically updates all 4 package lists, system services, dconf settings, stages changes, commits, and pushes to `origin main`.*

### Task 2: When user asks to track a new application config
Follow this exact 4-step sequence:
1. Copy the new folder to dotfiles:
   ```bash
   cp -r ~/.config/<app> ~/dotfiles/.config/<app>
   ```
2. Move the original to backup:
   ```bash
   mv ~/.config/<app> ~/.config/<app>.bak
   ```
3. Create the symlink:
   ```bash
   ln -s ~/dotfiles/.config/<app> ~/.config/<app>
   rm -rf ~/.config/<app>.bak
   ```
4. Run `dotsync "Track <app> configuration"` to push.

### Task 3: When user asks to move/replicate to a new device
Instruct the user:
```bash
git clone https://github.com/uhhuhwho/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```
*`bootstrap.sh` non-destructively backs up any existing files to `.dotfiles_backup_<timestamp>`, deploys symlinks, configures `/etc/pacman.conf`, bootstraps BlackArch if desired, installs packages, and enables systemd services.*

### Task 4: When user asks to transfer Wi-Fi passwords, SSH keys, or secrets
Direct them to the offline encryption scripts (never put these in Git):
```bash
# To backup to USB:
~/dotfiles/scripts/backup-secrets-offline.sh /path/to/usb/secrets.tar.gz.gpg

# To restore on new machine:
~/dotfiles/scripts/restore-secrets-offline.sh /path/to/usb/secrets.tar.gz.gpg
```
