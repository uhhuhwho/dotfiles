#!/usr/bin/env bash
# ==============================================================================
# dotfiles sync script (dotsync)
# Automatically updates package lists, stages changes, and pushes to GitHub
# ==============================================================================

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
cd "$DOTFILES_DIR"

echo -e "\033[1;34m:: Snapshotting system packages...\033[0m"

# 1. Native packages (explicitly installed, names only)
pacman -Qeqn | sort > "$DOTFILES_DIR/packages/pacman.txt"

# 2. AUR packages (explicitly installed foreign packages)
pacman -Qeqm | sort > "$DOTFILES_DIR/packages/aur.txt"

# 3. Flatpak applications (if flatpak exists)
if command -v flatpak &>/dev/null; then
    flatpak list --app --columns=application 2>/dev/null | sort > "$DOTFILES_DIR/packages/flatpak.txt"
    if [ -d "$HOME/.local/share/flatpak/overrides" ]; then
        mkdir -p "$DOTFILES_DIR/packages/flatpak-overrides"
        cp -r "$HOME/.local/share/flatpak/overrides/"* "$DOTFILES_DIR/packages/flatpak-overrides/" 2>/dev/null || true
    fi
fi

echo -e "\033[1;32m✓ Packages updated: $(wc -l < "$DOTFILES_DIR/packages/pacman.txt") native, $(wc -l < "$DOTFILES_DIR/packages/aur.txt") AUR, $(wc -l < "$DOTFILES_DIR/packages/flatpak.txt") flatpak.\033[0m"

# 4. Git status & commit
git add -A

if git diff-index --quiet HEAD --; then
    echo -e "\033[1;33m:: No changes to commit. Everything is up to date.\033[0m"
else
    COMMIT_MSG="${1:-Update dotfiles $(date '+%Y-%m-%d %H:%M')}"
    git commit -m "$COMMIT_MSG"
    echo -e "\033[1;34m:: Pushing changes to remote repository...\033[0m"
    git push origin main
    echo -e "\033[1;32m✓ Dotfiles successfully backed up and pushed to GitHub!\033[0m"
fi
