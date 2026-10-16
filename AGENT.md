# 🤖 AI Assistant Operational Guide: Dotfiles & Multi-Machine Management

> **Audience**: This document is an instruction manual for AI coding assistants (Antigravity, Claude Code, Cursor, Copilot, etc.) operating on Badreddine's systems.
> **Rule #1**: When asked to "sync my stuff", "backup my config", or modify dotfiles, you **MUST** follow the guidelines in this file.

---

## 1. Multi-Machine Profiles & Identity

- **OS**: Arch Linux across multiple laptops, automatically detected via `~/dotfiles/scripts/system/detect-machine.sh`:
  - **`honor`**: Honor MagicBook (`HUAWEI HLYL-WXX9`, AMD Ryzen 5 4600H + Radeon Graphics).
  - **`thinkpad/x230`**: Lenovo ThinkPad X230 (Intel + ThinkPad ACPI/EC + ThinkLight).
  - **`thinkpad/x1-yoga`**: Lenovo ThinkPad X1 Yoga.
  - **`hp-omen`**: HP Omen (Intel + NVIDIA + `hp-wmi` fan control).
- **Core Desktop Stack**:
  - **Compositor**: Hyprland (configured via Lua: `~/.config/hypr/hyprland.lua`).
  - **Panel / Status Bar**: Wayle (`~/.config/wayle`). *(Note: `waybar` is obsolete/unused).*
  - **Launcher / Search / Clipboard**: Vicinae (`~/.config/vicinae`). *(Note: `rofi` is obsolete/unused).*
  - **Terminal**: Kitty (`~/.config/kitty`).
  - **Shell & Prompt**: Bash with Starship (`~/.config/starship.toml`). *(Note: `fish` is NOT used).*
  - **File Manager**: Thunar (`SUPER + D`).
  - **Login Manager & Boot Splash**: Ly TUI Display Manager (`system/etc/ly/config.ini`, 2x scaled via `ter-v32n`, Doom fire animation, `ly@tty2.service`) & Plymouth bootsplash (`rice/plymouth/cuts_alt/` with Arch Linux logo, `splash` kernel flag).
  - **Rice (Themes & Icons)**: Stored in `~/dotfiles/rice/themes/` (`Dracula-pink-accent`) and `~/dotfiles/rice/icons/` (`Future-Cyan-Hyprcursor_Theme`, `WhiteSur-cursors`, `default`).

---

## 2. The Golden Architecture: Zero-Copy Symlinks

The repository at `$HOME/dotfiles/` is the **single source of truth**.

```
$HOME/dotfiles/.config/<app>/  <-- Real physical files tracked by Git
             ▲
             │  (Symlink: ln -s)
             │
~/.config/<app>/               <-- Transparent pointer used by applications
```

### ⚠️ Strict AI Invariants:
1. **Never break symlinks**: Do NOT delete a symlink and write a regular folder/file in `~/.config/`, `~/.themes/`, or `~/.icons/`.
2. **Always use `$HOME`**: Never hardcode `/home/badreddine/`. Use `$HOME` or `~` so configurations remain portable across any machine or username.
3. **Secrets Isolation**:
   - `~/.bashrc` sources `~/.bashrc.local` dynamically.
   - API keys (e.g. Anthropic, OpenAI, custom tokens) must **ONLY** be placed in `~/.bashrc.local`.
   - `~/.bashrc.local` is gitignored (`*.local` in `.gitignore`). **NEVER** commit API tokens, passwords, or SSH keys to Git.
4. **Caches & Junk Exclusion**:
   - **NEVER** track heavy app directories: `Code`, `Code - OSS`, `Antigravity IDE`, `rpcs3`, `mozilla`, `chromium`, `Ferdium`, `Binance`, `hydralauncher`, `unityhub`, `redact`.
   - **NEVER** track dead leftovers: `wlogout`, `waybar`, `rofi`, `mako`, `xfce4`, `cosmic`, `fish`, or wallpaper image files in the repo.

---

## 3. Package Management & Machine Profiles

Packages and services are split into **Shared Core (`packages/`)** and **Machine Profiles (`machines/<profile>/`)** so running `dotsync` on one laptop never clobbers another laptop's packages or drivers:

| Category | File Path | Scope & Description |
| :--- | :--- | :--- |
| **Shared Arch** | `packages/pacman.txt` | Shared packages from `core`, `extra`, and `multilib` (union-merged by default). |
| **Machine Drivers** | `machines/<profile>/pacman.txt` | Hardware-specific packages (`amd-ucode`, `vulkan-radeon` on `honor`; `intel-ucode`, `vulkan-intel` on `thinkpad`; `nvidia*` on `hp-omen`). |
| **BlackArch** | `packages/blackarch.txt` | Security & OSINT tools from the BlackArch repo. **Do not merge into `pacman.txt`!** |
| **Shared AUR** | `packages/aur.txt` | Shared foreign packages installed via `yay` (`wayle-bin`, `vicinae-bin`, `waypaper`, etc.). |
| **Machine AUR** | `machines/<profile>/aur.txt` | Hardware-specific AUR packages (`thinkfan` on `thinkpad`, `optimus-manager` on `hp-omen`). |
| **Flatpaks** | `packages/flatpak.txt` | Flatpak application IDs + Flatseal permissions in `packages/flatpak-overrides/`. |
| **Global NPM & UV** | `packages/npm.txt`, `packages/uv.txt` | Globally installed NPM packages (`~/.npm-global`) and Python UV tools (`uv tool`). |
| **Services** | `packages/services-*.txt` & `machines/<profile>/services-system.txt` | Shared vs hardware-specific systemd services. |

---

## 4. Categorized Scripts (`~/dotfiles/scripts/`)

All custom scripts and reference notes live inside `~/dotfiles/scripts/`:
- **`scripts/NOTES.md`**: Consolidated reference cheatsheet (Wayland flags, Vulkan ICD GPU selection, GameMode, NTFS, Git).
- **`scripts/system/`**: `detect-machine.sh`, `setup-ly-plymouth.sh`, `setup-btrfs-snapper.sh`, `fix-grub-chroot.sh`, `mount-games-disk.sh`.
- **`scripts/desktop/`**: `launch-antigravity.sh`, `random-wallpaper.sh`, `set-default-browser.sh`.
- **`scripts/hardware/common/`**: `cpu-turbo-boost.sh` (Intel & AMD), `power-profile.sh`.
- **`scripts/hardware/thinkpad/`**: `thinklight-toggle.sh`.
- **`scripts/hardware/hp-omen/`**: `hp-fan-control.py`.
- **`scripts/security/`**: `backup-secrets-offline.sh`, `restore-secrets-offline.sh`.

---

## 5. Standard AI Workflows & Commands

### Task 1: When user says "Sync my stuff", "Backup dotfiles", or "dotsync"
Run the multi-machine snapshot script:
```bash
$HOME/dotfiles/sync.sh "Descriptive commit message"
```
*(Pass `--prune` before the message only if the user explicitly wants to remove uninstalled packages from the shared lists).*

### Task 2: When user asks to transfer Wi-Fi passwords, SSH keys, or secrets
Direct them to the offline encryption scripts (never put these in Git):
```bash
# To backup to USB:
~/dotfiles/scripts/security/backup-secrets-offline.sh /path/to/usb/secrets.tar.gz.gpg

# To restore on new machine:
~/dotfiles/scripts/security/restore-secrets-offline.sh /path/to/usb/secrets.tar.gz.gpg
```
