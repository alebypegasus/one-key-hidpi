# One-Key HiDPI - Premium Edition 🚀

为您的 macOS 提供高级终端界面和硬件自动检测功能，开启内建及外接显示器的 HiDPI (Retina) 模式。

## ✨ 功能特性
- **智能检测**：自动检测原生分辨率和刷新率 (Hz)。
- **高级终端界面 (TUI)**：彩色、直观且现代。
- **多语言支持**：支持中文 (ZH)、英文 (EN)、葡语 (PT-BR)、西语 (ES)、法语 (FR) 和日语 (JP)。
- **启动 Logo 修复**：解决 Apple Logo 变大的问题。
- **颜色深度控制**：支持 8位、10位 (HDR) 和 12位专业色彩。
- **高刷新率与 VRR**：解锁 144Hz+ 和 ProMotion (可变刷新率)。
- **强制开启 Retina UI**：激活原生 Apple Retina 体验。
- **自定义命名**：可以自定义在系统设置中显示的显示器名称。
- **安全保障**：自动系统备份及稳定性警告。

## 📦 如何使用
1. 下载或克隆本仓库。
2. 双击 `hidpi.command` 或在终端中运行：
   ```bash
   bash hidpi.sh
   ```
3. 按照屏幕上的彩色指令进行操作。
4. 重启系统以应用更改。

## 🛠 手动恢复
脚本会在以下路径创建备份：
`/Library/Displays/Contents/Resources/Overrides.bak`

您可以使用以下命令进行恢复：
```bash
sudo cp -r /Library/Displays/Contents/Resources/Overrides.bak /Library/Displays/Contents/Resources/Overrides
```

---
*为 Hackintosh 和 macOS 社区精心打造 ❤️*
