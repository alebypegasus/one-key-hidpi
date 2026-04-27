# One-Key HiDPI - Premium Edition 🚀

[English](README.md) | [Português](README-ptbr.md) | [Español](README-es.md) | [Français](README-fr.md) | [日本語](README-jp.md) | [简体中文](README-zh.md)

![HiDPI Preview](img/hidpi.gif)

プレミアムなインターフェースとハードウェア自動検出機能を備えた、macOS向けのHiDPI（Retinaモード）有効化ツールです。内蔵および外付けディスプレイに対応しています。

## ✨ 特徴
- **スマート検出**: ネイティブ解像度とリフレッシュレート（Hz）を自動的に検出します。
- **プレミアムTUI**: カラフルで直感的なターミナルインターフェース。
- **マルチ言語対応**: 日本語、英語、ポルトガル語、スペイン語、フランス語、中国語をサポート。
- **起動ロゴの修正**: 1080pモニタでAppleロゴが巨大化する問題を解決します。
- **カスタム名設定**: システム設定に表示されるディスプレイ名を自由に変更可能。
- **安全第一**: 自動システムバックアップと安定性に関する警告機能。

![Preferences](img/preferences.jpg)

## 📦 使い方
1. このリポジトリをダウンロードまたはクローンします。
2. `hidpi.command`をダブルクリックするか、ターミナルで実行してください：
   ```bash
   bash hidpi.sh
   ```
3. 画面に表示されるカラフルな指示に従ってください。

### 📸 プロセスの概要
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

4. システムを再起動して設定を反映させます。

## 🛠 手動リカバリ
スクリプトは以下の場所にバックアップを作成します：
`/Library/Displays/Contents/Resources/Overrides.bak`

以下のコマンドで復元可能です：
```bash
sudo cp -r /Library/Displays/Contents/Resources/Overrides.bak /Library/Displays/Contents/Resources/Overrides
```

---
*HackintoshおよびmacOSコミュニティのために❤️を込めて作成されました。*
