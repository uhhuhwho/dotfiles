#!/usr/bin/env bash
# ==============================================================================
# Offline Secrets Backup (SSH, Wi-Fi passwords, GPG, and API Tokens)
# NEVER pushed to Git. Encrypts sensitive credentials for USB / offline transfer.
# ==============================================================================

set -euo pipefail

DEST="${1:-$HOME/Desktop/system_secrets_$(date +%Y%m%d).tar.gz.gpg}"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo -e "\033[1;34m:: Gathering sensitive machine credentials...\033[0m"

# 1. SSH Keys
if [ -d "$HOME/.ssh" ]; then
    mkdir -p "$TMP_DIR/ssh"
    cp -r "$HOME/.ssh/"* "$TMP_DIR/ssh/" 2>/dev/null || true
    echo "  ✓ SSH keys gathered"
fi

# 2. Local environment & API tokens
if [ -f "$HOME/.bashrc.local" ]; then
    cp "$HOME/.bashrc.local" "$TMP_DIR/bashrc.local"
    echo "  ✓ ~/.bashrc.local gathered"
fi

# 3. GPG Keys (if any)
if [ -d "$HOME/.gnupg" ]; then
    mkdir -p "$TMP_DIR/gnupg"
    cp -r "$HOME/.gnupg/"* "$TMP_DIR/gnupg/" 2>/dev/null || true
    echo "  ✓ GPG keyring gathered"
fi

# 4. NetworkManager Wi-Fi Passwords (requires sudo)
if [ -d "/etc/NetworkManager/system-connections" ]; then
    echo -e "\033[1;33m:: Reading saved Wi-Fi connections (requires sudo)...\033[0m"
    mkdir -p "$TMP_DIR/wifi"
    sudo cp -r /etc/NetworkManager/system-connections/* "$TMP_DIR/wifi/" 2>/dev/null || true
    sudo chown -R "$USER:$USER" "$TMP_DIR/wifi" 2>/dev/null || true
    echo "  ✓ Wi-Fi profiles gathered"
fi

# 5. Archive and Encrypt using GPG (AES-256)
echo -e "\033[1;34m:: Encrypting secrets archive with symmetric password...\033[0m"
tar -czf "$TMP_DIR/secrets.tar.gz" -C "$TMP_DIR" ssh bashrc.local gnupg wifi 2>/dev/null || tar -czf "$TMP_DIR/secrets.tar.gz" -C "$TMP_DIR" .
gpg --symmetric --cipher-algo AES256 -o "$DEST" "$TMP_DIR/secrets.tar.gz"

echo -e "\033[1;32m✓ Encrypted secrets archive created successfully at:\033[0m"
echo -e "  \033[1;36m$DEST\033[0m"
echo -e "Copy this file to a secure USB drive to transfer to your new device."
