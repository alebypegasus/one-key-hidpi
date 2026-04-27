# One-Key HiDPI - Premium Edition 🚀

[English](README.md) | [Português](README-ptbr.md) | [Español](README-es.md) | [Français](README-fr.md) | [日本語](README-jp.md) | [简体中文](README-zh.md)

![HiDPI Preview](img/hidpi.gif)

Enables HiDPI (Retina mode) on macOS for external and internal displays with a premium terminal interface and automatic hardware detection.

## ✨ Features
- **Smart Detection**: Automatically detects native resolution and refresh rate.
- **Premium TUI**: Colorful and intuitive terminal interface.
- **Multi-Language**: Supports EN, PT-BR, ES, FR, JP, and ZH.
- **Boot Logo Fix**: Corrects the oversized Apple logo issue.
- **Color Depth Control**: Support for 8-bit, 10-bit (HDR), and 12-bit Pro color.
- **High Refresh & VRR**: Unlock 144Hz+ and ProMotion (Variable Refresh Rate).
- **Retina UI Force**: Activates the native Apple Retina experience.
- **Custom Naming**: Name your monitor as it appears in System Settings.
- **Safety First**: Automatic system backups and stability warnings.

![Preferences](img/preferences.jpg)

## 📦 How to Use
1. Download or clone this repository.
2. Double-click `hidpi.command` or run in terminal:
   ```bash
   bash hidpi.sh
   ```
3. Follow the colorful on-screen instructions.

### 📸 Process Overview
<p align="center">
  <img src="img/prints/print1.png" width="45%" />
  <img src="img/prints/print2.png" width="45%" />
  <img src="img/prints/print3.png" width="45%" />
  <img src="img/prints/print4.png" width="45%" />
  <img src="img/prints/print5.png" width="45%" />
  <img src="img/prints/print6.png" width="45%" />
  <img src="img/prints/print7.png" width="45%" />
  <img src="img/prints/print8.png" width="45%" />
</p>

4. Reboot your system to apply changes.

## 🛠 Manual Recovery
If something goes wrong, the script creates a backup at:
`/Library/Displays/Contents/Resources/Overrides.bak`

You can restore it using:
```bash
sudo cp -r /Library/Displays/Contents/Resources/Overrides.bak /Library/Displays/Contents/Resources/Overrides
```

---
*Created with ❤️ for the Hackintosh and macOS community.*
