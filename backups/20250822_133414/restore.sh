#!/bin/bash
echo "Restaurando configuração HiDPI..."
BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="/Library/Displays/Contents/Resources/Overrides"

if [[ -f "${BACKUP_DIR}/hidpi_backup.tar.gz" ]]; then
    sudo rm -rf "${TARGET_DIR}"
    sudo tar -xzf "${BACKUP_DIR}/hidpi_backup.tar.gz" -C "${TARGET_DIR%/*}"
    echo "✓ Configuração HiDPI restaurada"
else
    echo "✗ Arquivo de backup não encontrado"
fi

if [[ -f "${BACKUP_DIR}/display_preferences.plist" ]]; then
    sudo cp "${BACKUP_DIR}/display_preferences.plist" /Library/Preferences/com.apple.windowserver.plist
    echo "✓ Preferências de exibição restauradas"
fi

echo "Restauração completa. Por favor, reinicie seu Mac."
