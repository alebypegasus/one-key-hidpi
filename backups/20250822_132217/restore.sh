#!/bin/bash
echo "Restoring HiDPI configuration..."
BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="/Library/Displays/Contents/Resources/Overrides"

if [[ -f "${BACKUP_DIR}/hidpi_backup.tar.gz" ]]; then
    sudo rm -rf "${TARGET_DIR}"
    sudo tar -xzf "${BACKUP_DIR}/hidpi_backup.tar.gz" -C "${TARGET_DIR%/*}"
    echo "✓ HiDPI configuration restored"
else
    echo "✗ Backup file not found"
fi

if [[ -f "${BACKUP_DIR}/display_preferences.plist" ]]; then
    sudo cp "${BACKUP_DIR}/display_preferences.plist" /Library/Preferences/com.apple.windowserver.plist
    echo "✓ Display preferences restored"
fi

echo "Restore complete. Please restart your Mac."
