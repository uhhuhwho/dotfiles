#!/usr/bin/env bash
# ==============================================================================
# dotfiles sync script (dotsync)
# Automatically updates packages, system configs, services, and pushes to GitHub
# ==============================================================================

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
cd "$DOTFILES_DIR"

echo -e "\033[1;34m:: Snapshotting packages & system state...\033[0m"

# 1. Native packages & BlackArch separation
python3 - << 'PY_EOF'
import subprocess, os

dotfiles_pkg = os.path.expanduser('~/dotfiles/packages')
os.makedirs(dotfiles_pkg, exist_ok=True)

ba_pkgs = set()
try:
    ba_out = subprocess.check_output(['pacman', '-Sl', 'blackarch'], stderr=subprocess.DEVNULL).decode().splitlines()
    for line in ba_out:
        parts = line.split()
        if len(parts) >= 2:
            ba_pkgs.add(parts[1])
except Exception:
    pass

native_pkgs = subprocess.check_output(['pacman', '-Qeqn']).decode().splitlines()

standard_pkgs = []
blackarch_pkgs = []

for pkg in native_pkgs:
    pkg = pkg.strip()
    if not pkg:
        continue
    if pkg in ba_pkgs and pkg != 'yay':
        blackarch_pkgs.append(pkg)
    else:
        standard_pkgs.append(pkg)

standard_pkgs.sort()
blackarch_pkgs.sort()

with open(os.path.join(dotfiles_pkg, 'pacman.txt'), 'w') as f:
    f.write('\n'.join(standard_pkgs) + '\n')

with open(os.path.join(dotfiles_pkg, 'blackarch.txt'), 'w') as f:
    f.write('\n'.join(blackarch_pkgs) + '\n')

# NPM global packages snapshot
npm_pkgs = set()
npm_global = os.path.expanduser('~/.npm-global/lib/node_modules')
if os.path.exists(npm_global):
    for item in os.listdir(npm_global):
        if not item.startswith('.'):
            npm_pkgs.add(item)
usr_node = '/usr/lib/node_modules'
if os.path.exists(usr_node):
    for item in os.listdir(usr_node):
        p = os.path.join(usr_node, item)
        res = subprocess.run(['pacman', '-Qo', p], capture_output=True)
        if res.returncode != 0:
            npm_pkgs.add(item)
with open(os.path.join(dotfiles_pkg, 'npm.txt'), 'w') as f:
    f.write('\n'.join(sorted(npm_pkgs)) + '\n')

# UV tools snapshot
uv_pkgs = []
try:
    uv_out = subprocess.check_output(['uv', 'tool', 'list'], stderr=subprocess.DEVNULL).decode().splitlines()
    for line in uv_out:
        parts = line.strip().split()
        if len(parts) >= 2 and parts[1].startswith('v'):
            uv_pkgs.append(parts[0])
except Exception:
    pass
with open(os.path.join(dotfiles_pkg, 'uv.txt'), 'w') as f:
    f.write('\n'.join(sorted(uv_pkgs)) + '\n')
PY_EOF

# 2. AUR packages
pacman -Qeqm | sort > "$DOTFILES_DIR/packages/aur.txt"

# 3. Flatpak applications & overrides
if command -v flatpak &>/dev/null; then
    flatpak list --app --columns=application 2>/dev/null | sort > "$DOTFILES_DIR/packages/flatpak.txt"
    if [ -d "$HOME/.local/share/flatpak/overrides" ]; then
        mkdir -p "$DOTFILES_DIR/packages/flatpak-overrides"
        cp -r "$HOME/.local/share/flatpak/overrides/"* "$DOTFILES_DIR/packages/flatpak-overrides/" 2>/dev/null || true
    fi
fi

# 4. System & User Services Snapshot
systemctl list-unit-files --state=enabled --no-legend 2>/dev/null | awk '{print $1}' | grep -v "@" | sort > "$DOTFILES_DIR/packages/services-system.txt" || true
systemctl --user list-unit-files --state=enabled --no-legend 2>/dev/null | awk '{print $1}' | grep -v "@" | sort > "$DOTFILES_DIR/packages/services-user.txt" || true

# 5. System Configurations Snapshot (pacman.conf, hardware configs, dconf)
mkdir -p "$DOTFILES_DIR/system/etc/pacman.d" "$DOTFILES_DIR/system/hardware/thinkpad/modprobe.d" "$DOTFILES_DIR/system/hardware/thinkpad/udev" "$DOTFILES_DIR/system/hardware/thinkpad/etc"
cp /etc/pacman.conf "$DOTFILES_DIR/system/etc/pacman.conf" 2>/dev/null || true
cp /etc/pacman.d/blackarch-mirrorlist "$DOTFILES_DIR/system/etc/pacman.d/" 2>/dev/null || true
cp /etc/modprobe.d/thinkpad_acpi.conf /etc/modprobe.d/ec_sys.conf "$DOTFILES_DIR/system/hardware/thinkpad/modprobe.d/" 2>/dev/null || true
cp /etc/udev/rules.d/99-thinklight.rules "$DOTFILES_DIR/system/hardware/thinkpad/udev/" 2>/dev/null || true
cp /etc/thinkfan.conf "$DOTFILES_DIR/system/hardware/thinkpad/etc/" 2>/dev/null || true
dconf dump / > "$DOTFILES_DIR/system/dconf-settings.ini" 2>/dev/null || true

# 6. AI Assistant Configurations & Manifests Snapshot
python3 - << 'PY_EOF'
import json, os, shutil, subprocess

dotfiles = os.path.expanduser('~/dotfiles')
ai_dir = os.path.join(dotfiles, 'ai')
os.makedirs(os.path.join(ai_dir, 'agents', 'rules'), exist_ok=True)
os.makedirs(os.path.join(ai_dir, 'claude'), exist_ok=True)
os.makedirs(os.path.join(ai_dir, 'gemini'), exist_ok=True)
os.makedirs(os.path.join(ai_dir, 'cursor'), exist_ok=True)
os.makedirs(os.path.join(ai_dir, 'codex'), exist_ok=True)
home = os.path.expanduser('~')

# Agents skill lock & rules
f_lock = os.path.join(home, '.agents', '.skill-lock.json')
if os.path.isfile(f_lock):
    shutil.copy(f_lock, os.path.join(ai_dir, 'agents', '.skill-lock.json'))
f_rule = os.path.join(home, '.agents', 'rules', 'claude-mem-context.md')
if os.path.isfile(f_rule):
    shutil.copy(f_rule, os.path.join(ai_dir, 'agents', 'rules', 'claude-mem-context.md'))

# Claude plugins & sanitized settings
f_cplug = os.path.join(home, '.claude', 'plugins', 'installed_plugins.json')
if os.path.isfile(f_cplug):
    shutil.copy(f_cplug, os.path.join(ai_dir, 'claude', 'installed_plugins.json'))
f_cset = os.path.join(home, '.claude', 'settings.json')
if os.path.isfile(f_cset):
    try:
        with open(f_cset) as f:
            c_data = json.load(f)
        if 'env' in c_data and 'ANTHROPIC_AUTH_TOKEN' in c_data['env']:
            del c_data['env']['ANTHROPIC_AUTH_TOKEN']
        with open(os.path.join(ai_dir, 'claude', 'settings.json'), 'w') as f:
            json.dump(c_data, f, indent=2)
    except Exception:
        pass

# Gemini / Antigravity
f_gset = os.path.join(home, '.gemini', 'settings.json')
if os.path.isfile(f_gset):
    shutil.copy(f_gset, os.path.join(ai_dir, 'gemini', 'settings.json'))
f_gmcp = os.path.join(home, '.gemini', 'antigravity', 'mcp_config.json')
if os.path.isfile(f_gmcp):
    shutil.copy(f_gmcp, os.path.join(ai_dir, 'gemini', 'mcp_config.json'))
try:
    agy_out = subprocess.check_output(['agy', 'plugin', 'list'], stderr=subprocess.DEVNULL).decode()
    with open(os.path.join(ai_dir, 'gemini', 'plugins.json'), 'w') as f:
        f.write(agy_out)
except Exception:
    pass

# Cursor & Codex
f_cur_mcp = os.path.join(home, '.cursor', 'mcp.json')
if os.path.isfile(f_cur_mcp):
    shutil.copy(f_cur_mcp, os.path.join(ai_dir, 'cursor', 'mcp.json'))
f_cur_man = os.path.join(home, '.cursor', 'skills-cursor', '.sync-manifest.json')
if os.path.isfile(f_cur_man):
    shutil.copy(f_cur_man, os.path.join(ai_dir, 'cursor', 'skills-manifest.json'))
f_codex = os.path.join(home, '.codex', 'config.toml')
if os.path.isfile(f_codex):
    shutil.copy(f_codex, os.path.join(ai_dir, 'codex', 'config.toml'))
PY_EOF

echo -e "\033[1;32m✓ State snapshot complete:\033[0m"
echo -e "  - Packages: $(wc -l < "$DOTFILES_DIR/packages/pacman.txt") Arch, $(wc -l < "$DOTFILES_DIR/packages/blackarch.txt") BlackArch, $(wc -l < "$DOTFILES_DIR/packages/aur.txt") AUR, $(wc -l < "$DOTFILES_DIR/packages/flatpak.txt") Flatpak, $(wc -l < "$DOTFILES_DIR/packages/npm.txt") NPM, $(wc -l < "$DOTFILES_DIR/packages/uv.txt") UV."
echo -e "  - Services: $(wc -l < "$DOTFILES_DIR/packages/services-system.txt") System, $(wc -l < "$DOTFILES_DIR/packages/services-user.txt") User."
echo -e "  - Desktop: Dconf settings dumped ($(wc -l < "$DOTFILES_DIR/system/dconf-settings.ini") lines)."
echo -e "  - AI Ecosystem: Claude, Gemini, Agents skill-lock, Cursor, and Codex configurations snapshotted."

# 6. Git commit & push
git add -A

if git diff-index --quiet HEAD --; then
    echo -e "\033[1;33m:: No changes to commit. Everything is up to date.\033[0m"
else
    COMMIT_MSG="${1:-Update dotfiles & system state $(date '+%Y-%m-%d %H:%M')}"
    git commit -m "$COMMIT_MSG"
    echo -e "\033[1;34m:: Pushing changes to remote repository...\033[0m"
    git push origin main
    echo -e "\033[1;32m✓ Dotfiles & system state successfully pushed to GitHub!\033[0m"
fi
