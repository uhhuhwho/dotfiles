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

# 5. System Configurations Snapshot (pacman.conf, hardware configs)
mkdir -p "$DOTFILES_DIR/system/etc/pacman.d" "$DOTFILES_DIR/system/hardware/thinkpad/modprobe.d" "$DOTFILES_DIR/system/hardware/thinkpad/udev" "$DOTFILES_DIR/system/hardware/thinkpad/etc"
cp /etc/pacman.conf "$DOTFILES_DIR/system/etc/pacman.conf" 2>/dev/null || true
cp /etc/pacman.d/blackarch-mirrorlist "$DOTFILES_DIR/system/etc/pacman.d/" 2>/dev/null || true
cp /etc/modprobe.d/thinkpad_acpi.conf /etc/modprobe.d/ec_sys.conf "$DOTFILES_DIR/system/hardware/thinkpad/modprobe.d/" 2>/dev/null || true
cp /etc/udev/rules.d/99-thinklight.rules "$DOTFILES_DIR/system/hardware/thinkpad/udev/" 2>/dev/null || true
cp /etc/thinkfan.conf "$DOTFILES_DIR/system/hardware/thinkpad/etc/" 2>/dev/null || true

echo -e "\033[1;32m✓ State snapshot complete:\033[0m"
echo -e "  - Packages: $(wc -l < "$DOTFILES_DIR/packages/pacman.txt") Arch, $(wc -l < "$DOTFILES_DIR/packages/blackarch.txt") BlackArch, $(wc -l < "$DOTFILES_DIR/packages/aur.txt") AUR, $(wc -l < "$DOTFILES_DIR/packages/flatpak.txt") Flatpak."
echo -e "  - Services: $(wc -l < "$DOTFILES_DIR/packages/services-system.txt") System, $(wc -l < "$DOTFILES_DIR/packages/services-user.txt") User."

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
