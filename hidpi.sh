#!/bin/bash

# Colors for TUI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

function show_banner() {
    clear
    echo -e "${BLUE}  ═════════════════════════════════════════════════════════════════════════════  ${NC}"
    echo -e "${YELLOW}                 ${BOLD}OneKeyHiDPI - ULTIMATE EXPERIENCE${NC}                           "
    echo -e "${BLUE}  ═════════════════════════════════════════════════════════════════════════════  ${NC}"
}

currentDir="$(cd $(dirname -- $0) && pwd)"

# Detect language automatically
apple_lang=$(defaults read -g AppleLanguages | sed -n 's/.*"\([^"]*\)".*/\1/p' | head -n 1 | cut -d '-' -f 1)
systemLanguage="${apple_lang:-en}"

# Default Strings (English)
langDisplay="Display"
langMonitors="Monitors"
langIndex="Index"
langVendorID="VendorID"
langProductID="ProductID"
langMonitorName="Monitor Name"
langChooseDis="Choose the display"
langInputChoice="Enter your choice"
langEnterError="Invalid input. Exiting..."
langBackingUp="Backing up..."
langEnabled="Enabled successfully! Please reboot."
langDisabled="Disabled, restart takes effect."
langEnabledLog="The Apple logo will appear enlarged on the first reboot, but will return to normal size afterwards."
langCustomRes="Enter the HIDPI resolution, separated by a space (e.g., 1680x945 1600x900)"
langChooseIcon="Display Icon"
langNotChange="Do not change"
langNaming="Do you want to rename this monitor? (Leave empty for default):"
langReboot="Do you want to reboot now? (Make sure to save all your work first!) [y/n]"
langEnableHIDPI="(%d) Enable HIDPI"
langEnableHIDPIEDID="(%d) Enable HIDPI (with EDID)"
langDisableHIDPI="(%d) Disable HIDPI"
langDisableOpt1="(1) Disable HIDPI on this monitor"
langDisableOpt2="(2) Reset all settings to macOS default"
langChooseRes="Resolution Configuration"
langChooseResOp1="(1) 1920x1080 Monitor"
langChooseResOp2="(2) 1920x1080 Monitor (use 1424x802, fixes scale after sleep)"
langChooseResOp3="(3) 1920x1200 Monitor"
langChooseResOp4="(4) 2560x1440 Monitor"
langChooseResOp5="(5) 3000x2000 Monitor"
langChooseResOp6="(6) 3440x1440 Monitor"
langChooseResOpCustom="(7) Enter manual resolution"
langNoMonitFound="No monitors found. Exiting..."
langMonitVIDPID="Your monitor VID:PID:"
langWarning="WARNING: Resolutions above native may affect stability."
langColorDepth="Choose Color Depth"
langAuto="Automatic (Let macOS decide)"
lang8Bit="8-bit Color (Standard)"
lang10Bit="10-bit Color (HDR/Deep Color)"
lang12Bit="12-bit Color (Pro/Ultra Deep Color)"
langRefreshRate="Choose Refresh Rate Mode"
lang60Hz="Standard (60Hz)"
langHighRefresh="Gaming/High Refresh (144Hz+)"
langProMotion="ProMotion / Variable Refresh (VRR)"
langRetinaEnabled="Retina UI: ENABLED"

# Overrides for specific languages
case "${systemLanguage}" in
    pt)
        langDisplay="Monitor"
        langMonitors="Monitores"
        langIndex="Índice"
        langVendorID="VendorID"
        langProductID="ProductID"
        langMonitorName="Nome do Monitor"
        langChooseDis="Escolha o monitor"
        langInputChoice="Sua escolha"
        langEnterError="Erro de entrada. Operação cancelada."
        langBackingUp="Fazendo backup..."
        langEnabled="Ativado com sucesso! Por favor, reinicie."
        langDisabled="Desativado. Reinicie para aplicar as alterações."
        langEnabledLog="O logotipo da Apple aparecerá ampliado no primeiro reinício, mas voltará ao normal logo após."
        langCustomRes="Digite as resoluções HIDPI separadas por espaço (ex: 1680x945 1600x900)"
        langChooseIcon="Ícone do Monitor"
        langNotChange="Não alterar"
        langEnableHIDPI="(%d) Ativar HIDPI"
        langEnableHIDPIEDID="(%d) Ativar HIDPI (com EDID)"
        langDisableHIDPI="(%d) Desativar HIDPI"
        langDisableOpt1="(1) Desativar HIDPI neste monitor"
        langDisableOpt2="(2) Resetar todas as configurações para o padrão macOS"
        langChooseRes="Configuração de Resolução"
        langChooseResOp1="(1) Monitor 1920x1080"
        langChooseResOp2="(2) Monitor 1920x1080 (usar 1424x802, corrige escala após sleep)"
        langChooseResOp3="(3) Monitor 1920x1200"
        langChooseResOp4="(4) Monitor 2560x1440"
        langChooseResOp5="(5) Monitor 3000x2000"
        langChooseResOp6="(6) Monitor 3440x1440"
        langChooseResOpCustom="(7) Inserir resolução manual"
        langNoMonitFound="Nenhum monitor encontrado. Saindo..."
        langMonitVIDPID="Seu monitor VID:PID:"
        langWarning="AVISO: Resoluções acima da nativa podem afetar a estabilidade."
langColorDepth="Escolha a Profundidade de Cor"
langAuto="Automático (Deixar o macOS decidir)"
lang8Bit="Cores de 8 bits (Padrão)"
lang10Bit="Cores de 10 bits (HDR/Cores Profundas)"
lang12Bit="Cores de 12 bits (Pro/Cores Ultra Profundas)"
langRefreshRate="Escolha o Modo de Frequência (Refresh Rate)"
lang60Hz="Padrão (60Hz)"
langHighRefresh="Gaming/Alta Frequência (144Hz+)"
langProMotion="ProMotion / Frequência Variável (VRR)"
langRetinaEnabled="Interface Retina: ATIVADA"
        langNaming="Deseja renomear este monitor? (Deixe em branco para o padrão):"
        langReboot="Deseja reiniciar agora? (Certifique-se de salvar todo o seu trabalho primeiro!) [y/n]"
        ;;
    es)
        langDisplay="Monitor"
        langMonitors="Monitores"
        langIndex="Índice"
        langVendorID="VendorID"
        langProductID="ProductID"
        langMonitorName="Nombre del Monitor"
        langChooseDis="Elija el monitor"
        langInputChoice="Su elección"
        langEnterError="Error de entrada. Operación cancelada."
        langBackingUp="Haciendo copia de seguridad..."
        langEnabled="¡Activado con éxito! Por favor, reinicie."
        langDisabled="Desactivado. Reinicie para aplicar los cambios."
        langEnabledLog="El logotipo de Apple aparecerá ampliado en el primer reinicio, pero volverá a su tamaño normal después."
        langCustomRes="Ingrese las resoluciones HIDPI separadas por espacio (ej: 1680x945 1600x900)"
        langChooseIcon="Icono del Monitor"
        langNotChange="No cambiar"
        langEnableHIDPI="(%d) Activar HIDPI"
        langEnableHIDPIEDID="(%d) Activar HIDPI (con EDID)"
        langDisableHIDPI="(%d) Desactivar HIDPI"
        langDisableOpt1="(1) Desactivar HIDPI en este monitor"
        langDisableOpt2="(2) Restablecer todos los ajustes al valor predeterminado de macOS"
        langChooseRes="Configuración de Resolución"
        langChooseResOp1="(1) Monitor 1920x1080"
        langChooseResOp2="(2) Monitor 1920x1080 (usar 1424x802, corrige escala tras reposo)"
        langChooseResOp3="(3) Monitor 1920x1200"
        langChooseResOp4="(4) Monitor 2560x1440"
        langChooseResOp5="(5) Monitor 3000x2000"
        langChooseResOp6="(6) Monitor 3440x1440"
        langChooseResOpCustom="(7) Ingresar resolución manual"
        langNoMonitFound="No se encontraron monitores. Saliendo..."
        langMonitVIDPID="Su monitor VID:PID:"
        langWarning="ADVERTENCIA: Resoluciones por encima de la nativa pueden afectar la estabilidad."
        langColorDepth="Elegir profundidad de color"
        langAuto="Automático (Dejar que macOS decida)"
        lang8Bit="Color de 8 bits (Estándar)"
        lang10Bit="Color de 10 bits (HDR/Color Profundo)"
        lang12Bit="Color de 12 bits (Pro/Color Ultra Profundo)"
        langRefreshRate="Elegir modo de frecuencia de actualización"
        lang60Hz="Estándar (60Hz)"
        langHighRefresh="Gaming/Alta frecuencia (144Hz+)"
        langProMotion="ProMotion / Frecuencia Variable (VRR)"
        langRetinaEnabled="Interfaz Retina: ACTIVADA"
        langNaming="¿Desea cambiar el nombre de este monitor? (Deje vacío para mantener el valor predeterminado):"
        langReboot="¿Desea reiniciar ahora? (¡Asegúrese de guardar todo su trabajo primero!) [y/n]"
        ;;
    fr)
        langDisplay="Écran"
        langMonitors="Écrans"
        langIndex="Indice"
        langVendorID="VendorID"
        langProductID="ProductID"
        langMonitorName="Nom de l'écran"
        langChooseDis="Choisissez l'écran"
        langInputChoice="Votre choix"
        langEnterError="Saisie invalide. Fermeture..."
        langBackingUp="Sauvegarde en cours..."
        langEnabled="Activé avec succès ! Veuillez redémarrer."
        langDisabled="Désactivé. Redémarrez para aplicar les modifications."
        langEnabledLog="Le logo Apple apparaîtra agrandi au premier redémarrage, mais reviendra à sa taille normale par la suite."
        langCustomRes="Entrez les résolutions HIDPI séparées par un espace (ex : 1680x945 1600x900)"
        langChooseIcon="Icône de l'écran"
        langNotChange="Ne pas changer"
        langEnableHIDPI="(%d) Activer HIDPI"
        langEnableHIDPIEDID="(%d) Activer HIDPI (avec EDID)"
        langDisableHIDPI="(%d) Désactiver HIDPI"
        langDisableOpt1="(1) Désactiver HIDPI sur cet écran"
        langDisableOpt2="(2) Réinitialiser tous les paramètres par défaut de macOS"
        langChooseRes="Configuration de la résolution"
        langChooseResOp1="(1) Écran 1920x1080"
        langChooseResOp2="(2) Écran 1920x1080 (utiliser 1424x802, corriger l'échelle après la veille)"
        langChooseResOp3="(3) Écran 1920x1200"
        langChooseResOp4="(4) Écran 2560x1440"
        langChooseResOp5="(5) Écran 3000x2000"
        langChooseResOp6="(6) Écran 3440x1440"
        langChooseResOpCustom="(7) Saisir manuellement la résolution"
        langNoMonitFound="Aucun écran trouvé. Fermeture..."
        langMonitVIDPID="Votre moniteur VID:PID :"
        langWarning="AVERTISSEMENT : Les résolutions supérieures à la résolution native peuvent affecter la stabilité."
        langColorDepth="Choisir la profondeur de couleur"
        langAuto="Automatique (Laisser macOS décider)"
        lang8Bit="Couleur 8 bits (Standard)"
        lang10Bit="Couleur 10 bits (HDR/Couleur profonde)"
        lang12Bit="Couleur 12 bits (Pro/Couleur ultra profonde)"
        langRefreshRate="Choisir le mode de taux de rafraîchissement"
        lang60Hz="Standard (60Hz)"
        langHighRefresh="Gaming/Taux élevé (144Hz+)"
        langProMotion="ProMotion / Taux Variable (VRR)"
        langRetinaEnabled="Interface Retina : ACTIVÉE"
        langNaming="Voulez-vous renommer cet écran ? (Laissez vide pour le nom par défaut) :"
        langReboot="Voulez-vous redémarrer maintenant ? (Assurez-vous de sauvegarder tout votre travail d'abord !) [y/n]"
        ;;
    zh)
        langDisplay="显示器"
        langMonitors="显示器"
        langIndex="序号"
        langVendorID="供应商ID"
        langProductID="产品ID"
        langMonitorName="显示器名称"
        langChooseDis="选择显示器"
        langInputChoice="输入你的选择"
        langEnterError="输入错误，正在退出..."
        langBackingUp="正在备份(怎么还原请看说明)..."
        langEnabled="开启成功，重启生效"
        langDisabled="关闭成功，重启生效"
        langEnabledLog="首次重启开机logo会变得巨大，之后就不会了"
        langCustomRes="输入想要开启的 HIDPI 分辨率，用空格隔开，就像这样：1680x945 1600x900 1440x810"
        langChooseIcon="选择显示器ICON"
        langNotChange="保持原样"
        langEnableHIDPI="(%d) 开启HIDPI"
        langEnableHIDPIEDID="(%d) 开启HIDPI(同时注入EDID)"
        langDisableHIDPI="(%d) 关闭HIDPI"
        langDisableOpt1="(1) 在此显示器上禁用 HIDPI"
        langDisableOpt2="(2) 还原所有设置至 macOS 默认"
        langChooseRes="选择分辨率配置"
        langChooseResOp1="(1) 1920x1080 显示屏"
        langChooseResOp2="(2) 1920x1080 显示屏 (使用 1424x802 分辨率，修复睡眠唤醒后的屏幕缩小问题)"
        langChooseResOp3="(3) 1920x1200 显示屏"
        langChooseResOp4="(4) 2560x1440 显示屏"
        langChooseResOp5="(5) 3000x2000 显示屏"
        langChooseResOp6="(6) 3440x1440 显示屏"
        langChooseResOpCustom="(7) 手动输入分辨率"
        langNoMonitFound="没有找到监视器。 退出..."
        langMonitVIDPID="您的显示器 供应商ID:产品ID:"
        langWarning="警告：分辨率超过原生分辨率可能会影响稳定性。"
        langColorDepth="选择颜色深度"
        langAuto="自动 (让 macOS 决定)"
        lang8Bit="8位颜色 (标准)"
        lang10Bit="10位颜色 (HDR/深色)"
        lang12Bit="12位颜色 (专业/极深色)"
        langRefreshRate="选择刷新率模式"
        lang60Hz="标准 (60Hz)"
        langHighRefresh="游戏/高刷新率 (144Hz+)"
        langProMotion="ProMotion / 可变刷新率 (VRR)"
        langRetinaEnabled="Retina 界面: 已开启"
        langNaming="您想重命名此显示器吗？ (留空以使用默认值):"
        langReboot="您想现在重启吗？ (请务必先保存您的所有工作！) [y/n]"
        ;;
    ja)
        langDisplay="ディスプレイ"
        langMonitors="モニタ"
        langIndex="インデックス"
        langVendorID="ベンダーID"
        langProductID="プロダクトID"
        langMonitorName="モニタ名"
        langChooseDis="ディスプレイを選択"
        langInputChoice="選択してください"
        langEnterError="無効な入力です。終了します。"
        langBackingUp="バックアップ中..."
        langEnabled="有効になりました。再起動してください。"
        langDisabled="無効にしました。再起動後に反映されます。"
        langEnabledLog="初回の再起動時はAppleロゴが大きく表示されますが、次回以降は正常に戻ります。"
        langCustomRes="HiDPI解像度をスペース区切りで入力してください (例: 1680x945 1600x900)"
        langChooseIcon="ディスプレイアイコン"
        langNotChange="変更しない"
        langEnableHIDPI="(%d) HIDPIを有効にする"
        langEnableHIDPIEDID="(%d) HIDPIを有効にする (EDID注入)"
        langDisableHIDPI="(%d) HIDPIを無効にする"
        langDisableOpt1="(1) このモニタのHIDPIを無効にする"
        langDisableOpt2="(2) すべての設定をmacOS標準に戻す"
        langChooseRes="解像度設定"
        langChooseResOp1="(1) 1920x1080 ディスプレイ"
        langChooseResOp2="(2) 1920x1080 ディスプレイ (1424x802を使用、スリープ復帰後の縮小を修正)"
        langChooseResOp3="(3) 1920x1200 ディスプレイ"
        langChooseResOp4="(4) 2560x1440 ディスプレイ"
        langChooseResOp5="(5) 3000x2000 ディスプレイ"
        langChooseResOp6="(6) 3440x1440 ディスプレイ"
        langChooseResOpCustom="(7) 解像度を手動入力"
        langNoMonitFound="モニタが見つかりませんでした。終了します..."
        langMonitVIDPID="モニタの VID:PID:"
        langWarning="警告：ネイティブ解像度を超える設定は、システムの安定性に影響する可能性があります。"
        langColorDepth="色深度の選択"
        langAuto="自動 (macOSに任せる)"
        lang8Bit="8ビットカラー (標準)"
        lang10Bit="10ビットカラー (HDR/ディープカラー)"
        lang12Bit="12ビットカラー (プロ/ウルトラディープカラー)"
        langRefreshRate="リフレッシュレートモードの選択"
        lang60Hz="標準 (60Hz)"
        langHighRefresh="ゲーミング/高リフレッシュレート (144Hz+)"
        langProMotion="ProMotion / 可変リフレッシュレート (VRR)"
        langRetinaEnabled="Retina UI: 有効"
        langNaming="このモニタの名前を変更しますか？ (空欄でデフォルト設定):"
        langReboot="今すぐ再起動しますか？ (作業内容をすべて保存したことを確認してください！) [y/n]"
        ;;
esac

is_applesilicon=$([[ "$(uname -m)" == "arm64" ]] && echo true || echo false)


function get_edid() {
    local index=0
    local selection=0

    show_banner
    gDisplayInf=($(ioreg -lw0 | grep -i "IODisplayEDID" | sed -e "/[^<]*</s///" -e "s/\>//"))

    if [[ "${#gDisplayInf[@]}" -ge 2 ]]; then
        echo -e "\n                      ${BOLD}${CYAN}💎 ${langMonitors} 💎${NC}                      "
        echo -e "${BLUE}  ╔═══════╦════════════╦════════════╦═════════════════════════════╗${NC}"
        echo -e "  ║ ${BOLD}${YELLOW}${langIndex}${NC} ║ ${BOLD}${YELLOW}${langVendorID}${NC}   ║ ${BOLD}${YELLOW}${langProductID}${NC}  ║ ${BOLD}${YELLOW}${langMonitorName}${NC} ║"
        echo -e "${BLUE}  ╠═══════╬════════════╬════════════╬═════════════════════════════╣${NC}"

        for display in "${gDisplayInf[@]}"; do
            let index++
            MonitorName=("$(echo ${display:190:24} | xxd -p -r)")
            VendorID=${display:16:4}
            ProductID=${display:22:2}${display:20:2}

            if [[ ${VendorID} == 0610 ]]; then MonitorName="Apple Display"; fi
            if [[ ${VendorID} == 1e6d ]]; then MonitorName="LG Display"; fi

            printf "  ║   ${GREEN}%d${NC}   ║    ${CYAN}${VendorID}${NC}    ║    ${CYAN}${ProductID}${NC}    ║  ${PURPLE}%-25s${NC} ║\n" ${index} "${MonitorName}"
        done

        echo -e "${BLUE}  ╚═══════╩════════════╩════════════╩═════════════════════════════╝${NC}"
        echo -e "${YELLOW}  👉 ${langChooseDis}${NC}"
        read -p "  ==> " selection
        case $selection in
        [[:digit:]]*)
            if ((selection < 1 || selection > index)); then echo -e "  ${RED}❌ ${langEnterError}${NC}"; exit 1; fi
            let selection-=1
            gMonitor=${gDisplayInf[$selection]}
            ;;
        *) echo -e "  ${RED}❌ ${langEnterError}${NC}"; exit 1; ;;
        esac
    else
        gMonitor=${gDisplayInf}
    fi

    EDID=${gMonitor}
    VendorID=$((0x${gMonitor:16:4}))
    ProductID=$((0x${gMonitor:22:2}${gMonitor:20:2}))
    Vid=$(printf '%x\n' ${VendorID})
    Pid=$(printf '%x\n' ${ProductID})
    show_banner
}

function get_vidpid_applesilicon() {
    local index=0
    local prodnamesindex=0
    local selection=0

    show_banner
    local vends=($(ioreg -l | grep "DisplayAttributes" | sed -n 's/.*"LegacyManufacturerID"=\([0-9]*\).*/\1/p'))
    local prods=($(ioreg -l | grep "DisplayAttributes" | sed -n 's/.*"ProductID"=\([0-9]*\).*/\1/p'))
    
    set -o noglob
    IFS=$'\n' prodnames=($(ioreg -l | grep "DisplayAttributes" | sed -n 's/.*"ProductName"="\([^"]*\)".*/\1/p'))
    set +o noglob

    if [[ "${#prods[@]}" -ge 2 ]]; then
        echo -e "\n                      ${BOLD}${CYAN}💎 ${langMonitors} 💎${NC}                      "
        echo -e "${BLUE}  ╔═══════╦════════════╦════════════╦═════════════════════════════╗${NC}"
        echo -e "  ║ ${BOLD}${YELLOW}${langIndex}${NC} ║ ${BOLD}${YELLOW}${langVendorID}${NC}   ║ ${BOLD}${YELLOW}${langProductID}${NC}  ║ ${BOLD}${YELLOW}${langMonitorName}${NC} ║"
        echo -e "${BLUE}  ╠═══════╬════════════╬════════════╬═════════════════════════════╣${NC}"

        for prod in "${prods[@]}"; do
            MonitorName=${prodnames[$prodnamesindex]}
            VendorID=$(printf "%04x" ${vends[$index]})
            ProductID=$(printf "%04x" ${prods[$index]})
            let index++; let prodnamesindex++

            if [[ ${VendorID} == 0610 ]]; then MonitorName="Apple Display"; let prodnamesindex--; fi
            if [[ ${VendorID} == 1e6d ]]; then MonitorName="LG Display"; fi

            printf "  ║   ${GREEN}%-3d${NC} ║    ${CYAN}${VendorID}${NC}    ║    ${CYAN}%-8s${NC}║  ${PURPLE}%-25s${NC} ║\n" ${index} ${ProductID} "${MonitorName}"
        done

        echo -e "${BLUE}  ╚═══════╩════════════╩════════════╩═════════════════════════════╝${NC}"
        echo -e "${YELLOW}  👉 ${langChooseDis}${NC}"
        read -p "  ==> " selection
        case $selection in
        [[:digit:]]*)
            if ((selection < 1 || selection > index)); then echo -e "  ${RED}❌ ${langEnterError}${NC}"; exit 1; fi
            let selection-=1; dispid=$selection
            ;;
        *) echo -e "  ${RED}❌ ${langEnterError}${NC}"; exit 1; ;;
        esac
    else
        dispid=0
    fi

    VendorID=${vends[$dispid]}
    ProductID=${prods[$dispid]}
    Vid=$(printf '%x\n' ${VendorID})
    Pid=$(printf '%x\n' ${ProductID})
    show_banner
}

function init() {
    show_banner
    rm -rf ${currentDir}/tmp/
    mkdir -p ${currentDir}/tmp/

    libDisplaysDir="/Library/Displays"
    targetDir="${libDisplaysDir}/Contents/Resources/Overrides"
    sysDisplayDir="/System${targetDir}"
    Overrides="\/Library\/Displays\/Contents\/Resources\/Overrides"
    sysOverrides="\/System${Overrides}"

    if [[ ! -d "${targetDir}" ]]; then sudo mkdir -p "${targetDir}"; fi

    downloadHost="https://raw.githubusercontent.com/xzhih/one-key-hidpi/master"
    if [ -d "${currentDir}/displayIcons" ]; then downloadHost="file://${currentDir}"; fi

    DICON="com\.apple\.cinema-display"
    imacicon=${sysOverrides}"\/DisplayVendorID\-610\/DisplayProductID\-a032\.tiff"
    mbpicon=${sysOverrides}"\/DisplayVendorID\-610\/DisplayProductID\-a030\-e1e1df\.tiff"
    mbicon=${sysOverrides}"\/DisplayVendorID\-610\/DisplayProductID\-a028\-9d9da0\.tiff"
    lgicon=${sysOverrides}"\/DisplayVendorID\-1e6d\/DisplayProductID\-5b11\.tiff"
    proxdricon=${Overrides}"\/DisplayVendorID\-610\/DisplayProductID\-ae2f\_Landscape\.tiff"
    
    if [[ $is_applesilicon == true ]]; then get_vidpid_applesilicon; else get_edid; fi

    # Check and Cleanup 'folder it will generate' (The Display Override Folder)
    target_path="${targetDir}/DisplayVendorID-${Vid}"
    if [[ -d "${target_path}" ]]; then
        echo -e "${YELLOW}🧹 Found existing configuration at ${target_path}.${NC}"
        echo -e "${CYAN}🔄 Cleaning up previous files to ensure a fresh patch...${NC}"
        sudo rm -rf "${target_path}"
    else
        echo -e "${GREEN}✨ No previous configuration found. Continuing...${NC}"
    fi

    # Backup existing overrides folder if not already backed up
    if [[ -d "${targetDir}" && ! -d "${targetDir}.bak" ]]; then
        echo -e "${YELLOW}📦 Creating system backup at ${targetDir}.bak...${NC}"
        sudo cp -r "${targetDir}" "${targetDir}.bak"
    fi

    if [[ -z $VendorID || -z $ProductID || $VendorID == 0 || $ProductID == 0 ]]; then
        echo -e "${RED}❌ $langNoMonitFound${NC}"
        exit 2
    fi

    echo -e "${GREEN}✅ ${langMonitVIDPID}${NC} ${BOLD}${YELLOW}${Vid}:${Pid}${NC}"
    
    # Custom naming
    echo -e "\n${CYAN}✏️  ${langNaming}${NC}"
    read -p "  ==> " custom_name
    if [[ ! -z "$custom_name" ]]; then MonitorName="$custom_name"; fi
    show_banner

    generate_restore_cmd
}

#
function generate_restore_cmd() {

    if [[ $is_applesilicon == true ]]; then
        cat >"$(cd && pwd)/.hidpi-disable" <<-\CCC
#!/bin/bash
function get_vidpid_applesilicon() {
    local index=0
    local prodnamesindex=0
    local selection=0

    # Apple ioreg display class
    local appleDisplClass='AppleCLCD2'

    # XPath as key.val
    local value="/following-sibling::*[1]"
    local get="/text()"

    # XPath keys
    local displattr="/key[.='DisplayAttributes']"
    local prodattr="/key[.='ProductAttributes']"
    local vendid="/key[.='LegacyManufacturerID']"
    local prodid="/key[.='ProductID']"
    local prodname="/key[.='ProductName']"

    # VID/PID/Prodname
    local prodAttrsQuery="/$displattr$value$prodattr$value"
    local vendIDQuery="$prodAttrsQuery$vendid$value$get"
    local prodIDQuery="$prodAttrsQuery$prodid$value$get"
    local prodNameQuery="$prodAttrsQuery$prodname$value$get"

    # Get VIDs, PIDs, Prodnames
    local vends=($(ioreg -arw0 -d1 -c $appleDisplClass | xpath -q -n -e "$vendIDQuery"))
    local prods=($(ioreg -arw0 -d1 -c $appleDisplClass | xpath -q -n -e "$prodIDQuery"))
    set -o noglob
    IFS=$'\n' prodnames=($(ioreg -arw0 -d1 -c $appleDisplClass | xpath -q -n -e "$prodNameQuery"))
    set +o noglob

    if [[ "${#prods[@]}" -ge 2 ]]; then
        echo '              Monitors              '
        echo '------------------------------------'
        echo '  Index  |  VendorID  |  ProductID  '
        echo '------------------------------------'
        # Show monitors.
        for prod in "${prods[@]}"; do
            MonitorName=${prodnames[$prodnamesindex]}
            VendorID=$(printf "%04x" ${vends[$index]})
            ProductID=$(printf "%04x" ${prods[$index]})
            let index++
            let prodnamesindex++
            if [[ ${VendorID} == 0610 ]]; then
                MonitorName="Apple Display"
                let prodnamesindex--
            fi
            printf "    %d    |    ${VendorID}    |     ${ProductID}    |  ${MonitorName}\n" ${index}
        done

        echo "------------------------------------"

        # Let user make a selection.

        read -p "Choose the display:" selection
        case $selection in
        [[:digit:]]*)
            if ((selection < 1 || selection > index)); then
                echo "Enter error, bye"
                exit 1
            fi
            let selection-=1
            dispid=$selection
            ;;

        *)
            echo "Enter error, bye"
            exit 1
            ;;
        esac
    else
        # One monitor detected
        dispid=0
    fi

    VendorID=${vends[$dispid]}
    ProductID=${prods[$dispid]}
    Vid=($(printf '%x\n' ${VendorID}))
    Pid=($(printf '%x\n' ${ProductID}))
}

get_vidpid_applesilicon

CCC
    else
        cat >"$(cd && pwd)/.hidpi-disable" <<-\CCC
#!/bin/sh
function get_edid() {
    local index=0
    local selection=0
    gDisplayInf=($(ioreg -lw0 | grep -i "IODisplayEDID" | sed -e "/[^<]*</s///" -e "s/\>//"))
    if [[ "${#gDisplayInf[@]}" -ge 2 ]]; then
        echo '              Monitors              '
        echo '------------------------------------'
        echo '  Index  |  VendorID  |  ProductID  '
        echo '------------------------------------'
        for display in "${gDisplayInf[@]}"; do
            let index++
            printf "    %d    |    ${display:16:4}    |    ${display:22:2}${display:20:2}\n" $index
        done
        echo '------------------------------------'
        read -p "Choose the display: " selection
        case $selection in
        [[:digit:]]*)
            if ((selection < 1 || selection > index)); then
                echo "Enter error, bye"
                exit 1
            fi
            let selection-=1
            gMonitor=${gDisplayInf[$selection]}
            ;;
        *)
            echo "Enter error, bye"
            exit 1
            ;;
        esac
    else
        gMonitor=${gDisplayInf}
    fi

    EDID=$gMonitor
    VendorID=$((0x${gMonitor:16:4}))
    ProductID=$((0x${gMonitor:22:2}${gMonitor:20:2}))
    Vid=($(printf '%x\n' ${VendorID}))
    Pid=($(printf '%x\n' ${ProductID}))
}

get_edid

CCC
    fi

    cat >>"$(cd && pwd)/.hidpi-disable" <<-\CCC
# Check if monitor was found
if [[ -z $VendorID || -z $ProductID || $VendorID == 0 || $ProductID == 0 ]]; then
    echo "No monitors found. Exiting..."
    exit 2
fi

echo "Your monitor VID/PID: $Vid:$Pid"

rootPath="../.."
restorePath="${rootPath}/Library/Displays/Contents/Resources/Overrides"

echo ""
echo "(1) Disable HIDPI on this monitor"
echo "(2) Reset all settings to macOS default"
echo ""

read -p "Enter your choice [1~2]: " input
case ${input} in
1)
    if [[ -f "${restorePath}/Icons.plist" ]]; then
        ${rootPath}/usr/libexec/plistbuddy -c "Delete :vendors:${Vid}:products:${Pid}" "${restorePath}/Icons.plist"
    fi
    if [[ -d "${restorePath}/DisplayVendorID-${Vid}" ]]; then
        rm -rf "${restorePath}/DisplayVendorID-${Vid}"
    fi
    ;;
2)
    rm -rf "${restorePath}"
    ;;
*)

    echo "Enter error, bye"
    exit 1
    ;;
esac

echo "HIDPI Disabled"
CCC

    chmod +x "$(cd && pwd)/.hidpi-disable"

}

# choose_icon
function choose_icon() {
    sudo rm -rf ${currentDir}/tmp/
    mkdir -p ${currentDir}/tmp/
    mkdir -p ${currentDir}/tmp/DisplayVendorID-${Vid}
    curl -fsSL "${downloadHost}/Icons.plist" -o ${currentDir}/tmp/Icons.plist

    if [[ ! -d "${currentDir}/displayIcons" ]]; then mkdir -p "${currentDir}/displayIcons"; fi

    show_banner
    echo -e "${CYAN}  ╔═════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║${NC}           ${BOLD}${YELLOW}✨ ${langChooseIcon} ✨${NC}           ${CYAN}║${NC}"
    echo -e "${CYAN}  ╠═════════════════════════════════════════════════════╣${NC}"
    echo -e "  ${CYAN}║${NC}  ${BLUE}(1) 🖥️  iMac${NC}                                   ${CYAN}║${NC}"
    echo -e "  ${CYAN}║${NC}  ${BLUE}(2) 💻 MacBook${NC}                                ${CYAN}║${NC}"
    echo -e "  ${CYAN}║${NC}  ${BLUE}(3) 💻 MacBook Pro${NC}                            ${CYAN}║${NC}"
    echo -e "  ${CYAN}║${NC}  ${BLUE}(4) 📺 LG ${langDisplay}${NC}                              ${CYAN}║${NC}"
    echo -e "  ${CYAN}║${NC}  ${BLUE}(5) 💎 Pro Display XDR${NC}                        ${CYAN}║${NC}"
    echo -e "  ${CYAN}║${NC}  ${BLUE}(6) 🚫 ${langNotChange}${NC}                             ${CYAN}║${NC}"
    echo -e "${CYAN}  ╚═════════════════════════════════════════════════════╝${NC}"
    echo ""

    read -p "  ${langInputChoice} [1~6]: " logo
    case ${logo} in
    1)
        Picon=${imacicon}
        RP=("33" "68" "160" "90")
        icon_file="iMac.icns"
        ;;
    2)
        Picon=${mbicon}
        RP=("52" "66" "122" "76")
        icon_file="MacBook.icns"
        ;;
    3)
        Picon=${mbpicon}
        RP=("40" "62" "147" "92")
        icon_file="MacBookPro.icns"
        ;;
    4)
        Picon=${lgicon}
        RP=("11" "47" "202" "114")
        icon_file="LG.icns"
        if [[ ! -f "${currentDir}/displayIcons/${icon_file}" ]]; then
            cp ${sysDisplayDir}/DisplayVendorID-1e6d/DisplayProductID-5b11.icns "${currentDir}/displayIcons/${icon_file}"
        fi
        cp "${currentDir}/displayIcons/${icon_file}" ${currentDir}/tmp/DisplayVendorID-${Vid}/DisplayProductID-${Pid}.icns
        ;;
    5)
        Picon=${proxdricon}
        RP=("5" "45" "216" "121")
        icon_file="ProDisplayXDR.icns"
        if [[ ! -f "${currentDir}/displayIcons/ProDisplayXDR.tiff" ]]; then
            curl -fsSL "${downloadHost}/displayIcons/ProDisplayXDR.tiff" -o "${currentDir}/displayIcons/ProDisplayXDR.tiff"
        fi
        if [[ ! -f ${targetDir}/DisplayVendorID-610/DisplayProductID-ae2f_Landscape.tiff ]]; then
            cp "${currentDir}/displayIcons/ProDisplayXDR.tiff" ${currentDir}/tmp/DisplayVendorID-${Vid}/DisplayProductID-${Pid}.tiff
            Picon=${Overrides}"\/DisplayVendorID\-${Vid}\/DisplayProductID\-${Pid}\.tiff"
        fi
        ;;
    6)
        rm -rf ${currentDir}/tmp/Icons.plist
        ;;
    *)
        echo -e "${RED}${langEnterError}${NC}"
        exit 1
        ;;
    esac

    # Download if not present locally
    if [[ ! -z "$icon_file" && "$logo" != "4" && "$logo" != "6" ]]; then
        if [[ ! -f "${currentDir}/displayIcons/${icon_file}" ]]; then
            echo -e "${YELLOW}Downloading icon to project folder...${NC}"
            curl -fsSL "${downloadHost}/displayIcons/${icon_file}" -o "${currentDir}/displayIcons/${icon_file}"
        fi
        cp "${currentDir}/displayIcons/${icon_file}" ${currentDir}/tmp/DisplayVendorID-${Vid}/DisplayProductID-${Pid}.icns
    fi

    if [[ ${Picon} ]]; then
        DICON=${Overrides}"\/DisplayVendorID\-${Vid}\/DisplayProductID\-${Pid}\.icns"
        /usr/bin/sed -i "" "s/VID/${Vid}/g" ${currentDir}/tmp/Icons.plist
        /usr/bin/sed -i "" "s/PID/${Pid}/g" ${currentDir}/tmp/Icons.plist
        /usr/bin/sed -i "" "s/RPX/${RP[0]}/g" ${currentDir}/tmp/Icons.plist
        /usr/bin/sed -i "" "s/RPY/${RP[1]}/g" ${currentDir}/tmp/Icons.plist
        /usr/bin/sed -i "" "s/RPW/${RP[2]}/g" ${currentDir}/tmp/Icons.plist
        /usr/bin/sed -i "" "s/RPH/${RP[3]}/g" ${currentDir}/tmp/Icons.plist
        /usr/bin/sed -i "" "s/PICON/${Picon}/g" ${currentDir}/tmp/Icons.plist
        /usr/bin/sed -i "" "s/DICON/${DICON}/g" ${currentDir}/tmp/Icons.plist
    fi
    show_banner
}

function main() {
    sudo mkdir -p ${currentDir}/tmp/DisplayVendorID-${Vid}
    dpiFile=${currentDir}/tmp/DisplayVendorID-${Vid}/DisplayProductID-${Pid}
    sudo chmod -R 777 ${currentDir}/tmp/

    # Detect Native Resolution and Refresh Rate
    native_info=$(system_profiler SPDisplaysDataType | grep -E "Resolution|UI Looks like")
    native_res=$(echo "$native_info" | grep "Resolution" | head -n 1 | awk '{print $2"x"$4}')
    refresh_rate=$(echo "$native_info" | grep "@" | head -n 1 | awk -F'@ ' '{print $2}' | awk '{print $1}')

    cat >"${dpiFile}" <<-\CCC
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>DisplayProductID</key>
            <integer>PID</integer>
        <key>DisplayVendorID</key>
            <integer>VID</integer>
        <key>DisplayProductName</key>
            <string>MONITOR_NAME</string>
        <key>IODisplayEDID</key>
            <data>EDid</data>
        <key>scale-resolutions</key>
            <array>
CCC

    show_banner
    echo -e "${CYAN}  ╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║${NC}                ${BOLD}${YELLOW}⚙️  ${langChooseRes} ⚙️${NC}                ${CYAN}║${NC}"
    echo -e "${CYAN}  ╠══════════════════════════════════════════════════════════════════╣${NC}"
    
    if [[ ! -z "$native_res" ]]; then
        echo -e "  ${CYAN}║${NC}  ${GREEN}🔍 Detected Native:${NC} ${BOLD}${native_res}${NC} @ ${BOLD}${refresh_rate}${NC}             ${CYAN}║${NC}"
        echo -e "${CYAN}  ╠══════════════════════════════════════════════════════════════════╣${NC}"
    fi

    # Highlight recommendation
    case "$native_res" in
        1920x1080) echo -e "  ${CYAN}║${NC}  ${BOLD}${PURPLE}⭐ (1) 1080p Monitor [RECOMMENDED]${NC}                     ${CYAN}║${NC}" ;;
        *) echo -e "  ${CYAN}║${NC}  ${BLUE}(1) 1080p Monitor${NC}                                      ${CYAN}║${NC}" ;;
    esac
    echo -e "  ${CYAN}║${NC}  ${BLUE}(2) 1080p Monitor (Alt - Sleep Fix)${NC}                      ${CYAN}║${NC}"
    case "$native_res" in
        1920x1200) echo -e "  ${CYAN}║${NC}  ${BOLD}${PURPLE}⭐ (3) 1200p Monitor [RECOMMENDED]${NC}                     ${CYAN}║${NC}" ;;
        *) echo -e "  ${CYAN}║${NC}  ${BLUE}(3) 1200p Monitor${NC}                                      ${CYAN}║${NC}" ;;
    esac
    case "$native_res" in
        2560x1440) echo -e "  ${CYAN}║${NC}  ${BOLD}${PURPLE}⭐ (4) 2K / 1440p Monitor [RECOMMENDED]${NC}                ${CYAN}║${NC}" ;;
        *) echo -e "  ${CYAN}║${NC}  ${BLUE}(4) 2K / 1440p Monitor${NC}                                 ${CYAN}║${NC}" ;;
    esac
    case "$native_res" in
        3000x2000) echo -e "  ${CYAN}║${NC}  ${BOLD}${PURPLE}⭐ (5) 3K / 2000p Monitor [RECOMMENDED]${NC}                ${CYAN}║${NC}" ;;
        *) echo -e "  ${CYAN}║${NC}  ${BLUE}(5) 3K / 2000p Monitor${NC}                                 ${CYAN}║${NC}" ;;
    esac
    case "$native_res" in
        3440x1440) echo -e "  ${CYAN}║${NC}  ${BOLD}${PURPLE}⭐ (6) UltraWide Monitor [RECOMMENDED]${NC}                 ${CYAN}║${NC}" ;;
        *) echo -e "  ${CYAN}║${NC}  ${BLUE}(6) UltraWide Monitor${NC}                                ${CYAN}║${NC}" ;;
    esac
    echo -e "  ${CYAN}║${NC}  ${BLUE}(7) ⌨️  Manual Input${NC}                                     ${CYAN}║${NC}"
    echo -e "${CYAN}  ╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    read -p "  ${langInputChoice}: " res
    case ${res} in
    1 | 2)
        # 1080p Monitor
        add_res 1920 1080 1
        add_res 1600 900 1
        add_res 1440 810 1
        add_res 1280 720 1
        add_res 1024 576 1
        ;;
    3)
        # 1200p Monitor
        add_res 1920 1200 1
        add_res 1680 1050 1
        add_res 1440 900 1
        add_res 1280 800 1
        add_res 1024 640 1
        ;;
    4)
        # 2K / 1440p Monitor
        add_res 2560 1440 1
        add_res 2048 1152 1
        add_res 1920 1080 1
        add_res 1600 900 1
        add_res 1280 720 1
        ;;
    5)
        # 3K / 2000p Monitor
        add_res 3000 2000 1
        add_res 2880 1920 1
        add_res 2250 1500 1
        add_res 1920 1280 1
        add_res 1500 1000 1
        ;;
    6)
        # UltraWide 1440p
        add_res 3440 1440 1
        add_res 2580 1080 1
        add_res 1720 720 1
        ;;
    7)
        echo -e "${RED}${langWarning}${NC}"
        custom_res
        ;;
    *)
        echo -e "${RED}${langEnterError}${NC}"
        exit 1
        ;;
    esac
    show_banner

    # Boot Logo Fix Logic - Optimized ppmm values
    # Lower values make the logo smaller. 10.0 is often too large for non-native Retina.
    ppmm="5.0" 
    if [[ "$res" == "1" || "$res" == "2" || "$native_res" == "1920x1080" ]]; then
        ppmm="3.8" # Very close to standard 96 DPI
    fi

    cat >>"${dpiFile}" <<FFF
            </array>
        <key>target-default-ppmm</key>
            <real>${ppmm}</real>
        <key>DisplayIsAppleRetina</key>
            <true/>
FFF

    # Color Depth Configuration
    show_banner
    echo -e "${CYAN}  ╔═════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║${NC}         ${BOLD}${YELLOW}🌈  ${langColorDepth}  🌈${NC}          ${CYAN}║${NC}"
    echo -e "${CYAN}  ╠═════════════════════════════════════════════════════╣${NC}"
    echo -e "  ${CYAN}║${NC}  ${GREEN}(1) ${langAuto}${NC}               ${CYAN}║${NC}"
    echo -e "  ${CYAN}║${NC}  ${BLUE}(2) ${lang8Bit}${NC}                         ${CYAN}║${NC}"
    echo -e "  ${CYAN}║${NC}  ${BLUE}(3) ${lang10Bit}${NC}                    ${CYAN}║${NC}"
    echo -e "  ${CYAN}║${NC}  ${BLUE}(4) ${lang12Bit}${NC}              ${CYAN}║${NC}"
    echo -e "${CYAN}  ╚═════════════════════════════════════════════════════╝${NC}"
    echo ""
    read -p "  ${langInputChoice} [1~4]: " bit_depth
    
    case $bit_depth in
        1)
            # Automatic: Include both 8 and 10 bit, macOS will negotiate
            cat >>"${dpiFile}" <<FFF
        <key>DisplayPixelConfigurations</key>
            <array>
                <data>AAAAAw==</data>
                <data>AAAABA==</data>
            </array>
FFF
            ;;
        2)
            # Forced 8-bit
            cat >>"${dpiFile}" <<FFF
        <key>DisplayPixelConfigurations</key>
            <array>
                <data>AAAAAw==</data>
            </array>
FFF
            ;;
        3)
            # Forced 10-bit
            cat >>"${dpiFile}" <<FFF
        <key>DisplayPixelConfigurations</key>
            <array>
                <data>AAAABA==</data>
            </array>
FFF
            ;;
        4)
            # Forced 12-bit
            cat >>"${dpiFile}" <<FFF
        <key>DisplayPixelConfigurations</key>
            <array>
                <data>AAAACg==</data>
            </array>
FFF
            ;;
        *)
            # Default to Auto
            cat >>"${dpiFile}" <<FFF
        <key>DisplayPixelConfigurations</key>
            <array>
                <data>AAAAAw==</data>
                <data>AAAABA==</data>
            </array>
FFF
            ;;
    esac

    # Refresh Rate Configuration
    show_banner
    echo -e "${CYAN}  ╔═════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║${NC}         ${BOLD}${YELLOW}⚡  ${langRefreshRate}  ⚡${NC}         ${CYAN}║${NC}"
    echo -e "${CYAN}  ╠═════════════════════════════════════════════════════╣${NC}"
    echo -e "  ${CYAN}║${NC}  ${BLUE}(1) ${lang60Hz}${NC}                          ${CYAN}║${NC}"
    echo -e "  ${CYAN}║${NC}  ${BLUE}(2) ${langHighRefresh}${NC}            ${CYAN}║${NC}"
    echo -e "  ${CYAN}║${NC}  ${BLUE}(3) ${langProMotion}${NC}        ${CYAN}║${NC}"
    echo -e "${CYAN}  ╚═════════════════════════════════════════════════════╝${NC}"
    echo ""
    read -p "  ${langInputChoice} [1~3]: " refresh_choice
    
    case $refresh_choice in
        2)
            # Gaming/High Refresh
            cat >>"${dpiFile}" <<FFF
        <key>MaxRefreshRate</key>
            <integer>240</integer>
FFF
            ;;
        3)
            # VRR/ProMotion
            cat >>"${dpiFile}" <<FFF
        <key>MaxRefreshRate</key>
            <integer>240</integer>
        <key>VariableRefreshRate</key>
            <true/>
FFF
            ;;
        *)
            # Standard 60Hz
            cat >>"${dpiFile}" <<FFF
        <key>MaxRefreshRate</key>
            <integer>60</integer>
FFF
            ;;
    esac

    echo -e "    </dict>\n</plist>" >> "${dpiFile}"

    /usr/bin/sed -i "" "s/VID/$VendorID/g" ${dpiFile}
    /usr/bin/sed -i "" "s/PID/$ProductID/g" ${dpiFile}
    
    # Safer replacement for Monitor Name to avoid sed delimiter issues
    python3 -c "import sys; content = open('${dpiFile}').read(); open('${dpiFile}', 'w').write(content.replace('MONITOR_NAME', sys.argv[1]))" "$MonitorName"

    # Color Profile (Point 8)
    echo -e "\n${CYAN}  ╔═════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║${NC}        ${BOLD}${YELLOW}🎨  Color Profile & Calibration  🎨${NC}         ${CYAN}║${NC}"
    echo -e "${CYAN}  ╠═════════════════════════════════════════════════════╣${NC}"
    echo -e "  ${CYAN}║${NC}  ${BLUE}(1) Default macOS profile (Recommended)${NC}          ${CYAN}║${NC}"
    echo -e "  ${CYAN}║${NC}  ${BLUE}(2) Manual profile association (Advanced)${NC}        ${CYAN}║${NC}"
    echo -e "  ${CYAN}║${NC}  ${BLUE}(3) Ignore color modifications${NC}                   ${CYAN}║${NC}"
    echo -e "${CYAN}  ╚═════════════════════════════════════════════════════╝${NC}"
    read -p "  ${langInputChoice} [1~3]: " color_choice
    case $color_choice in
        2) echo -e "  ${YELLOW}💡 Please associate the profile manually in System Settings -> Displays after reboot.${NC}" ;;
        *) ;;
    esac
    show_banner
}

# end
function end() {
    sudo chown -R root:wheel ${currentDir}/tmp/
    sudo chmod -R 0755 ${currentDir}/tmp/
    sudo chmod 0644 ${currentDir}/tmp/DisplayVendorID-${Vid}/*
    sudo cp -r ${currentDir}/tmp/* ${targetDir}/
    sudo rm -rf ${currentDir}/tmp
    sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool YES
    
    show_banner
    echo -e "  ${GREEN}${BOLD}    🚀 SUCCESS / SUCESSO / ÉXITO${NC}"
    echo -e "  ${BLUE}╔══════════════════════════════════════════════╗${NC}"
    printf "  ${CYAN}║${NC} ${BOLD}Monitor:${NC} ${PURPLE}%-33s${NC} ${CYAN}║${NC}\n" "$(echo "$MonitorName" | cut -c 1-33)"
    printf "  ${CYAN}║${NC} ${BOLD}ID:${NC}      ${YELLOW}%-33s${NC} ${CYAN}║${NC}\n" "${Vid}:${Pid}"
    echo -e "  ${CYAN}║${NC} ${BOLD}HiDPI:${NC}   ${GREEN}ENABLED${NC}                          ${CYAN}║${NC}"
    echo -e "  ${CYAN}║${NC} ${BOLD}Retina:${NC}  ${GREEN}ACTIVE${NC}                           ${CYAN}║${NC}"
    echo -e "  ${CYAN}║${NC} ${BOLD}Logo Fix:${NC} ${GREEN}APPLIED${NC}                          ${CYAN}║${NC}"
    echo -e "  ${BLUE}╚══════════════════════════════════════════════╝${NC}"
    echo -e "\n  ${GREEN}${BOLD}✨ ${langEnabled}${NC}"
    echo -e "  ${YELLOW}ℹ️  ${langEnabledLog}${NC}"
    echo -e "  ${BLUE}════════════════════════════════════════════════${NC}"
    
    echo -e "\n  ${BOLD}${YELLOW}🔄 ${langReboot}${NC}"
    read -p "  ==> " reboot_choice
    if [[ "$reboot_choice" == "y" || "$reboot_choice" == "Y" ]]; then
        sudo reboot
    fi
}

# custom resolution
function custom_res() {
    echo -e "\n  ${BOLD}${CYAN}⌨️  ${langCustomRes}${NC}"
    read -p "  ==> " input_resolutions
    
    # Split the input into an array
    IFS=' ' read -r -a resolution_array <<< "$input_resolutions"
    
    for res in "${resolution_array[@]}"; do
        w=$(echo ${res} | cut -d x -f 1)
        h=$(echo ${res} | cut -d x -f 2)
        add_res $w $h 1
    done
    show_banner
}

# robust resolution adder
function add_res() {
    local w=$1
    local h=$2
    local flag=$3
    
    # Retina target (doubled)
    local rw=$(($w * 2))
    local rh=$(($h * 2))
    
    # Generate 12-byte hex string: [Width(4)][Height(4)][Flag(4)]
    local hex=$(printf '%08x%08x%08x' $rw $rh $flag)
    local b64=$(echo "$hex" | xxd -r -p | base64)
    
    # Check if already exists in file to avoid duplicates
    if ! grep -q "$b64" "${dpiFile}"; then
        echo "                <data>$b64</data>" >> "${dpiFile}"
    fi
}

# enable
function enable_hidpi() {
    choose_icon
    main
    sed -i "" "/.*IODisplayEDID/d" ${dpiFile}
    sed -i "" "/.*EDid/d" ${dpiFile}
    end
}

# patch
function enable_hidpi_with_patch() {
    choose_icon
    main

    version=${EDID:38:2}
    basicparams=${EDID:40:2}
    checksum=${EDID:254:2}
    newchecksum=$(printf '%x' $((0x${checksum} + 0x${version} + 0x${basicparams} - 0x04 - 0x90)) | tail -c 2)
    newedid=${EDID:0:38}0490${EDID:42:6}e6${EDID:50:204}${newchecksum}
    EDid=$(printf ${newedid} | xxd -r -p | base64)

    /usr/bin/sed -i "" "s:EDid:${EDid}:g" ${dpiFile}
    end
}

# disable
function disable() {
    show_banner
    echo -e "${CYAN}  ╔═════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║${NC}           ${BOLD}${RED}🛑 ${langDisableHIDPI} 🛑${NC}            ${CYAN}║${NC}"
    echo -e "${CYAN}  ╠═════════════════════════════════════════════════════╣${NC}"
    echo -e "  ${CYAN}║${NC}  ${BLUE}${langDisableOpt1}${NC}                  ${CYAN}║${NC}"
    echo -e "  ${CYAN}║${NC}  ${BLUE}${langDisableOpt2}${NC}   ${CYAN}║${NC}"
    echo -e "${CYAN}  ╚═════════════════════════════════════════════════════╝${NC}"
    echo ""

    read -p "  ${langInputChoice} [1~2]: " input
    show_banner
    case ${input} in
    1)
        if [[ -f "${targetDir}/Icons.plist" ]]; then
            sudo /usr/libexec/plistbuddy -c "Delete :vendors:${Vid}:products:${Pid}" "${targetDir}/Icons.plist"
        fi
        if [[ -d "${targetDir}/DisplayVendorID-${Vid}" ]]; then
            sudo rm -rf "${targetDir}/DisplayVendorID-${Vid}"
        fi
        ;;
    2)
        sudo rm -rf "${targetDir}"
        ;;
    *)
        echo -e "  ${RED}❌ ${langEnterError}${NC}"
        exit 1
        ;;
    esac

    echo -e "\n  ${GREEN}${BOLD}✅ ${langDisabled}${NC}"
}

#
function start() {
    init
    show_banner
    echo -e "\n${CYAN}  ╔═════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║${NC}           ${BOLD}${YELLOW}🏠  MAIN MENU / MENU PRINCIPAL${NC}          ${CYAN}║${NC}"
    echo -e "${CYAN}  ╠═════════════════════════════════════════════════════╣${NC}"
    let opt++; printf "  ${CYAN}║${NC}  ${BLUE}${langEnableHIDPI}${NC}%-35s ${CYAN}║${NC}\n" ""
    if [[ $is_applesilicon == false ]]; then
        let opt++; printf "  ${CYAN}║${NC}  ${BLUE}${langEnableHIDPIEDID}${NC}%-24s ${CYAN}║${NC}\n" ""
    fi
    let opt++; printf "  ${CYAN}║${NC}  ${BLUE}${langDisableHIDPI}${NC}%-34s ${CYAN}║${NC}\n" ""
    echo -e "${CYAN}  ╚═════════════════════════════════════════════════════╝${NC}"
    echo ""

    read -p "  ${langInputChoice} [1~$opt]: " input
    show_banner
    if [[ $is_applesilicon == true ]]; then
        case ${input} in
        1) enable_hidpi ;;
        2) disable ;;
        *) echo -e "  ${RED}❌ ${langEnterError}${NC}"; exit 1 ;;
        esac
    else
        case ${input} in
        1) enable_hidpi ;;
        2) enable_hidpi_with_patch ;;
        3) disable ;;
        *) echo -e "  ${RED}❌ ${langEnterError}${NC}"; exit 1 ;;
        esac
    fi
    show_banner
}

start
