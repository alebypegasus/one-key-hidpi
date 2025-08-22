#!/bin/bash

# Enhanced HiDPI Restore Script
# Generated on: Fri Aug 22 14:01:52 -03 2025
# Script Version: 2.0.0

set -e

RESTORE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="/Library/Displays/Contents/Resources/Overrides"
METADATA_FILE="${RESTORE_DIR}/backup_metadata.json"

echo "Restoring HiDPI configuration..."
echo "Restore directory: ${RESTORE_DIR}"

# Check if metadata exists
if [[ -f "${METADATA_FILE}" ]]; then
    echo "Backup metadata found:"
    cat "${METADATA_FILE}" | python3 -m json.tool 2>/dev/null || echo "Metadata file exists but cannot be parsed"
fi

# Restore HiDPI configuration
if [[ -f "${RESTORE_DIR}/hidpi_backup.tar.gz" ]]; then
    echo "Restoring HiDPI configuration..."
    sudo rm -rf "${TARGET_DIR}"
    sudo tar -xzf "${RESTORE_DIR}/hidpi_backup.tar.gz" -C "${TARGET_DIR%/*}"
    echo "✓ HiDPI configuration restored"
else
    echo "✗ Backup file not found"
    exit 1
fi

# Restore display preferences
if [[ -f "${RESTORE_DIR}/display_preferences.plist" ]]; then
    echo "Restoring display preferences..."
    sudo cp "${RESTORE_DIR}/display_preferences.plist" /Library/Preferences/com.apple.windowserver.plist
    echo "✓ Display preferences restored"
fi

# Restore monitor name if exists
if [[ -f "${RESTORE_DIR}/monitor_name.txt" ]]; then
    echo "Restoring monitor name..."
    MONITOR_NAME=$(cat "${RESTORE_DIR}/monitor_name.txt")
    echo "Monitor name: $MONITOR_NAME"
fi

echo ""
echo "Restore complete. Please restart your Mac."
echo ""
echo "Note: You may need to restart your Mac for all changes to take effect."
echo "If you experience issues, check the backup metadata for system information."
