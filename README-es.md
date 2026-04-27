# One-Key HiDPI - Premium Edition 🚀

[English](README.md) | [Português](README-ptbr.md) | [Español](README-es.md) | [Français](README-fr.md) | [日本語](README-jp.md) | [简体中文](README-zh.md)

![HiDPI Preview](img/hidpi.gif)

Active el modo HiDPI (Retina) en su macOS para monitores internos y externos con una interfaz premium y detección automática de hardware.

## ✨ Características
- **Detección Inteligente**: Detecta automáticamente la resolución nativa y la tasa de refresco (Hz).
- **Interfaz Premium (TUI)**: Colorida, intuitiva y moderna.
- **Multi-idioma**: Soporte para ES, PT-BR, EN, FR, JP y ZH.
- **Corrección de Logo en Boot**: Resuelve el problema del logo de Apple gigante.
- **Control de Profundidad de Color**: Soporte para 8 bits, 10 bits (HDR) y 12 bits Pro.
- **Alta Frecuencia y VRR**: Desbloquee 144Hz+ y ProMotion (Tasa de Refresco Variable).
- **Activación Forzada Retina**: Activa la experiencia nativa Apple Retina.
- **Nombre Personalizado**: Elija el nombre que aparecerá en los Ajustes del Sistema.
- **Seguridad**: Copias de seguridad automáticas y avisos de estabilidad.

![Preferences](img/preferences.jpg)

## 📦 Cómo Usar
1. Descargue o clone este repositorio.
2. Haga doble clic en `hidpi.command` o ejecute en el terminal:
   ```bash
   bash hidpi.sh
   ```
3. Siga las instrucciones coloridas en pantalla.

### 📸 Resumen del Proceso
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

4. Reinicie el sistema para aplicar los cambios.

## 🛠 Recuperación Manual
El script crea una copia de seguridad en:
`/Library/Displays/Contents/Resources/Overrides.bak`

Puede restaurarla usando:
```bash
sudo cp -r /Library/Displays/Contents/Resources/Overrides.bak /Library/Displays/Contents/Resources/Overrides
```

---
*Creado con ❤️ para la comunidad Hackintosh y macOS.*
