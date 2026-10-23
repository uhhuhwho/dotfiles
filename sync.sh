#!/usr/bin/env bash
# ==============================================================================
# dotfiles sync script (dotsync)
# Multi-machine aware: detects current hardware profile, separates hardware
# packages/services into machines/<profile>/, union-merges shared packages so
# syncing on one laptop never deletes another laptop's packages, and pushes to GitHub.
#
# Usage:
#   dotsync "Commit message"
#   dotsync --prune "Commit message"   # Overwrite shared lists with only this machine's packages
# ==============================================================================

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
cd "$DOTFILES_DIR"

PRUNE_MODE=0
if [[ "${1:-}" == "--prune" ]]; then
    PRUNE_MODE=1
    shift
fi

MACHINE_PROFILE="$("$DOTFILES_DIR/scripts/system/detect-machine.sh")"
MACHINE_INFO="$("$DOTFILES_DIR/scripts/system/detect-machine.sh" --info)"
MACHINE_DIR="$DOTFILES_DIR/machines/$MACHINE_PROFILE"
mkdir -p "$MACHINE_DIR" "$DOTFILES_DIR/packages"

echo -e "\033[1;34m:: Detected Machine Profile:\033[0m \033[1;36m$MACHINE_INFO\033[0m"
echo -e "\033[1;34m:: Snapshotting packages, services & system state...\033[0m"

# 1. Native, BlackArch, AUR, NPM, UV & Services separation (Multi-Machine Aware)
DOTFILES_MACHINE="$MACHINE_PROFILE" PRUNE_MODE="$PRUNE_MODE" python3 - << 'PY_EOF'
import os
import re
import subprocess

dotfiles = os.path.expanduser('~/dotfiles')
pkg_dir = os.path.join(dotfiles, 'packages')
machine = os.environ.get('DOTFILES_MACHINE', 'generic')
prune = os.environ.get('PRUNE_MODE', '0') == '1'
machine_dir = os.path.join(dotfiles, 'machines', machine)
os.makedirs(pkg_dir, exist_ok=True)
os.makedirs(machine_dir, exist_ok=True)

# Hardware-specific package regexes routed to machines/<profile>/
HW_PKG_PATTERNS = [
    r'^(amd|intel)-ucode$',
    r'^(lib32-)?vulkan-(intel|radeon|nouveau)$',
    r'^(lib32-)?amdvlk$',
    r'^xf86-video-(intel|amdgpu|ati|nouveau|vesa)$',
    r'^(lib32-)?nvidia(-.*)?$',
    r'^cuda(-.*)?$',
    r'^optimus-manager(-.*)?$',
    r'^bbswitch(-.*)?$',
    r'^thinkfan(-.*)?$',
    r'^tp_smapi(-.*)?$',
    r'^acpi_call(-.*)?$',
    r'^(intel-media-driver|libva-intel-driver|libva-mesa-driver)$',
]
hw_pkg_re = re.compile('|'.join(HW_PKG_PATTERNS))

# Hardware-specific systemd service regexes routed to machines/<profile>/
HW_SVC_PATTERNS = [
    r'^thinkfan.*\.(service|socket|timer)$',
    r'^nvidia.*\.(service|socket|timer)$',
    r'^optimus-manager.*\.(service|socket|timer)$',
    r'^tlp.*\.(service|socket|timer)$',
]
hw_svc_re = re.compile('|'.join(HW_SVC_PATTERNS))

all_machine_hw_pkgs = set()
machines_root = os.path.join(dotfiles, 'machines')
if os.path.isdir(machines_root):
    for root, dirs, files in os.walk(machines_root):
        for fname in ('pacman.txt', 'aur.txt'):
            if fname in files:
                fpath = os.path.join(root, fname)
                with open(fpath) as f:
                    for line in f:
                        p = line.strip()
                        if p and not p.startswith('#'):
                            all_machine_hw_pkgs.add(p)

def is_hw_pkg(pkg: str) -> bool:
    return bool(hw_pkg_re.match(pkg)) or pkg in all_machine_hw_pkgs

def read_list(path: str) -> set[str]:
    if not os.path.isfile(path):
        return set()
    with open(path) as f:
        return {line.strip() for line in f if line.strip() and not line.startswith('#')}

def write_list(path: str, items: set[str] | list[str], union_existing: bool = False) -> int:
    final = set(items)
    if union_existing and not prune:
        final |= read_list(path)
    sorted_items = sorted(final)
    with open(path, 'w') as f:
        if sorted_items:
            f.write('\n'.join(sorted_items) + '\n')
        else:
            f.write('')
    return len(sorted_items)

# BlackArch repo package list
ba_pkgs = set()
try:
    ba_out = subprocess.check_output(['pacman', '-Sl', 'blackarch'], stderr=subprocess.DEVNULL).decode().splitlines()
    for line in ba_out:
        parts = line.split()
        if len(parts) >= 2:
            ba_pkgs.add(parts[1])
except Exception:
    # Fallback to existing blackarch.txt if repo isn't enabled on this machine
    ba_pkgs = read_list(os.path.join(pkg_dir, 'blackarch.txt'))

# 1. Native packages (pacman -Qeqn)
native_pkgs = subprocess.check_output(['pacman', '-Qeqn']).decode().splitlines()
shared_pacman = set()
shared_blackarch = set()
machine_pacman = set()

for pkg in native_pkgs:
    pkg = pkg.strip()
    if not pkg:
        continue
    if is_hw_pkg(pkg):
        machine_pacman.add(pkg)
    elif pkg in ba_pkgs and pkg != 'yay':
        shared_blackarch.add(pkg)
    else:
        shared_pacman.add(pkg)

# Remove any hardware packages that may have existed in shared pacman.txt
existing_shared_pacman = read_list(os.path.join(pkg_dir, 'pacman.txt')) - all_machine_hw_pkgs - machine_pacman
if not prune:
    shared_pacman |= existing_shared_pacman

write_list(os.path.join(pkg_dir, 'pacman.txt'), shared_pacman, union_existing=False)
write_list(os.path.join(pkg_dir, 'blackarch.txt'), shared_blackarch, union_existing=True)
write_list(os.path.join(machine_dir, 'pacman.txt'), machine_pacman, union_existing=False)

# 2. AUR packages (pacman -Qeqm)
aur_out = subprocess.check_output(['pacman', '-Qeqm']).decode().splitlines()
shared_aur = set()
machine_aur = set()
for pkg in aur_out:
    pkg = pkg.strip()
    if not pkg:
        continue
    if is_hw_pkg(pkg):
        machine_aur.add(pkg)
    else:
        shared_aur.add(pkg)

existing_shared_aur = read_list(os.path.join(pkg_dir, 'aur.txt')) - all_machine_hw_pkgs - machine_aur
if not prune:
    shared_aur |= existing_shared_aur

write_list(os.path.join(pkg_dir, 'aur.txt'), shared_aur, union_existing=False)
write_list(os.path.join(machine_dir, 'aur.txt'), machine_aur, union_existing=False)

# 3. NPM global packages
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
write_list(os.path.join(pkg_dir, 'npm.txt'), npm_pkgs, union_existing=True)

# 4. UV tools
uv_pkgs = set()
try:
    uv_out = subprocess.check_output(['uv', 'tool', 'list'], stderr=subprocess.DEVNULL).decode().splitlines()
    for line in uv_out:
        parts = line.strip().split()
        if len(parts) >= 2 and parts[1].startswith('v'):
            uv_pkgs.add(parts[0])
except Exception:
    pass
write_list(os.path.join(pkg_dir, 'uv.txt'), uv_pkgs, union_existing=True)

# 5. Hyprland hyprpm plugins
hyprpm_repos = set()
try:
    cache_user = os.getenv('USER', 'badreddine')
    cache_dir = f'/var/cache/hyprpm/{cache_user}'
    if os.path.isdir(cache_dir):
        for entry in os.listdir(cache_dir):
            state_file = os.path.join(cache_dir, entry, 'state.toml')
            if os.path.isfile(state_file):
                with open(state_file) as sf:
                    txt = sf.read()
                    url_m = re.search(r"url\s*=\s*'([^']+)'", txt)
                    if url_m:
                        hyprpm_repos.add(url_m.group(1))
except Exception:
    pass
try:
    res = subprocess.run(['hyprpm', 'list'], capture_output=True, text=True)
    if res.returncode == 0:
        for line in res.stdout.splitlines():
            m = re.search(r'(https?://[^\s]+)', line)
            if m:
                hyprpm_repos.add(m.group(1).rstrip('/'))
except Exception:
    pass
if hyprpm_repos:
    write_list(os.path.join(pkg_dir, 'hyprpm.txt'), hyprpm_repos, union_existing=True)

# 5. System & User Services
def get_enabled_services(user_mode: bool = False) -> list[str]:
    cmd = ['systemctl']
    if user_mode:
        cmd.append('--user')
    cmd += ['list-unit-files', '--state=enabled', '--no-legend']
    try:
        out = subprocess.check_output(cmd, stderr=subprocess.DEVNULL).decode().splitlines()
        svcs = []
        for line in out:
            parts = line.split()
            if parts and '@' not in parts[0]:
                svcs.append(parts[0])
        return svcs
    except Exception:
        return []

sys_svcs = get_enabled_services(user_mode=False)
shared_sys_svcs = {s for s in sys_svcs if not hw_svc_re.match(s)}
machine_sys_svcs = {s for s in sys_svcs if hw_svc_re.match(s)}

existing_shared_svcs = {s for s in read_list(os.path.join(pkg_dir, 'services-system.txt')) if not hw_svc_re.match(s)}
if not prune:
    shared_sys_svcs |= existing_shared_svcs

write_list(os.path.join(pkg_dir, 'services-system.txt'), shared_sys_svcs, union_existing=False)
write_list(os.path.join(machine_dir, 'services-system.txt'), machine_sys_svcs, union_existing=False)

user_svcs = set(get_enabled_services(user_mode=True))
write_list(os.path.join(pkg_dir, 'services-user.txt'), user_svcs, union_existing=True)
PY_EOF

# 2. Flatpak applications & overrides (Union-merged unless --prune)
if command -v flatpak &>/dev/null; then
    if [[ "$PRUNE_MODE" -eq 1 ]] || [[ ! -f "$DOTFILES_DIR/packages/flatpak.txt" ]]; then
        flatpak list --app --columns=application 2>/dev/null | sort -u > "$DOTFILES_DIR/packages/flatpak.txt"
    else
        {
            cat "$DOTFILES_DIR/packages/flatpak.txt"
            flatpak list --app --columns=application 2>/dev/null || true
        } | sed '/^[[:space:]]*$/d' | sort -u > "$DOTFILES_DIR/packages/flatpak.txt.tmp"
        mv "$DOTFILES_DIR/packages/flatpak.txt.tmp" "$DOTFILES_DIR/packages/flatpak.txt"
    fi
    if [[ -d "$HOME/.local/share/flatpak/overrides" ]]; then
        mkdir -p "$DOTFILES_DIR/packages/flatpak-overrides"
        cp -r "$HOME/.local/share/flatpak/overrides/"* "$DOTFILES_DIR/packages/flatpak-overrides/" 2>/dev/null || true
    fi
fi

# 3. System Configurations Snapshot (pacman.conf, machine-specific hardware configs, dconf)
mkdir -p "$DOTFILES_DIR/system/etc/pacman.d"
cp /etc/pacman.conf "$DOTFILES_DIR/system/etc/pacman.conf" 2>/dev/null || true
cp /etc/pacman.d/blackarch-mirrorlist "$DOTFILES_DIR/system/etc/pacman.d/" 2>/dev/null || true
dconf dump / > "$DOTFILES_DIR/system/dconf-settings.ini" 2>/dev/null || true
# AppImage inventory (binaries aren't committed, only the list)
find "$HOME/Documents/Apps/AppImages" "$HOME/Applications" -iname '*.appimage' 2>/dev/null \
    | sed "s|^$HOME|~|" | LC_ALL=C sort > "$DOTFILES_DIR/packages/appimages.txt" || true
# Custom-app icons & launchers (small artwork + .desktop files, not the heavy binaries).
# Launchers are filtered to the ones pointing at ~/Documents/Apps, ~/Applications or our
# custom icon dir, so waydroid/wine/flatpak-generated entries are left out.
rm -rf "$DOTFILES_DIR/packages/app-icons" "$DOTFILES_DIR/packages/app-launchers"
mkdir -p "$DOTFILES_DIR/packages/app-icons" "$DOTFILES_DIR/packages/app-launchers"
cp -r "$HOME/.local/share/icons/custom-apps/." "$DOTFILES_DIR/packages/app-icons/" 2>/dev/null || true
(cd "$HOME/.local/share/applications" 2>/dev/null \
    && grep -lE "Documents/Apps|/Applications/|icons/custom-apps" *.desktop 2>/dev/null \
    | xargs -r -I{} cp {} "$DOTFILES_DIR/packages/app-launchers/") || true
# Qt/KDE theming (copied, not symlinked: Qt/KDE save by replacing the file, which breaks symlinks)
mkdir -p "$DOTFILES_DIR/system/qt/qt6ct"
for f in qt6ct/qt6ct.conf kdeglobals Trolltech.conf; do
    [[ -f "$HOME/.config/$f" ]] && cp "$HOME/.config/$f" "$DOTFILES_DIR/system/qt/$f"
done

# Snapshot ThinkPad hardware configs ONLY when running on ThinkPad X230
if [[ "$MACHINE_PROFILE" == "thinkpad/x230" ]]; then
    mkdir -p "$MACHINE_DIR/modprobe.d" "$MACHINE_DIR/udev" "$MACHINE_DIR/etc"
    cp /etc/modprobe.d/thinkpad_acpi.conf /etc/modprobe.d/ec_sys.conf "$MACHINE_DIR/modprobe.d/" 2>/dev/null || true
    cp /etc/udev/rules.d/99-thinklight.rules "$MACHINE_DIR/udev/" 2>/dev/null || true
    cp /etc/thinkfan.conf "$MACHINE_DIR/etc/" 2>/dev/null || true
fi

# 4. Docker Compose Configurations Snapshot
if [[ -d "$HOME/Documents/Docker" ]]; then
    for compose_file in "$HOME/Documents/Docker"/*/docker-compose.yml; do
        if [[ -f "$compose_file" ]]; then
            stack_dir="$(dirname "$compose_file")"
            stack_name="$(basename "$stack_dir")"
            mkdir -p "$DOTFILES_DIR/docker/$stack_name"
            cp "$compose_file" "$DOTFILES_DIR/docker/$stack_name/" 2>/dev/null || true
            for extra in "$stack_dir"/.env.example "$stack_dir"/README.md "$stack_dir"/start.sh "$stack_dir"/Dockerfile*; do
                [[ -f "$extra" ]] && cp "$extra" "$DOTFILES_DIR/docker/$stack_name/" 2>/dev/null || true
            done
        fi
    done
fi

# 5. AI Assistant Configurations & Manifests Snapshot
python3 - << 'PY_EOF'
import json, os, shutil, subprocess

dotfiles = os.path.expanduser('~/dotfiles')
ai_dir = os.path.join(dotfiles, 'ai')
os.makedirs(os.path.join(ai_dir, 'agents', 'rules'), exist_ok=True)
os.makedirs(os.path.join(ai_dir, 'claude'), exist_ok=True)
os.makedirs(os.path.join(ai_dir, 'gemini'), exist_ok=True)
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

# Codex CLI
f_codex = os.path.join(home, '.codex', 'config.toml')
if os.path.isfile(f_codex):
    shutil.copy(f_codex, os.path.join(ai_dir, 'codex', 'config.toml'))
PY_EOF

echo -e "\033[1;32m✓ State snapshot complete for profile [$MACHINE_PROFILE]:\033[0m"
echo -e "  - Shared Packages : $(wc -l < "$DOTFILES_DIR/packages/pacman.txt") Arch, $(wc -l < "$DOTFILES_DIR/packages/blackarch.txt") BlackArch, $(wc -l < "$DOTFILES_DIR/packages/aur.txt") AUR, $(wc -l < "$DOTFILES_DIR/packages/flatpak.txt") Flatpak, $(wc -l < "$DOTFILES_DIR/packages/npm.txt") NPM, $(wc -l < "$DOTFILES_DIR/packages/uv.txt") UV, $(wc -l < "$DOTFILES_DIR/packages/hyprpm.txt" 2>/dev/null || echo 0) Hyprland plugins."
echo -e "  - Machine Profile : $(wc -l < "$MACHINE_DIR/pacman.txt") hardware Arch pkgs, $(wc -l < "$MACHINE_DIR/aur.txt") hardware AUR pkgs in machines/$MACHINE_PROFILE/."
echo -e "  - Services        : $(wc -l < "$DOTFILES_DIR/packages/services-system.txt") shared system, $(wc -l < "$MACHINE_DIR/services-system.txt") machine system, $(wc -l < "$DOTFILES_DIR/packages/services-user.txt") user."
echo -e "  - Docker & AI     : Compose stacks in docker/ + Claude, Gemini & Codex configs snapshotted."

# 6. Git commit & push
git add -A

if git diff-index --quiet HEAD --; then
    echo -e "\033[1;33m:: No changes to commit. Everything is up to date.\033[0m"
else
    COMMIT_MSG="${1:-Sync dotfiles & state [$MACHINE_PROFILE] $(date '+%Y-%m-%d %H:%M')}"
    git commit -m "$COMMIT_MSG"
    echo -e "\033[1;34m:: Pushing changes to remote repository...\033[0m"
    if git -c credential.interactive=never push origin main 2>/dev/null; then
        echo -e "\033[1;32m✓ Dotfiles & system state successfully pushed to GitHub!\033[0m"
    else
        echo -e "\033[1;33m:: Local commit created. Run 'git push' to sync to GitHub when authenticated.\033[0m"
    fi
fi
