#!/bin/bash
# Quick restore - just the essential files
RESTORE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="/Library/Displays/Contents/Resources/Overrides"

if [[ -f "${RESTORE_DIR}/hidpi_backup.tar.gz" ]]; then
    sudo rm -rf "${TARGET_DIR}"
    sudo tar -xzf "${RESTORE_DIR}/hidpi_backup.tar.gz" -C "${TARGET_DIR%/*}"
    echo "Quick restore completed. Please restart your Mac."
else
    echo "Backup file not found!"
    exit 1
fi
