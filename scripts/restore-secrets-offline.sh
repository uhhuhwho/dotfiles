#!/usr/bin/env bash
# ==============================================================================
# Offline Secrets Restore
# Decrypts and places SSH keys, Wi-Fi connections, and API tokens
# ==============================================================================

set -euo pipefail

ARCHIVE="${1:-}"

if [ -z "$ARCHIVE" ] || [ ! -f "$ARCHIVE" ]; then
    echo "Usage: $0 <path_to_encrypted_secrets.tar.gz.gpg>"
    exit 1
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo -e "\033[1;34m:: Decrypting secrets archive...\033[0m"
gpg --decrypt "$ARCHIVE" > "$TMP_DIR/secrets.tar.gz"
tar -xzf "$TMP_DIR/secrets.tar.gz" -C "$TMP_DIR"

# 1. Restore SSH
if [ -d "$TMP_DIR/ssh" ]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    cp -r "$TMP_DIR/ssh/"* "$HOME/.ssh/"
    chmod 600 "$HOME/.ssh/"*
    chmod 644 "$HOME/.ssh/"*.pub 2>/dev/null || true
    echo "  ✓ SSH keys restored"
fi

# 2. Restore ~/.bashrc.local
if [ -f "$TMP_DIR/bashrc.local" ]; then
    cp "$TMP_DIR/bashrc.local" "$HOME/.bashrc.local"
    chmod 600 "$HOME/.bashrc.local"
    echo "  ✓ ~/.bashrc.local restored"
fi

# 3. Restore Wi-Fi connections
if [ -d "$TMP_DIR/wifi" ] && [ "$(ls -A "$TMP_DIR/wifi" 2>/dev/null)" ]; then
    echo -e "\033[1;34m:: Restoring Wi-Fi connections (requires sudo)...\033[0m"
    sudo mkdir -p /etc/NetworkManager/system-connections
    sudo cp -r "$TMP_DIR/wifi/"* /etc/NetworkManager/system-connections/
    sudo chmod 600 /etc/NetworkManager/system-connections/*
    sudo nmcli connection reload || true
    echo "  ✓ Wi-Fi connections restored"
fi

echo -e "\033[1;32m✓ All machine secrets and credentials restored successfully!\033[0m"
