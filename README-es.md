# One-Key HiDPI - Premium Edition 🚀

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

## 📦 Cómo Usar
1. Descargue o clone este repositorio.
2. Haga doble clic en `hidpi.command` o ejecute en el terminal:
   ```bash
   bash hidpi.sh
   ```
3. Siga las instrucciones coloridas en pantalla.
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
