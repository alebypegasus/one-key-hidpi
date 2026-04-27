# One-Key HiDPI - Premium Edition 🚀

[English](README.md) | [Português](README-ptbr.md) | [Español](README-es.md) | [Français](README-fr.md) | [日本語](README-jp.md) | [简体中文](README-zh.md)

![HiDPI Preview](img/hidpi.gif)

Activez le mode HiDPI (Retina) sur votre macOS pour les écrans internes et externes avec une interface premium et une détection automatique du matériel.

## ✨ Caractéristiques
- **Détection Intelligente** : Détecte automatiquement la résolution native et le taux de rafraîchissement (Hz).
- **Interface Premium (TUI)** : Colorée, intuitive et moderne.
- **Multi-langue** : Support pour FR, EN, PT-BR, ES, JP et ZH.
- **Correction du Logo au Démarrage** : Résout le problème du logo Apple géant.
- **Controle de la profondeur de couleur** : Support pour 8 bits, 10 bits (HDR) et 12 bits Pro.
- **Fréquence élevée et VRR** : Débloquez 144Hz+ et ProMotion (Taux de Rafraîchissement Variable).
- **Activation Retina forcée** : Active l'expérience native Apple Retina.
- **Nom Personnalisé** : Choisissez le nom qui apparaîtra dans les Réglages Système.
- **Sécurité** : Sauvegardes automatiques et avertissements de stabilité.

![Preferences](img/preferences.jpg)

## 📦 Comment l'utiliser
1. Téléchargez ou clonez ce dépôt.
2. Double-cliquez sur `hidpi.command` ou exécutez dans le terminal :
   ```bash
   bash hidpi.sh
   ```
3. Suivez les instructions colorées à l'écran.

### 📸 Aperçu du Processus
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

4. Redémarrez le système pour appliquer les changements.

## 🛠 Récupération Manuelle
Le script crée une sauvegarde dans :
`/Library/Displays/Contents/Resources/Overrides.bak`

Vous pouvez la restaurer en utilisant :
```bash
sudo cp -r /Library/Displays/Contents/Resources/Overrides.bak /Library/Displays/Contents/Resources/Overrides
```

---
*Créé avec ❤️ pour la communauté Hackintosh et macOS.*
