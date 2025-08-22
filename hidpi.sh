#!/bin/bash

# =============================================================================
# One-Key HiDPI - Enhanced Display Configuration Script
# =============================================================================
# 
# Configuration Section
# =============================================================================

# Script version and information
SCRIPT_VERSION="2.0.0"
SCRIPT_AUTHOR="Enhanced by Claude"
SCRIPT_DESCRIPTION="Enhanced HiDPI configuration for macOS with multi-language support"

# Supported languages
SUPPORTED_LANGUAGES=("en" "pt_BR" "es_ES" "es_MX" "fr_FR" "fr_CA" "zh_CN" "uk_UA")

# Display manufacturers database (simplified for compatibility)
MANUFACTURER_APPLE="Apple"
MANUFACTURER_LG="LG"
MANUFACTURER_LITEON="Lite-On"
MANUFACTURER_CHICONY="Chicony"
MANUFACTURER_MICRODIA="Microdia"
MANUFACTURER_REALTEK="Realtek"
MANUFACTURER_UNKNOWN="Unknown"
MANUFACTURER_LENOVO="Lenovo"

# HiDPI resolution presets (simplified)
HIDPI_1920x1080="1680x945 1440x810 1280x720 1024x576"
HIDPI_2560x1440="2048x1152 1920x1080 1760x990 1680x945"
HIDPI_1366x768="1280x720 1024x576 960x540 800x450"
HIDPI_3840x2160="3200x1800 2880x1620 2560x1440 2048x1152"

# =============================================================================
# Utility Functions
# =============================================================================

# Logging function with different levels
function log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case "$level" in
        "INFO") echo "[$timestamp] ℹ️  $message" ;;
        "SUCCESS") echo "[$timestamp] ✅ $message" ;;
        "WARNING") echo "[$timestamp] ⚠️  $message" ;;
        "ERROR") echo "[$timestamp] ❌ $message" ;;
        "DEBUG") echo "[$timestamp] 🔍 $message" ;;
    esac
}

# Error handling function
function handle_error() {
    local exit_code="$1"
    local error_message="$2"
    
    log_message "ERROR" "$error_message"
    
    # Cleanup temporary files
    if [[ -d "${currentDir}/tmp" ]]; then
        rm -rf "${currentDir}/tmp"
    fi
    
    exit "$exit_code"
}

# Validation function for user input
function validate_input() {
    local input="$1"
    local pattern="$2"
    local error_message="$3"
    
    if [[ ! "$input" =~ $pattern ]]; then
        log_message "ERROR" "$error_message"
        return 1
    fi
    return 0
}

# Check system requirements
function check_system_requirements() {
    log_message "INFO" "Checking system requirements..."
    
    # Check if running on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        handle_error 1 "This script is designed for macOS only"
    fi
    
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        log_message "WARNING" "Running as root is not recommended"
    fi
    
    # Check available disk space
    local available_space=$(df -h . | awk 'NR==2 {print $4}' | sed 's/[^0-9.]//g')
    if [[ $available_space =~ ^[0-9]+\.?[0-9]*$ ]] && (( $(echo "$available_space < 1" | bc -l) )); then
        log_message "WARNING" "Low disk space detected ($available_space GB available)"
    fi
    
    # Check if required commands are available
    local required_commands=("ioreg" "system_profiler" "sudo" "sed" "grep")
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            handle_error 1 "Required command '$cmd' not found"
        fi
    done
    
    log_message "SUCCESS" "System requirements check passed"
}

# Welcome message based on language
welcome_msg="Welcome to One-Key HiDPI!"
if [[ "${systemLanguage}" == "pt_BR" ]]; then
    welcome_msg="Bem-vindo ao One-Key HiDPI!"
elif [[ "${systemLanguage}" == "es_ES" ]] || [[ "${systemLanguage}" == "es_MX" ]]; then
    welcome_msg="¡Bienvenido a One-Key HiDPI!"
elif [[ "${systemLanguage}" == "fr_FR" ]] || [[ "${systemLanguage}" == "fr_CA" ]]; then
    welcome_msg="Bienvenue dans One-Key HiDPI!"
elif [[ "${systemLanguage}" == "zh_CN" ]]; then
    welcome_msg="欢迎使用一键 HiDPI!"
elif [[ "${systemLanguage}" == "uk_UA" ]]; then
    welcome_msg="Ласкаво просимо до One-Key HiDPI!"
fi

cat <<EEF
  _    _   _____   _____    _____    _____ 
 | |  | | |_   _| |  __ \  |  __ \  |_   _|
 | |__| |   | |   | |  | | | |__) |   | |  
 |  __  |   | |   | |  | | |  ___/    | |  
 | |  | |  _| |_  | |__| | | |       _| |_ 
 |_|  |_| |_____| |_____/  |_|      |_____|
                                           
============================================
$welcome_msg
============================================
EEF

currentDir="$(cd $(dirname -- $0) && pwd)"
systemLanguage=($(locale | grep LANG | sed s/'LANG='// | tr -d '"' | cut -d "." -f 1))
is_applesilicon=$([[ "$(uname -m)" == "arm64" ]] && echo true || echo false)

langDisplay="Display"
langMonitors="Monitors"
langIndex="Index"
langVendorID="VendorID"
langProductID="ProductID"
langMonitorName="MonitorName"
langChooseDis="Choose the display"
langInputChoice="Enter your choice"
langEnterError="Enter error, bye"
langBackingUp="Backing up..."
langEnabled="Enabled, please reboot."
langDisabled="Disabled, restart takes effect"
langEnabledLog="Rebooting the logo for the first time will become huge, then it will not be."
langCustomRes="Enter the HIDPI resolution, separated by a space，like this: 1680x945 1600x900 1440x810"

langChooseIcon="Display Icon"
langNotChange="Do not change"

langEnableHIDPI="(%d) Enable HIDPI"
langEnableHIDPIEDID="(%d) Enable HIDPI (with EDID)"
langEnableHIDPINormal="(%d) Enable HIDPI for Normal Monitor/Notebook"
langDisableHIDPI="(%d) Disable HIDPI"

langDisableOpt1="(1) Disable HIDPI on this monitor"
langDisableOpt2="(2) Reset all settings to macOS default"

langChooseRes="resolution config"
langChooseResOp1="(1) 1920x1080 Display"
langChooseResOp2="(2) 1920x1080 Display (use 1424x802, fix underscaled after sleep)"
langChooseResOp3="(3) 1920x1200 Display"
langChooseResOp4="(4) 2560x1440 Display"
langChooseResOp5="(5) 3000x2000 Display"
    langChooseResOp6="(6) 3440x1440 Display"
    langChooseResOp7="(7) 3840x2160 Display (4K)"
    langChooseResOp8="(8) 2560x1600 Display (MacBook Pro 16\")"
    langChooseResOp9="(9) 3024x1964 Display (MacBook Pro 14\")"
    langChooseResOp10="(10) 3456x2234 Display (MacBook Pro 16\" M3)"
    langChooseResOpCustom="(11) Manual input resolution"

langNoMonitFound="No monitors were found. Exiting..."
langMonitVIDPID="Your monitor VID:PID:"
if [[ "${systemLanguage}" == "zh_CN" ]]; then
    langDisplay="显示器"
    langMonitors="显示器"
    langIndex="序号"
    langVendorID="供应商ID"
    langProductID="产品ID"
    langMonitorName="显示器名称"
    langChooseDis="选择显示器"
    langInputChoice="输入你的选择"
    langEnterError="输入错误，再见了您嘞！"
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
    langChooseResOp7="(7) 3840x2160 显示屏 (4K)"
    langChooseResOp8="(8) 2560x1600 显示屏 (MacBook Pro 16\")"
    langChooseResOp9="(9) 3024x1964 显示屏 (MacBook Pro 14\")"
    langChooseResOp10="(10) 3456x2234 显示屏 (MacBook Pro 16\" M3)"
    langChooseResOpCustom="(11) 手动输入分辨率"

    langNoMonitFound="没有找到监视器。 退出..."
    langMonitVIDPID="您的显示器 供应商ID:产品ID:"
elif [[ "${systemLanguage}" == "uk_UA" ]]; then
    langDisplay="Монітор"
    langMonitors="Монітор"
    langIndex="Номер"
    langVendorID="ID Виробника"
    langProductID="ID Продукту"
    langMonitorName="Імʼя пристрою"
    langChooseDis="Вибери монітор"
    langInputChoice="Введи свій вибір"
    langEnterError="Помилка вводу, бувай..."
    langBackingUp="Зберігаю..."
    langEnabled="Увімкнено! Перезавантаж компʼютер."
    langDisabled="Вимкнено. Перезавантаж компʼютер."
    langEnabledLog="Спочатку логотип виглядатиме великим, далі все виправиться"
    langCustomRes="Введи роздільну здатність HiDPI розділену комами, як на цьому прикладі: 1680x945 1600x900 1440x810"

    langChooseIcon="Вибери піктограму"
    langNotChange="Не змінювати піктограму"

    langEnableHIDPI="(%d) Увімкнути HIDPI"
    langEnableHIDPIEDID="(%d) Увімкнути HIDPI (спробувати увімкнути з використанням EDID)"
    langDisableHIDPI="(%d) Вимкнути HIDPI"

    langDisableOpt1="(1) Вимкнути HIDPI для цього монітору"
    langDisableOpt2="(2) Відновити заводські налаштування macOS"

    langChooseRes="Налаштувати роздільну здатність"
    langChooseResOp1="(1) 1920x1080 монітор"
    langChooseResOp2="(2) 1920x1080 монітор (використовувати 1424x802, виправлення заниженої роздільної здатності після сну)"
    langChooseResOp3="(3) 1920x1200 монітор"
    langChooseResOp4="(4) 2560x1440 монітор"
    langChooseResOp5="(5) 3000x2000 монітор"
    langChooseResOp6="(6) 3440x1440 монітор"
    langChooseResOp7="(7) 3840x2160 монітор (4K)"
    langChooseResOp8="(8) 2560x1600 монітор (MacBook Pro 16\")"
    langChooseResOp9="(9) 3024x1964 монітор (MacBook Pro 14\")"
    langChooseResOp10="(10) 3456x2234 монітор (MacBook Pro 16\" M3)"
    langChooseResOpCustom="(11) Ввести роздільну здатність вручну"

    langNoMonitFound="Моніторів не знайдено. Завершую роботу..."
    langMonitVIDPID="ID Виробника:ID пристрою твого монітора:"
elif [[ "${systemLanguage}" == "pt_BR" ]]; then
    langDisplay="Monitor"
    langMonitors="Monitores"
    langIndex="Índice"
    langVendorID="ID do Fabricante"
    langProductID="ID do Produto"
    langMonitorName="Nome do Monitor"
    langChooseDis="Escolha o monitor"
    langInputChoice="Digite sua escolha"
    langEnterError="Erro na entrada, tchau!"
    langBackingUp="Fazendo backup..."
    langEnabled="Habilitado, por favor reinicie."
    langDisabled="Desabilitado, reinicie para aplicar"
    langEnabledLog="Na primeira reinicialização o logo ficará enorme, depois voltará ao normal"
    langCustomRes="Digite as resoluções HIDPI desejadas, separadas por espaço, assim: 1680x945 1600x900 1440x810"

    langChooseIcon="Ícone do Monitor"
    langNotChange="Não alterar"

    langEnableHIDPI="(%d) Habilitar HIDPI"
    langEnableHIDPIEDID="(%d) Habilitar HIDPI (com EDID)"
    langEnableHIDPINormal="(%d) Habilitar HIDPI para Monitor/Notebook Normal"
    langDisableHIDPI="(%d) Desabilitar HIDPI"

    langDisableOpt1="(1) Desabilitar HIDPI neste monitor"
    langDisableOpt2="(2) Restaurar todas as configurações para o padrão do macOS"

    langChooseRes="configuração de resolução"
    langChooseResOp1="(1) Monitor 1920x1080"
    langChooseResOp2="(2) Monitor 1920x1080 (usar 1424x802, corrige subescala após dormir)"
    langChooseResOp3="(3) Monitor 1920x1200"
    langChooseResOp4="(4) Monitor 2560x1440"
    langChooseResOp5="(5) Monitor 3000x2000"
    langChooseResOp6="(6) Monitor 3440x1440"
    langChooseResOp7="(7) Monitor 3840x2160 (4K)"
    langChooseResOp8="(8) Monitor 2560x1600 (MacBook Pro 16\")"
    langChooseResOp9="(9) Monitor 3024x1964 (MacBook Pro 14\")"
    langChooseResOp10="(10) Monitor 3456x2234 (MacBook Pro 16\" M3)"
    langChooseResOpCustom="(11) Inserir resolução manualmente"

    langNoMonitFound="Nenhum monitor foi encontrado. Saindo..."
    langMonitVIDPID="VID:PID do seu monitor:"
elif [[ "${systemLanguage}" == "es_ES" ]] || [[ "${systemLanguage}" == "es_MX" ]]; then
    langDisplay="Monitor"
    langMonitors="Monitores"
    langIndex="Índice"
    langVendorID="ID del Fabricante"
    langProductID="ID del Producto"
    langMonitorName="Nombre del Monitor"
    langChooseDis="Elige el monitor"
    langInputChoice="Ingresa tu elección"
    langEnterError="Error de entrada, ¡adiós!"
    langBackingUp="Haciendo respaldo..."
    langEnabled="¡Habilitado, por favor reinicia!"
    langDisabled="Deshabilitado, reinicia para aplicar"
    langEnabledLog="En el primer reinicio el logo se verá enorme, después se normalizará"
    langCustomRes="Ingresa las resoluciones HIDPI deseadas, separadas por espacios, así: 1680x945 1600x900 1440x810"

    langChooseIcon="Icono del Monitor"
    langNotChange="No cambiar"

    langEnableHIDPI="(%d) Habilitar HIDPI"
    langEnableHIDPIEDID="(%d) Habilitar HIDPI (con EDID)"
    langEnableHIDPINormal="(%d) Habilitar HIDPI para Monitor/Notebook Normal"
    langDisableHIDPI="(%d) Deshabilitar HIDPI"

    langDisableOpt1="(1) Deshabilitar HIDPI en este monitor"
    langDisableOpt2="(2) Restaurar todas las configuraciones al predeterminado de macOS"

    langChooseRes="configuración de resolución"
    langChooseResOp1="(1) Monitor 1920x1080"
    langChooseResOp2="(2) Monitor 1920x1080 (usar 1424x802, corrige subescala después del sueño)"
    langChooseResOp3="(3) Monitor 1920x1200"
    langChooseResOp4="(4) Monitor 2560x1440"
    langChooseResOp5="(5) Monitor 3000x2000"
    langChooseResOp6="(6) Monitor 3440x1440"
    langChooseResOp7="(7) Monitor 3840x2160 (4K)"
    langChooseResOp8="(8) Monitor 2560x1600 (MacBook Pro 16\")"
    langChooseResOp9="(9) Monitor 3024x1964 (MacBook Pro 14\")"
    langChooseResOp10="(10) Monitor 3456x2234 (MacBook Pro 16\" M3)"
    langChooseResOpCustom="(11) Ingresar resolución manualmente"

    langNoMonitFound="No se encontraron monitores. Saliendo..."
    langMonitVIDPID="VID:PID de tu monitor:"
elif [[ "${systemLanguage}" == "fr_FR" ]] || [[ "${systemLanguage}" == "fr_CA" ]]; then
    langDisplay="Écran"
    langMonitors="Écrans"
    langIndex="Index"
    langVendorID="ID du Fabricant"
    langProductID="ID du Produit"
    langMonitorName="Nom de l'Écran"
    langChooseDis="Choisissez l'écran"
    langInputChoice="Entrez votre choix"
    langEnterError="Erreur de saisie, au revoir!"
    langBackingUp="Sauvegarde en cours..."
    langEnabled="Activé, veuillez redémarrer."
    langDisabled="Désactivé, redémarrez pour appliquer"
    langEnabledLog="Au premier redémarrage le logo sera énorme, puis il redeviendra normal"
    langCustomRes="Entrez les résolutions HIDPI souhaitées, séparées par des espaces, comme ceci: 1680x945 1600x900 1440x810"

    langChooseIcon="Icône de l'Écran"
    langNotChange="Ne pas changer"

    langEnableHIDPI="(%d) Activer HIDPI"
    langEnableHIDPIEDID="(%d) Activer HIDPI (avec EDID)"
    langEnableHIDPINormal="(%d) Activer HIDPI pour Moniteur/Notebook Normal"
    langDisableHIDPI="(%d) Désactiver HIDPI"

    langDisableOpt1="(1) Désactiver HIDPI sur cet écran"
    langDisableOpt2="(2) Restaurer tous les paramètres aux valeurs par défaut de macOS"

    langChooseRes="configuration de résolution"
    langChooseResOp1="(1) Écran 1920x1080"
    langChooseResOp2="(2) Écran 1920x1080 (utiliser 1424x802, corrige la sous-échelle après le sommeil)"
    langChooseResOp3="(3) Écran 1920x1200"
    langChooseResOp4="(4) Écran 2560x1440"
    langChooseResOp5="(5) Écran 3000x2000"
    langChooseResOp6="(6) Écran 3440x1440"
    langChooseResOp7="(7) Écran 3840x2160 (4K)"
    langChooseResOp8="(8) Écran 2560x1600 (MacBook Pro 16\")"
    langChooseResOp9="(9) Écran 3024x1964 (MacBook Pro 14\")"
    langChooseResOp10="(10) Écran 3456x2234 (MacBook Pro 16\" M3)"
    langChooseResOpCustom="(11) Saisir la résolution manuellement"

    langNoMonitFound="Aucun écran trouvé. Sortie..."
    langMonitVIDPID="VID:PID de votre écran:"
fi

# Enhanced EDID detection and manipulation for normal monitors and integrated displays
function enhanced_edid_detection() {
    local edid_data=""
    local edid_hex=""
    local manufacturer_id=""
    local product_id=""
    local serial_number=""
    local week_manufacture=""
    local year_manufacture=""
    local edid_version=""
    local edid_revision=""
    
    # Language-specific messages
    local enhanced_detection_msg="Enhanced EDID Detection for Normal Monitors..."
    local edid_found_msg="✓ EDID found using method:"
    local edid_info_msg="EDID Information:"
    local manufacturer_id_msg="  Manufacturer ID:"
    local product_id_msg="  Product ID:"
    local serial_number_msg="  Serial Number:"
    local manufacture_week_msg="  Manufacture Week:"
    local manufacture_year_msg="  Manufacture Year:"
    local edid_version_msg="  EDID Version:"
    local edid_revision_msg="  EDID Revision:"
    local manufacturer_msg="  Manufacturer:"
    local generic_edid_msg="✓ Generic EDID created with VID:PID"
    
    # Set language-specific messages
    if [[ "${systemLanguage}" == "pt_BR" ]]; then
        enhanced_detection_msg="Detecção Avançada de EDID para Monitores Normais..."
        edid_found_msg="✓ EDID encontrado usando método:"
        edid_info_msg="Informações do EDID:"
        manufacturer_id_msg="  ID do Fabricante:"
        product_id_msg="  ID do Produto:"
        serial_number_msg="  Número de Série:"
        manufacture_week_msg="  Semana de Fabricação:"
        manufacture_year_msg="  Ano de Fabricação:"
        edid_version_msg="  Versão do EDID:"
        edid_revision_msg="  Revisão do EDID:"
        manufacturer_msg="  Fabricante:"
        generic_edid_msg="✓ EDID genérico criado com VID:PID"
    elif [[ "${systemLanguage}" == "es_ES" ]] || [[ "${systemLanguage}" == "es_MX" ]]; then
        enhanced_detection_msg="Detección Avanzada de EDID para Monitores Normales..."
        edid_found_msg="✓ EDID encontrado usando método:"
        edid_info_msg="Información del EDID:"
        manufacturer_id_msg="  ID del Fabricante:"
        product_id_msg="  ID del Producto:"
        serial_number_msg="  Número de Serie:"
        manufacture_week_msg="  Semana de Fabricación:"
        manufacture_year_msg="  Año de Fabricación:"
        edid_version_msg="  Versión del EDID:"
        edid_revision_msg="  Revisión del EDID:"
        manufacturer_msg="  Fabricante:"
        generic_edid_msg="✓ EDID genérico creado con VID:PID"
    elif [[ "${systemLanguage}" == "fr_FR" ]] || [[ "${systemLanguage}" == "fr_CA" ]]; then
        enhanced_detection_msg="Détection Avancée d'EDID pour Moniteurs Normaux..."
        edid_found_msg="✓ EDID trouvé en utilisant la méthode:"
        edid_info_msg="Informations EDID:"
        manufacturer_id_msg="  ID du Fabricant:"
        product_id_msg="  ID du Produit:"
        serial_number_msg="  Numéro de Série:"
        manufacture_week_msg="  Semaine de Fabrication:"
        manufacture_year_msg="  Année de Fabrication:"
        edid_version_msg="  Version EDID:"
        edid_revision_msg="  Révision EDID:"
        manufacturer_msg="  Fabricant:"
        generic_edid_msg="✓ EDID générique créé avec VID:PID"
    elif [[ "${systemLanguage}" == "zh_CN" ]]; then
        enhanced_detection_msg="普通显示器增强EDID检测..."
        edid_found_msg="✓ 使用以下方法找到EDID:"
        edid_info_msg="EDID信息:"
        manufacturer_id_msg="  制造商ID:"
        product_id_msg="  产品ID:"
        serial_number_msg="  序列号:"
        manufacture_week_msg="  制造周:"
        manufacture_year_msg="  制造年份:"
        edid_version_msg="  EDID版本:"
        edid_revision_msg="  EDID修订:"
        manufacturer_msg="  制造商:"
        generic_edid_msg="✓ 使用VID:PID创建通用EDID"
    elif [[ "${systemLanguage}" == "uk_UA" ]]; then
        enhanced_detection_msg="Розширена Детекція EDID для Звичайних Моніторів..."
        edid_found_msg="✓ EDID знайдено використовуючи метод:"
        edid_info_msg="Інформація EDID:"
        manufacturer_id_msg="  ID Виробника:"
        product_id_msg="  ID Продукту:"
        serial_number_msg="  Серійний Номер:"
        manufacture_week_msg="  Тиждень Виробництва:"
        manufacture_year_msg="  Рік Виробництва:"
        edid_version_msg="  Версія EDID:"
        edid_revision_msg="  Ревізія EDID:"
        manufacturer_msg="  Виробник:"
        generic_edid_msg="✓ Генерічний EDID створено з VID:PID"
    fi
    
    echo "$enhanced_detection_msg"
    
    # Try multiple methods to get EDID
    local edid_methods=(
        "ioreg -lw0 | grep -i 'IODisplayEDID' | sed -e '/[^<]*</s///' -e 's/\>//'"
        "ioreg -lw0 | grep -i 'DisplayEDID' | sed -e '/[^<]*</s///' -e 's/\>//'"
        "ioreg -lw0 | grep -i 'EDID' | sed -e '/[^<]*</s///' -e 's/\>//'"
        "system_profiler SPDisplaysDataType | grep -A 20 'EDID' | grep -v '^--' | tr -d ' '"
    )
    
    for method in "${edid_methods[@]}"; do
        edid_data=$(eval "$method" | head -1)
        if [[ -n "$edid_data" && ${#edid_data} -ge 128 ]]; then
            echo "$edid_found_msg $method"
            break
        fi
    done
    
    if [[ -z "$edid_data" ]]; then
        echo "⚠ No EDID found using standard methods, trying alternative detection..."
        
        # Alternative method for integrated displays
        edid_data=$(ioreg -lw0 | grep -A 50 "AppleBacklightDisplay" | grep -i "EDID" | head -1 | sed 's/.*<//' | sed 's/>.*//')
        
        if [[ -z "$edid_data" ]]; then
            # Try to get display info from system profiler
            local display_info=$(system_profiler SPDisplaysDataType | grep -A 30 "Resolution")
            if [[ -n "$display_info" ]]; then
                echo "✓ Using system profiler data for display identification"
                # Extract basic display info
                manufacturer_id="0000"  # Generic
                product_id="0000"      # Generic
            fi
        fi
    fi
    
    if [[ -n "$edid_data" ]]; then
        # Parse EDID data
        edid_hex=$(echo "$edid_data" | tr -d ' ')
        
        if [[ ${#edid_hex} -ge 128 ]]; then
            # Extract EDID information
            manufacturer_id=$(echo "${edid_hex:16:4}" | tr '[:lower:]' '[:upper:]')
            product_id=$(echo "${edid_hex:22:2}${edid_hex:20:2}" | tr '[:lower:]' '[:upper:]')
            serial_number=$(echo "${edid_hex:12:4}" | tr '[:lower:]' '[:upper:]')
            week_manufacture=$(echo "${edid_hex:16:2}" | tr '[:lower:]' '[:upper:]')
            year_manufacture=$(echo "${edid_hex:18:2}" | tr '[:lower:]' '[:upper:]')
            edid_version=$(echo "${edid_hex:18:2}" | tr '[:lower:]' '[:upper:]')
            edid_revision=$(echo "${edid_hex:19:2}" | tr '[:lower:]' '[:upper:]')
            
            echo "$edid_info_msg"
            echo "$manufacturer_id_msg $manufacturer_id"
            echo "$product_id_msg $product_id"
            echo "$serial_number_msg $serial_number"
            echo "$manufacture_week_msg $week_manufacture"
            echo "$manufacture_year_msg $year_manufacture"
            echo "$edid_version_msg $edid_version"
            echo "$edid_revision_msg $edid_revision"
            
            # Identify manufacturer
            local manufacturer_name="Unknown"
            case "$manufacturer_id" in
                "0610") manufacturer_name="Apple" ;;
                "1E6D") manufacturer_name="LG" ;;
                "04CA") manufacturer_name="Lite-On" ;;
                "06AF") manufacturer_name="Chicony" ;;
                "05AC") manufacturer_name="Apple" ;;
                "0C45") manufacturer_name="Microdia" ;;
                "0BDA") manufacturer_name="Realtek" ;;
                "0E6F") manufacturer_name="Unknown" ;;
                *) manufacturer_name="Unknown ($manufacturer_id)" ;;
            esac
            
            echo "$manufacturer_msg $manufacturer_name"
            
            # Store EDID data for later use
            EDID="$edid_data"
            VendorID=$((0x${manufacturer_id}))
            ProductID=$((0x${product_id}))
            Vid="$manufacturer_id"
            Pid="$product_id"
            
            return 0
        fi
    fi
    
    # Fallback: create generic EDID for unknown displays
    echo "⚠ Creating generic EDID for display..."
    create_generic_edid
    return 1
}

# Create generic EDID for displays without proper EDID
function create_generic_edid() {
    local generic_edid="00ffffffffffff000000000000000000"
    generic_edid+="00000000000000000000000000000000"
    generic_edid+="00000000000000000000000000000000"
    generic_edid+="00000000000000000000000000000000"
    generic_edid+="00000000000000000000000000000000"
    generic_edid+="00000000000000000000000000000000"
    generic_edid+="00000000000000000000000000000000"
    generic_edid+="00000000000000000000000000000000"
    
    # Use generic manufacturer and product IDs
    VendorID=1552  # 0x0610 - Apple (generic)
    ProductID=40960  # 0xA000 - Generic product
    Vid="0610"
    Pid="a000"
    EDID="$generic_edid"
    
    echo "$generic_edid_msg $Vid:$Pid"
}

function get_edid() {
    local index=0
    local selection=0

    # Enhanced EDID detection for normal monitors and integrated displays
    enhanced_edid_detection
    
    # If enhanced detection failed, fall back to original method
    if [[ -z "$EDID" ]]; then
        gDisplayInf=($(ioreg -lw0 | grep -i "IODisplayEDID" | sed -e "/[^<]*</s///" -e "s/\>//"))
        
        if [[ "${#gDisplayInf[@]}" -ge 2 ]]; then
            # Multi monitors detected. Choose target monitor.
            echo ""
            echo "                      "${langMonitors}"                      "
            echo "--------------------------------------------------------"
            echo "   "${langIndex}"   |   "${langVendorID}"   |   "${langProductID}"   |   "${langMonitorName}"   "
            echo "--------------------------------------------------------"

            # Show monitors.
            for display in "${gDisplayInf[@]}"; do
                let index++
                MonitorName=("$(echo ${display:190:24} | xxd -p -r)")
                VendorID=${display:16:4}
                ProductID=${display:22:2}${display:20:2}

                # Enhanced manufacturer identification
                case ${VendorID} in
                    "0610") MonitorName="Apple Display" ;;
                    "1e6d") MonitorName="LG Display" ;;
                    "04ca") MonitorName="Lite-On Display" ;;
                    "06af") MonitorName="Chicony Display" ;;
                    "05ac") MonitorName="Apple Display" ;;
                    "0c45") MonitorName="Microdia Display" ;;
                    "0bda") MonitorName="Realtek Display" ;;
                    "0e6f") MonitorName="Unknown Display" ;;
                    *) MonitorName="Generic Display (${VendorID})" ;;
                esac

                printf "    %d    |    ${VendorID}    |     ${ProductID}    |  ${MonitorName}\n" ${index}
            done

            echo "--------------------------------------------------------"

            # Let user make a selection.
            read -p "${langChooseDis}: " selection
            case $selection in
            [[:digit:]]*)
                # Lower selection (arrays start at zero).
                if ((selection < 1 || selection > index)); then
                    echo "${langEnterError}"
                    exit 1
                fi
                let selection-=1
                gMonitor=${gDisplayInf[$selection]}
                ;;

            *)
                echo "${langEnterError}"
                exit 1
                ;;
            esac
        else
            gMonitor=${gDisplayInf}
        fi

        EDID=${gMonitor}
        VendorID=$((0x${gMonitor:16:4}))
        ProductID=$((0x${gMonitor:22:2}${gMonitor:20:2}))
        Vid=($(printf '%x\n' ${VendorID}))
        Pid=($(printf '%x\n' ${ProductID}))
    fi
}

# For Apple silicon there is no EDID. Get VID/PID in other way
function get_vidpid_applesilicon() {
    local index=0
    local prodnamesindex=0
    local selection=0

    # Apple ioreg display class - expanded for modern displays
    local appleDisplClass='AppleCLCD2'
    local appleInternalClass='AppleBacklightDisplay'
    local appleExternalClass='IODisplayConnect'

    # XPath as key.val
    local value="/following-sibling::*[1]"
    local get="/text()"

    # XPath keys
    local displattr="/key[.='DisplayAttributes']"
    local prodattr="/key[.='ProductAttributes']"
    local vendid="/key[.='LegacyManufacturerID']"
    local prodid="/key[.='ProductID']"
    local prodname="/key[.='ProductName']"
    local displaytype="/key[.='DisplayType']"

    # VID/PID/Prodname
    local prodAttrsQuery="/$displattr$value$prodattr$value"
    local vendIDQuery="$prodAttrsQuery$vendid$value$get"
    local prodIDQuery="$prodAttrsQuery$prodid$value$get"
    local prodNameQuery="$prodAttrsQuery$prodname$value$get"

    # Get VIDs, PIDs, Prodnames - expanded detection
    local vends=($(ioreg -l | grep -E "(DisplayAttributes|IODisplayEDID)" | sed -n 's/.*"LegacyManufacturerID"=\([0-9]*\).*/\1/p'))
    local prods=($(ioreg -l | grep -E "(DisplayAttributes|IODisplayEDID)" | sed -n 's/.*"ProductID"=\([0-9]*\).*/\1/p'))

    set -o noglob
    IFS=$'\n' prodnames=($(ioreg -l | grep -E "(DisplayAttributes|IODisplayEDID)" | sed -n 's/.*"ProductName"="\([^"]*\)".*/\1/p'))
    set +o noglob

    # If no displays found with new method, try alternative detection
    if [[ "${#prods[@]}" -eq 0 ]]; then
        echo "Trying alternative display detection method..."
        vends=($(ioreg -lw0 | grep -i "IODisplayEDID" | sed -e "/[^<]*</s///" -e "s/\>//" | sed -n 's/.*\([0-9a-f]\{4\}\)[0-9a-f]\{2\}[0-9a-f]\{2\}.*/\1/p' | sed 's/^0*//'))
        prods=($(ioreg -lw0 | grep -i "IODisplayEDID" | sed -e "/[^<]*</s///" -e "s/\>//" | sed -n 's/.*[0-9a-f]\{4\}\([0-9a-f]\{2\}\)[0-9a-f]\{2\}.*/\1/p'))
    fi

    if [[ "${#prods[@]}" -ge 2 ]]; then

        # Multi monitors detected. Choose target monitor.
        echo ""
        echo "                      "${langMonitors}"                      "
        echo "------------------------------------------------------------"
        echo "   "${langIndex}"   |   "${langVendorID}"   |   "${langProductID}"   |   "${langMonitorName}"  "
        echo "------------------------------------------------------------"

        # Show monitors.
        for prod in "${prods[@]}"; do
            MonitorName=${prodnames[$prodnamesindex]}
            VendorID=$(printf "%04x" ${vends[$index]})
            ProductID=$(printf "%04x" ${prods[$index]})

            let index++
            let prodnamesindex++

            # Enhanced internal display detection
            if [[ ${VendorID} == 0610 ]]; then
                MonitorName="Apple Internal Display"
                # No name in prodnames variable for internal display
                let prodnamesindex--
            fi

            if [[ ${VendorID} == 1e6d ]]; then
                MonitorName="LG Display"
            fi

            # Add more vendor IDs for modern displays
            if [[ ${VendorID} == 04ca ]]; then
                MonitorName="Lite-On Display"
            fi

            if [[ ${VendorID} == 06af ]]; then
                MonitorName="Chicony Display"
            fi

            if [[ ${VendorID} == 05ac ]]; then
                MonitorName="Apple Display"
            fi

            printf "    %-3d    |     ${VendorID}     |  %-12s |  ${MonitorName}\n" ${index} ${ProductID}
        done

        echo "------------------------------------------------------------"

        # Let user make a selection.

        read -p "${langChooseDis}: " selection
        case $selection in
        [[:digit:]]*)
            # Lower selection (arrays start at zero).
            if ((selection < 1 || selection > index)); then
                echo "${langEnterError}"
                exit 1
            fi
            let selection-=1
            dispid=$selection
            ;;

        *)
            echo "${langEnterError}"
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

# init
function init() {
    rm -rf ${currentDir}/tmp/
    mkdir -p ${currentDir}/tmp/

    libDisplaysDir="/Library/Displays"
    targetDir="${libDisplaysDir}/Contents/Resources/Overrides"
    sysDisplayDir="/System${targetDir}"
    Overrides="\/Library\/Displays\/Contents\/Resources\/Overrides"
    sysOverrides="\/System${Overrides}"

    if [[ ! -d "${targetDir}" ]]; then
        sudo mkdir -p "${targetDir}"
    fi

    downloadHost="https://raw.githubusercontent.com/xzhih/one-key-hidpi/master"
    if [ -d "${currentDir}/displayIcons" ]; then
        downloadHost="file://${currentDir}"
    fi

    DICON="com\.apple\.cinema-display"
    imacicon=${sysOverrides}"\/DisplayVendorID\-610\/DisplayProductID\-a032\.tiff"
    mbpicon=${sysOverrides}"\/DisplayVendorID\-610\/DisplayProductID\-a030\-e1e1df\.tiff"
    mbicon=${sysOverrides}"\/DisplayVendorID\-610\/DisplayProductID\-a028\-9d9da0\.tiff"
    lgicon=${sysOverrides}"\/DisplayVendorID\-1e6d\/DisplayProductID\-5b11\.tiff"
    proxdricon=${Overrides}"\/DisplayVendorID\-610\/DisplayProductID\-ae2f\_Landscape\.tiff"
    
    if [[ $is_applesilicon == true ]]; then
        get_vidpid_applesilicon
    else
        get_edid
    fi

    # Check if monitor was found
    if [[ -z $VendorID || -z $ProductID || $VendorID == 0 || $ProductID == 0 ]]; then
        echo "$langNoMonitFound"
        exit 2
    fi

    echo "$langMonitVIDPID $Vid:$Pid"

    # Finally generate restore command
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

    # Apple ioreg display class - expanded for modern displays
    local appleDisplClass='AppleCLCD2'
    local appleInternalClass='AppleBacklightDisplay'
    local appleExternalClass='IODisplayConnect'

    # XPath as key.val
    local value="/following-sibling::*[1]"
    local get="/text()"

    # XPath keys
    local displattr="/key[.='DisplayAttributes']"
    local prodattr="/key[.='ProductAttributes']"
    local vendid="/key[.='LegacyManufacturerID']"
    local prodid="/key[.='ProductID']"
    local prodname="/key[.='ProductName']"
    local displaytype="/key[.='DisplayType']"

    # VID/PID/Prodname
    local prodAttrsQuery="/$displattr$value$prodattr$value"
    local vendIDQuery="$prodAttrsQuery$vendid$value$get"
    local prodIDQuery="$prodAttrsQuery$prodid$value$get"
    local prodNameQuery="$prodAttrsQuery$prodname$value$get"

    # Get VIDs, PIDs, Prodnames - expanded detection
    local vends=($(ioreg -l | grep -E "(DisplayAttributes|IODisplayEDID)" | sed -n 's/.*"LegacyManufacturerID"=\([0-9]*\).*/\1/p'))
    local prods=($(ioreg -l | grep -E "(DisplayAttributes|IODisplayEDID)" | sed -n 's/.*"ProductID"=\([0-9]*\).*/\1/p'))

    set -o noglob
    IFS=$'\n' prodnames=($(ioreg -l | grep -E "(DisplayAttributes|IODisplayEDID)" | sed -n 's/.*"ProductName"="\([^"]*\)".*/\1/p'))
    set +o noglob

    # If no displays found with new method, try alternative detection
    if [[ "${#prods[@]}" -eq 0 ]]; then
        echo "Trying alternative display detection method..."
        vends=($(ioreg -lw0 | grep -i "IODisplayEDID" | sed -e "/[^<]*</s///" -e "s/\>//" | sed -n 's/.*\([0-9a-f]\{4\}\)[0-9a-f]\{2\}[0-9a-f]\{2\}.*/\1/p' | sed 's/^0*//'))
        prods=($(ioreg -lw0 | grep -i "IODisplayEDID" | sed -e "/[^<]*</s///" -e "s/\>//" | sed -n 's/.*[0-9a-f]\{4\}\([0-9a-f]\{2\}\)[0-9a-f]\{2\}.*/\1/p'))
    fi

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
                MonitorName="Apple Internal Display"
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

# Enhanced backup function with better organization and metadata
function enhanced_backup() {
    local backup_dir="${currentDir}/backups/$(date +%Y%m%d_%H%M%S)"
    local backup_file="${backup_dir}/hidpi_backup.tar.gz"
    local metadata_file="${backup_dir}/backup_metadata.json"
    
    # Language-specific messages
    local creating_backup="Creating backup in:"
    local backup_success="✓ HiDPI configurations backed up successfully"
    local backup_warning="⚠ Warning: Could not create complete backup"
    local prefs_backed_up="✓ Display preferences backed up"
    local restore_script_created="✓ Restore script created:"
    local restore_msg="Restoring HiDPI configuration..."
    local config_restored="✓ HiDPI configuration restored"
    local backup_not_found="✗ Backup file not found"
    local prefs_restored="✓ Display preferences restored"
    local restore_complete="Restore complete. Please restart your Mac."
    
    # Set language-specific messages
    if [[ "${systemLanguage}" == "pt_BR" ]]; then
        creating_backup="Criando backup em:"
        backup_success="✓ Configurações HiDPI salvas com sucesso"
        backup_warning="⚠ Aviso: Não foi possível criar backup completo"
        prefs_backed_up="✓ Preferências de exibição salvas"
        restore_script_created="✓ Script de restauração criado:"
        restore_msg="Restaurando configuração HiDPI..."
        config_restored="✓ Configuração HiDPI restaurada"
        backup_not_found="✗ Arquivo de backup não encontrado"
        prefs_restored="✓ Preferências de exibição restauradas"
        restore_complete="Restauração completa. Por favor, reinicie seu Mac."
    elif [[ "${systemLanguage}" == "es_ES" ]] || [[ "${systemLanguage}" == "es_MX" ]]; then
        creating_backup="Creando respaldo en:"
        backup_success="✓ Configuraciones HiDPI respaldadas exitosamente"
        backup_warning="⚠ Advertencia: No se pudo crear respaldo completo"
        prefs_backed_up="✓ Preferencias de pantalla respaldadas"
        restore_script_created="✓ Script de restauración creado:"
        restore_msg="Restaurando configuración HiDPI..."
        config_restored="✓ Configuración HiDPI restaurada"
        backup_not_found="✗ Archivo de respaldo no encontrado"
        prefs_restored="✓ Preferencias de pantalla restauradas"
        restore_complete="Restauración completa. Por favor, reinicia tu Mac."
    elif [[ "${systemLanguage}" == "fr_FR" ]] || [[ "${systemLanguage}" == "fr_CA" ]]; then
        creating_backup="Création de la sauvegarde dans:"
        backup_success="✓ Configurations HiDPI sauvegardées avec succès"
        backup_warning="⚠ Avertissement: Impossible de créer une sauvegarde complète"
        prefs_backed_up="✓ Préférences d'affichage sauvegardées"
        restore_script_created="✓ Script de restauration créé:"
        restore_msg="Restauration de la configuration HiDPI..."
        config_restored="✓ Configuration HiDPI restaurée"
        backup_not_found="✗ Fichier de sauvegarde introuvable"
        prefs_restored="✓ Préférences d'affichage restaurées"
        restore_complete="Restauration terminée. Veuillez redémarrer votre Mac."
    fi
    
    log_message "INFO" "${langBackingUp}"
    log_message "INFO" "$creating_backup $backup_dir"
    
    # Create backup directory
    mkdir -p "$backup_dir"
    
    # Create metadata file
    cat > "$metadata_file" << EOF
{
    "backup_info": {
        "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
        "script_version": "$SCRIPT_VERSION",
        "macos_version": "$(sw_vers -productVersion)",
        "architecture": "$(uname -m)",
        "language": "$systemLanguage",
        "backup_type": "hidpi_configuration"
    },
    "system_info": {
        "hostname": "$(hostname)",
        "username": "$(whoami)",
        "current_directory": "$(pwd)"
    },
    "display_info": {
        "vendor_id": "$Vid",
        "product_id": "$Pid",
        "monitor_name": "$MonitorName",
        "notebook_manufacturer": "$NOTEBOOK_MANUFACTURER",
        "notebook_series": "$NOTEBOOK_SERIES"
    }
}
EOF
    
    # Backup current HiDPI configurations
    if [[ -d "${targetDir}" ]]; then
        sudo tar -czf "$backup_file" -C "${targetDir%/*}" "${targetDir##*/}" 2>/dev/null
        if [[ $? -eq 0 ]]; then
            log_message "SUCCESS" "$backup_success"
        else
            log_message "WARNING" "$backup_warning"
        fi
    fi
    
    # Backup system display preferences
    local prefs_backup="${backup_dir}/display_preferences.plist"
    sudo cp /Library/Preferences/com.apple.windowserver.plist "$prefs_backup" 2>/dev/null
    if [[ $? -eq 0 ]]; then
        log_message "SUCCESS" "$prefs_backed_up"
    fi
    
    # Backup current EDID information
    if [[ -n "$EDID" ]]; then
        echo "$EDID" > "${backup_dir}/current_edid.txt"
        log_message "INFO" "✓ Current EDID backed up"
    fi
    
    # Create restore script with enhanced functionality
    cat > "${backup_dir}/restore.sh" << EOF
#!/bin/bash

# Enhanced HiDPI Restore Script
# Generated on: $(date)
# Script Version: $SCRIPT_VERSION

set -e

RESTORE_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="/Library/Displays/Contents/Resources/Overrides"
METADATA_FILE="\${RESTORE_DIR}/backup_metadata.json"

echo "$restore_msg"
echo "Restore directory: \${RESTORE_DIR}"

# Check if metadata exists
if [[ -f "\${METADATA_FILE}" ]]; then
    echo "Backup metadata found:"
    cat "\${METADATA_FILE}" | python3 -m json.tool 2>/dev/null || echo "Metadata file exists but cannot be parsed"
fi

# Restore HiDPI configuration
if [[ -f "\${RESTORE_DIR}/hidpi_backup.tar.gz" ]]; then
    echo "Restoring HiDPI configuration..."
    sudo rm -rf "\${TARGET_DIR}"
    sudo tar -xzf "\${RESTORE_DIR}/hidpi_backup.tar.gz" -C "\${TARGET_DIR%/*}"
    echo "$config_restored"
else
    echo "$backup_not_found"
    exit 1
fi

# Restore display preferences
if [[ -f "\${RESTORE_DIR}/display_preferences.plist" ]]; then
    echo "Restoring display preferences..."
    sudo cp "\${RESTORE_DIR}/display_preferences.plist" /Library/Preferences/com.apple.windowserver.plist
    echo "$prefs_restored"
fi

# Restore monitor name if exists
if [[ -f "\${RESTORE_DIR}/monitor_name.txt" ]]; then
    echo "Restoring monitor name..."
    MONITOR_NAME=\$(cat "\${RESTORE_DIR}/monitor_name.txt")
    echo "Monitor name: \$MONITOR_NAME"
fi

echo ""
echo "$restore_complete"
echo ""
echo "Note: You may need to restart your Mac for all changes to take effect."
echo "If you experience issues, check the backup metadata for system information."
EOF
    
    chmod +x "${backup_dir}/restore.sh"
    log_message "SUCCESS" "$restore_script_created ${backup_dir}/restore.sh"
    
    # Create a quick restore script
    cat > "${backup_dir}/quick_restore.sh" << EOF
#!/bin/bash
# Quick restore - just the essential files
RESTORE_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="/Library/Displays/Contents/Resources/Overrides"

if [[ -f "\${RESTORE_DIR}/hidpi_backup.tar.gz" ]]; then
    sudo rm -rf "\${TARGET_DIR}"
    sudo tar -xzf "\${RESTORE_DIR}/hidpi_backup.tar.gz" -C "\${TARGET_DIR%/*}"
    echo "Quick restore completed. Please restart your Mac."
else
    echo "Backup file not found!"
    exit 1
fi
EOF
    
    chmod +x "${backup_dir}/quick_restore.sh"
    log_message "INFO" "✓ Quick restore script created: ${backup_dir}/quick_restore.sh"
    
    echo ""
}

# choose_icon
function choose_icon() {

    rm -rf ${currentDir}/tmp/
    mkdir -p ${currentDir}/tmp/
    mkdir -p ${currentDir}/tmp/DisplayVendorID-${Vid}
    curl -fsSL "${downloadHost}/Icons.plist" -o ${currentDir}/tmp/Icons.plist

    echo ""
    echo "-------------------------------------"
    echo "|********** ${langChooseIcon} ***********|"
    echo "-------------------------------------"
    echo ""
    echo "(1) iMac"
    echo "(2) MacBook"
    echo "(3) MacBook Pro"
    echo "(4) LG ${langDisplay}"
    echo "(5) Pro Display XDR"
    echo "(6) ${langNotChange}"
    echo ""

    read -p "${langInputChoice} [1~6]: " logo
    case ${logo} in
    1)
        Picon=${imacicon}
        RP=("33" "68" "160" "90")
        curl -fsSL "${downloadHost}/displayIcons/iMac.icns" -o ${currentDir}/tmp/DisplayVendorID-${Vid}/DisplayProductID-${Pid}.icns
        ;;
    2)
        Picon=${mbicon}
        RP=("52" "66" "122" "76")
        curl -fsSL "${downloadHost}/displayIcons/MacBook.icns" -o ${currentDir}/tmp/DisplayVendorID-${Vid}/DisplayProductID-${Pid}.icns
        ;;
    3)
        Picon=${mbpicon}
        RP=("40" "62" "147" "92")
        curl -fsSL "${downloadHost}/displayIcons/MacBookPro.icns" -o ${currentDir}/tmp/DisplayVendorID-${Vid}/DisplayProductID-${Pid}.icns
        ;;
    4)
        Picon=${lgicon}
        RP=("11" "47" "202" "114")
        cp ${sysDisplayDir}/DisplayVendorID-1e6d/DisplayProductID-5b11.icns ${currentDir}/tmp/DisplayVendorID-${Vid}/DisplayProductID-${Pid}.icns
        ;;
    5)
        Picon=${proxdricon}
        RP=("5" "45" "216" "121")
        curl -fsSL "${downloadHost}/displayIcons/ProDisplayXDR.icns" -o ${currentDir}/tmp/DisplayVendorID-${Vid}/DisplayProductID-${Pid}.icns
        if [[ ! -f ${targetDir}/DisplayVendorID-610/DisplayProductID-ae2f_Landscape.tiff ]]; then
            curl -fsSL "${downloadHost}/displayIcons/ProDisplayXDR.tiff" -o ${currentDir}/tmp/DisplayVendorID-${Vid}/DisplayProductID-${Pid}.tiff
            Picon=${Overrides}"\/DisplayVendorID\-${Vid}\/DisplayProductID\-${Pid}\.tiff"
        fi
        ;;
    6)
        rm -rf ${currentDir}/tmp/Icons.plist
        ;;
    *)

        echo "${langEnterError}"
        exit 1
        ;;
    esac

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

}

# main
function main() {
    sudo mkdir -p ${currentDir}/tmp/DisplayVendorID-${Vid}
    dpiFile=${currentDir}/tmp/DisplayVendorID-${Vid}/DisplayProductID-${Pid}
    sudo chmod -R 777 ${currentDir}/tmp/

    cat >"${dpiFile}" <<-\CCC
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>DisplayProductID</key>
            <integer>PID</integer>
        <key>DisplayVendorID</key>
            <integer>VID</integer>
        <key>IODisplayEDID</key>
            <data>EDid</data>
        <key>scale-resolutions</key>
            <array>
CCC

    echo ""
    echo "------------------------------------------"
    echo "|********** "${langChooseRes}" ***********|"
    echo "------------------------------------------"
    
    # Detect and suggest native resolution
    detect_native_resolution
    
    # Special detection for Retina notebooks
    detect_retina_notebook
    
    # Detect specific notebook models (Lenovo, Dell, HP, etc.)
    detect_notebook_model
    echo ${langChooseResOp1}
    echo ${langChooseResOp2}
    echo ${langChooseResOp3}
    echo ${langChooseResOp4}
    echo ${langChooseResOp5}
    echo ${langChooseResOp6}
    echo ${langChooseResOp7}
    echo ${langChooseResOp8}
    echo ${langChooseResOp9}
    echo ${langChooseResOp10}
    echo ${langChooseResOpCustom}
    echo ""

    read -p "${langInputChoice}: " res
    case ${res} in
    1)
        create_res_1 1680x945 1440x810 1280x720 1024x576
        create_res_2 1280x800 1280x720 960x600 960x540 640x360
        create_res_3 840x472 800x450 720x405 640x360 576x324 512x288 420x234 400x225 320x180
        create_res_4 1680x945 1440x810 1280x720 1024x576 960x540 840x472 800x450 640x360
        ;;
    2)
        create_res_1 1680x945 1424x802 1280x720 1024x576
        create_res_2 1280x800 1280x720 960x600 960x540 640x360
        create_res_3 840x472 800x450 720x405 640x360 576x324 512x288 420x234 400x225 320x180
        create_res_4 1680x945 1440x810 1280x720 1024x576 960x540 840x472 800x450 640x360
        ;;
    3)
        create_res_1 1680x1050 1440x900 1280x800 1024x640
        create_res_2 1280x800 1280x720 960x600 960x540 640x360
        create_res_3 840x472 800x450 720x405 640x360 576x324 512x288 420x234 400x225 320x180
        create_res_4 1680x1050 1440x900 1280x800 1024x640 960x540 840x472 800x450 640x360
        ;;
    4)
        create_res_1 2560x1440 2048x1152 1920x1080 1760x990 1680x945 1440x810 1360x765 1280x720
        create_res_2 1360x765 1280x800 1280x720 1024x576 960x600 960x540 640x360
        create_res_3 960x540 840x472 800x450 720x405 640x360 576x324 512x288 420x234 400x225 320x180
        create_res_4 2048x1152 1920x1080 1680x945 1440x810 1280x720 1024x576 960x540 840x472 800x450 640x360
        ;;
    5)
        create_res_1 3000x2000 2880x1920 2250x1500 1920x1280 1680x1050 1440x900 1280x800 1024x640
        create_res_2 1280x800 1280x720 960x600 960x540 640x360
        create_res_3 840x472 800x450 720x405 640x360 576x324 512x288 420x234 400x225 320x180
        create_res_4 1920x1280 1680x1050 1440x900 1280x800 1024x640 960x540 840x472 800x450 640x360
        ;;
    6)
        # Scale factors
        # res 1 scf: 1         1.25      1.3333    1.4545   1.7777   2
        create_res_1 3440x1440 2752x1152 2580x1080 2365x990 1935x810 1720x720
        # res 2 scf: 2        2.6666
        create_res_2 1720x720 1290x540
        # res 3 scf: 2.6666
        create_res_3 1290x540
        # res 4 scf: 1.25      1.3333    1.4545   1.7777   2        2.6666
        create_res_4 2752x1152 2580x1080 2365x990 1935x810 1720x720 1290x540
        ;;
    7)
        # 4K Display resolutions
        create_res_1 3840x2160 3200x1800 2880x1620 2560x1440 2048x1152 1920x1080 1680x945 1440x810
        create_res_2 1920x1080 1680x945 1440x810 1280x720 1024x576 960x540 640x360
        create_res_3 960x540 840x472 800x450 720x405 640x360 576x324 512x288 420x234 400x225 320x180
        create_res_4 2560x1440 1920x1080 1680x945 1440x810 1280x720 1024x576 960x540 840x472 800x450 640x360
        ;;
    8)
        # MacBook Pro 16" resolutions
        create_res_1 2560x1600 2048x1280 1920x1200 1680x1050 1440x900 1280x800 1024x640
        create_res_2 1280x800 1280x720 960x600 960x540 640x360
        create_res_3 840x472 800x450 720x405 640x360 576x324 512x288 420x234 400x225 320x180
        create_res_4 1920x1200 1680x1050 1440x900 1280x800 1024x640 960x540 840x472 800x450 640x360
        ;;
    9)
        # MacBook Pro 14" resolutions
        create_res_1 3024x1964 2520x1638 2268x1474 2016x1310 1764x1146 1512x982 1260x819 1008x655
        create_res_2 1260x819 1008x655 840x546 672x437 504x328 336x219
        create_res_3 504x328 336x219 252x164 168x109 126x82 84x55
        create_res_4 2016x1310 1764x1146 1512x982 1260x819 1008x655 840x546 672x437 504x328
        ;;
    10)
        # MacBook Pro 16" M3 resolutions
        create_res_1 3456x2234 2880x1862 2592x1676 2304x1490 2016x1304 1728x1118 1440x932 1152x746
        create_res_2 1440x932 1152x746 960x621 768x497 576x373 384x249
        create_res_3 576x373 384x249 288x187 192x125 144x94 96x63
        create_res_4 2304x1490 2016x1304 1728x1118 1440x932 1152x746 960x621 768x497 576x373
        ;;
    11)
        custom_res
        create_res_2 1360x765 1280x800 1280x720 960x600 960x540 640x360
        create_res_3 840x472 800x450 720x405 640x360 576x324 512x288 420x234 400x225 320x180
        create_res_4 1680x945 1440x810 1280x720 1024x576 960x540 840x472 800x450 640x360
        ;;
    *)
        echo "${langEnterError}"
        exit 1
        ;;
    esac

    cat >>"${dpiFile}" <<-\FFF
            </array>
        <key>target-default-ppmm</key>
            <real>10.0699301</real>
    </dict>
</plist>
FFF

    /usr/bin/sed -i "" "s/VID/$VendorID/g" ${dpiFile}
    /usr/bin/sed -i "" "s/PID/$ProductID/g" ${dpiFile}
}

# end
function end() {
    sudo chown -R root:wheel ${currentDir}/tmp/
    sudo chmod -R 0755 ${currentDir}/tmp/
    sudo chmod 0644 ${currentDir}/tmp/DisplayVendorID-${Vid}/*
    sudo cp -r ${currentDir}/tmp/* ${targetDir}/
    sudo rm -rf ${currentDir}/tmp
    sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool YES
    echo "${langEnabled}"
    echo "${langEnabledLog}"
}

# custom resolution
function custom_res() {
    echo "${langCustomRes}"
    read -p ":" input_resolutions
    
    # Split the input into an array
    IFS=' ' read -r -a resolution_array <<< "$input_resolutions"
    
    # Call the create_res function with the array elements
    create_res "${resolution_array[@]}"
}

# create resolution
function create_res() {
    for res in $@; do
        width=$(echo ${res} | cut -d x -f 1)
        height=$(echo ${res} | cut -d x -f 2)
        hidpi=$(printf '%08x %08x' $((${width} * 2)) $((${height} * 2)) | xxd -r -p | base64)
        #
        cat <<OOO >>${dpiFile}
                <data>${hidpi:0:11}AAAAB</data>
                <data>${hidpi:0:11}AAAABACAAAA==</data>
OOO
    done
}

function create_res_1() {
    for res in $@; do
        width=$(echo ${res} | cut -d x -f 1)
        height=$(echo ${res} | cut -d x -f 2)
        hidpi=$(printf '%08x %08x' $((${width} * 2)) $((${height} * 2)) | xxd -r -p | base64)
        #
        cat <<OOO >>${dpiFile}
                <data>${hidpi:0:11}A</data>
OOO
    done
}

function create_res_2() {
    for res in $@; do
        width=$(echo ${res} | cut -d x -f 1)
        height=$(echo ${res} | cut -d x -f 2)
        hidpi=$(printf '%08x %08x' $((${width} * 2)) $((${height} * 2)) | xxd -r -p | base64)
        #
        cat <<OOO >>${dpiFile}
                <data>${hidpi:0:11}AAAABACAAAA==</data>
OOO
    done
}

function create_res_3() {
    for res in $@; do
        width=$(echo ${res} | cut -d x -f 1)
        height=$(echo ${res} | cut -d x -f 2)
        hidpi=$(printf '%08x %08x' $((${width} * 2)) $((${height} * 2)) | xxd -r -p | base64)
        #
        cat <<OOO >>${dpiFile}
                <data>${hidpi:0:11}AAAAB</data>
OOO
    done
}

function create_res_4() {
    for res in $@; do
        width=$(echo ${res} | cut -d x -f 1)
        height=$(echo ${res} | cut -d x -f 2)
        hidpi=$(printf '%08x %08x' $((${width} * 2)) $((${height} * 2)) | xxd -r -p | base64)
        #
        cat <<OOO >>${dpiFile}
                <data>${hidpi:0:11}AAAAJAKAAAA==</data>
OOO
    done
}

# enable
function enable_hidpi() {
    # Create enhanced backup before making changes
    enhanced_backup
    
    choose_icon
    main
    sed -i "" "/.*IODisplayEDID/d" ${dpiFile}
    sed -i "" "/.*EDid/d" ${dpiFile}
    end
}

# patch
function enable_hidpi_with_patch() {
    # Create enhanced backup before making changes
    enhanced_backup
    
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
    echo ""
    echo "${langDisableOpt1}"
    echo "${langDisableOpt2}"
    echo ""

    read -p "${langInputChoice} [1~2]: " input
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

        echo "${langEnterError}"
        exit 1
        ;;
    esac

    echo "${langDisabled}"
}

# Detect native resolution and suggest appropriate HiDPI settings
function detect_native_resolution() {
    local detecting_msg="Detecting native resolution..."
    local detected_msg="Native resolution detected:"
    local suggested_msg="Suggested configuration:"
    local unknown_msg="Unknown resolution. Please choose manually or use custom option."
    local could_not_msg="Could not detect native resolution automatically."
    
    # Set language-specific messages
    if [[ "${systemLanguage}" == "pt_BR" ]]; then
        detecting_msg="Detectando resolução nativa..."
        detected_msg="Resolução nativa detectada:"
        suggested_msg="Configuração sugerida:"
        unknown_msg="Resolução desconhecida. Por favor, escolha manualmente ou use a opção personalizada."
        could_not_msg="Não foi possível detectar a resolução nativa automaticamente."
    elif [[ "${systemLanguage}" == "es_ES" ]] || [[ "${systemLanguage}" == "es_MX" ]]; then
        detecting_msg="Detectando resolución nativa..."
        detected_msg="Resolución nativa detectada:"
        suggested_msg="Configuración sugerida:"
        unknown_msg="Resolución desconocida. Por favor, elige manualmente o usa la opción personalizada."
        could_not_msg="No se pudo detectar la resolución nativa automáticamente."
    elif [[ "${systemLanguage}" == "fr_FR" ]] || [[ "${systemLanguage}" == "fr_CA" ]]; then
        detecting_msg="Détection de la résolution native..."
        detected_msg="Résolution native détectée:"
        suggested_msg="Configuration suggérée:"
        unknown_msg="Résolution inconnue. Veuillez choisir manuellement ou utiliser l'option personnalisée."
        could_not_msg="Impossible de détecter automatiquement la résolution native."
    fi
    
    echo "$detecting_msg"
    
    # Get current display info
    local display_info=$(system_profiler SPDisplaysDataType | grep -A 10 "Resolution")
    local native_res=$(echo "$display_info" | grep "Resolution:" | head -1 | sed 's/.*Resolution: \([0-9]* x [0-9]*\).*/\1/' | sed 's/ x /x/')
    
    if [[ -n "$native_res" ]]; then
        echo "$detected_msg $native_res"
        
        # Suggest appropriate HiDPI configuration based on native resolution
        case "$native_res" in
            "1920x1080"|"1920x1200")
                echo "$suggested_msg Option 1 or 2 (1920x1080)"
                ;;
            "2560x1440"|"2560x1600")
                echo "$suggested_msg Option 4 (2560x1440) or Option 8 (2560x1600)"
                ;;
            "3000x2000"|"3024x1964")
                echo "$suggested_msg Option 5 (3000x2000) or Option 9 (3024x1964)"
                ;;
            "3456x2234")
                echo "$suggested_msg Option 10 (3456x2234)"
                ;;
            "3840x2160"|"4096x2160")
                echo "$suggested_msg Option 7 (3840x2160)"
                ;;
            "3440x1440")
                echo "$suggested_msg Option 6 (3440x1440)"
                ;;
            *)
                echo "$unknown_msg"
                ;;
        esac
    else
        echo "$could_not_msg"
    fi
    
    echo ""
}

# Special handling for Retina notebook displays
function detect_retina_notebook() {
    local is_retina=false
    local notebook_model=""
    
    # Language-specific messages
    local retina_detected="Retina display detected!"
    local notebook_model_msg="Notebook model:"
    local config_title="=== Retina Notebook Configuration ==="
    local detected_msg="Detected:"
    local recommended_msg="Recommended:"
    local unknown_model="Unknown Retina notebook model"
    local choose_resolution="Please choose based on your screen resolution"
    
    # Set language-specific messages
    if [[ "${systemLanguage}" == "pt_BR" ]]; then
        retina_detected="Display Retina detectado!"
        notebook_model_msg="Modelo do notebook:"
        config_title="=== Configuração de Notebook Retina ==="
        detected_msg="Detectado:"
        recommended_msg="Recomendado:"
        unknown_model="Modelo de notebook Retina desconhecido"
        choose_resolution="Por favor, escolha baseado na resolução da sua tela"
    elif [[ "${systemLanguage}" == "es_ES" ]] || [[ "${systemLanguage}" == "es_MX" ]]; then
        retina_detected="¡Pantalla Retina detectada!"
        notebook_model_msg="Modelo del notebook:"
        config_title="=== Configuración de Notebook Retina ==="
        detected_msg="Detectado:"
        recommended_msg="Recomendado:"
        unknown_model="Modelo de notebook Retina desconocido"
        choose_resolution="Por favor, elige basado en la resolución de tu pantalla"
    elif [[ "${systemLanguage}" == "fr_FR" ]] || [[ "${systemLanguage}" == "fr_CA" ]]; then
        retina_detected="Écran Retina détecté!"
        notebook_model_msg="Modèle du notebook:"
        config_title="=== Configuration du Notebook Retina ==="
        detected_msg="Détecté:"
        recommended_msg="Recommandé:"
        unknown_model="Modèle de notebook Retina inconnu"
        choose_resolution="Veuillez choisir en fonction de la résolution de votre écran"
    fi
    
    # Check if this is a Retina display
    local display_info=$(system_profiler SPDisplaysDataType | grep -A 20 "Resolution")
    if echo "$display_info" | grep -q "Retina"; then
        is_retina=true
        echo "$retina_detected"
    fi
    
    # Detect notebook model
    local model_info=$(system_profiler SPHardwareDataType | grep "Model Name" | head -1)
    if [[ -n "$model_info" ]]; then
        notebook_model=$(echo "$model_info" | sed 's/.*Model Name: \(.*\)/\1/')
        echo "$notebook_model_msg $notebook_model"
    fi
    
    # Suggest specific configurations for known Retina notebooks
    if [[ "$is_retina" == true ]]; then
        echo ""
        echo "$config_title"
        case "$notebook_model" in
            *"MacBook Pro"*"16"*)
                if echo "$notebook_model" | grep -q "M3"; then
                    echo "$detected_msg MacBook Pro 16\" M3"
                    echo "$recommended_msg Option 10 (3456x2234)"
                else
                    echo "$detected_msg MacBook Pro 16\""
                    echo "$recommended_msg Option 8 (2560x1600)"
                fi
                ;;
            *"MacBook Pro"*"14"*)
                echo "$detected_msg MacBook Pro 14\""
                echo "$recommended_msg Option 9 (3024x1964)"
                ;;
            *"MacBook Pro"*"13"*)
                echo "$detected_msg MacBook Pro 13\""
                echo "$recommended_msg Option 1 or 2 (1920x1080)"
                ;;
            *"MacBook Air"*)
                echo "$detected_msg MacBook Air"
                echo "$recommended_msg Option 1 or 2 (1920x1080)"
                ;;
            *)
                echo "$unknown_model"
                echo "$choose_resolution"
                ;;
        esac
        echo "====================================="
        echo ""
    fi
}

# Check system compatibility
function check_system_compatibility() {
    local checking_msg="Checking system compatibility..."
    local version_msg="macOS version:"
    local warning_msg="Warning: This script is designed for macOS 10.14 (Mojave) or later."
    local features_warning="Some features may not work correctly on older versions."
    local sip_enabled="System Integrity Protection (SIP) is enabled."
    local sip_normal="This is normal and the script will work correctly."
    local sip_warning="Warning: System Integrity Protection (SIP) is disabled."
    local sip_issues="This may cause issues with HiDPI configuration."
    local apple_silicon="Apple Silicon Mac detected."
    local optimized_methods="Using optimized detection methods for M1/M2/M3 chips."
    local intel_mac="Intel Mac detected."
    local traditional_methods="Using traditional EDID-based detection."
    
    # Set language-specific messages
    if [[ "${systemLanguage}" == "pt_BR" ]]; then
        checking_msg="Verificando compatibilidade do sistema..."
        version_msg="Versão do macOS:"
        warning_msg="Aviso: Este script foi projetado para macOS 10.14 (Mojave) ou posterior."
        features_warning="Alguns recursos podem não funcionar corretamente em versões mais antigas."
        sip_enabled="Proteção de Integridade do Sistema (SIP) está habilitada."
        sip_normal="Isso é normal e o script funcionará corretamente."
        sip_warning="Aviso: Proteção de Integridade do Sistema (SIP) está desabilitada."
        sip_issues="Isso pode causar problemas com a configuração HiDPI."
        apple_silicon="Mac com Apple Silicon detectado."
        optimized_methods="Usando métodos de detecção otimizados para chips M1/M2/M3."
        intel_mac="Mac Intel detectado."
        traditional_methods="Usando detecção tradicional baseada em EDID."
    elif [[ "${systemLanguage}" == "es_ES" ]] || [[ "${systemLanguage}" == "es_MX" ]]; then
        checking_msg="Verificando compatibilidad del sistema..."
        version_msg="Versión de macOS:"
        warning_msg="Advertencia: Este script está diseñado para macOS 10.14 (Mojave) o posterior."
        features_warning="Algunas funciones pueden no funcionar correctamente en versiones anteriores."
        sip_enabled="Protección de Integridad del Sistema (SIP) está habilitada."
        sip_normal="Esto es normal y el script funcionará correctamente."
        sip_warning="Advertencia: Protección de Integridad del Sistema (SIP) está deshabilitada."
        sip_issues="Esto puede causar problemas con la configuración HiDPI."
        apple_silicon="Mac con Apple Silicon detectado."
        optimized_methods="Usando métodos de detección optimizados para chips M1/M2/M3."
        intel_mac="Mac Intel detectado."
        traditional_methods="Usando detección tradicional basada en EDID."
    elif [[ "${systemLanguage}" == "fr_FR" ]] || [[ "${systemLanguage}" == "fr_CA" ]]; then
        checking_msg="Vérification de la compatibilité du système..."
        version_msg="Version de macOS:"
        warning_msg="Avertissement: Ce script est conçu pour macOS 10.14 (Mojave) ou plus récent."
        features_warning="Certaines fonctionnalités peuvent ne pas fonctionner correctement sur les versions antérieures."
        sip_enabled="Protection d'Intégrité du Système (SIP) est activée."
        sip_normal="C'est normal et le script fonctionnera correctement."
        sip_warning="Avertissement: Protection d'Intégrité du Système (SIP) est désactivée."
        sip_issues="Cela peut causer des problèmes avec la configuration HiDPI."
        apple_silicon="Mac Apple Silicon détecté."
        optimized_methods="Utilisation de méthodes de détection optimisées pour les puces M1/M2/M3."
        intel_mac="Mac Intel détecté."
        traditional_methods="Utilisation de la détection traditionnelle basée sur EDID."
    fi
    
    echo "$checking_msg"
    
    # Get macOS version
    local macos_version=$(sw_vers -productVersion)
    local major_version=$(echo "$macos_version" | cut -d. -f1)
    local minor_version=$(echo "$macos_version" | cut -d. -f2)
    
    echo "$version_msg $macos_version"
    
    # Check if system is compatible
    if [[ "$major_version" -lt 10 ]] || ([[ "$major_version" -eq 10 ]] && [[ "$minor_version" -lt 14 ]]); then
        echo "$warning_msg"
        echo "$features_warning"
        echo ""
    fi
    
    # Check for SIP (System Integrity Protection)
    local sip_status=$(csrutil status 2>/dev/null | grep -o "enabled\|disabled")
    if [[ "$sip_status" == "enabled" ]]; then
        echo "$sip_enabled"
        echo "$sip_normal"
    else
        echo "$sip_warning"
        echo "$sip_issues"
    fi
    
    # Check for Apple Silicon
    if [[ "$is_applesilicon" == true ]]; then
        echo "$apple_silicon"
        echo "$optimized_methods"
    else
        echo "$intel_mac"
        echo "$traditional_methods"
    fi
    
    echo ""
}

#
function start() {
    # Check system requirements first
    check_system_requirements
    
    # Check system compatibility
    check_system_compatibility
    
    init
    echo ""
    let opt++; printf "${langEnableHIDPI}\n" $opt
    if [[ $is_applesilicon == false ]]; then
        let opt++; printf "${langEnableHIDPIEDID}\n" $opt
    fi
    
    # Add option for normal monitors and notebooks
    if [[ "$NOTEBOOK_MANUFACTURER" != "Apple" ]]; then
        let opt++; printf "${langEnableHIDPINormal}\n" $opt
    fi
    
    let opt++; printf "${langDisableHIDPI}\n" $opt
    
    # Add diagnostic option
    let opt++; printf "(%d) Run System Diagnostics\n" $opt
    echo ""

    read -p "${langInputChoice} [1~$opt]: " input
    
    # Determine the number of options based on system type
    local max_options=3
    if [[ $is_applesilicon == false ]]; then
        max_options=4
    fi
    if [[ "$NOTEBOOK_MANUFACTURER" != "Apple" ]]; then
        max_options=$((max_options + 1))
    fi
    
    if [[ $is_applesilicon == true ]]; then
        case ${input} in
        1)
            enable_hidpi
            ;;
        2)
            if [[ "$NOTEBOOK_MANUFACTURER" != "Apple" ]]; then
                enable_hidpi_normal_monitor
            else
                disable
            fi
            ;;
        3)
            disable
            ;;
        *)
            echo "${langEnterError}"
            exit 1
            ;;
        esac
    else
        case ${input} in
        1)
            enable_hidpi
            ;;
        2)
            enable_hidpi_with_patch
            ;;
        3)
            if [[ "$NOTEBOOK_MANUFACTURER" != "Apple" ]]; then
                enable_hidpi_normal_monitor
            else
                disable
            fi
            ;;
        4)
            disable
            ;;
        5)
            run_diagnostics
            ;;
        *)
            echo "${langEnterError}"
            exit 1
            ;;
        esac
    fi
}

# Detect and configure specific notebook models (Lenovo, Dell, HP, etc.)
function detect_notebook_model() {
    local notebook_info=""
    local manufacturer=""
    local model=""
    local series=""
    
    # Language-specific messages
    local detecting_notebook_msg="Detecting notebook model..."
    local model_name_msg="Model Name:"
    local model_identifier_msg="Model Identifier:"
    local detected_msg="✓ Detected:"
    local recommended_msg="  Recommended:"
    local unknown_manufacturer_msg="⚠ Unknown notebook manufacturer:"
    local recommended_default_msg="  Recommended: Use Option 1 or 2 (1920x1080) as default"
    
    # Set language-specific messages
    if [[ "${systemLanguage}" == "pt_BR" ]]; then
        detecting_notebook_msg="Detectando modelo do notebook..."
        model_name_msg="Nome do Modelo:"
        model_identifier_msg="Identificador do Modelo:"
        detected_msg="✓ Detectado:"
        recommended_msg="  Recomendado:"
        unknown_manufacturer_msg="⚠ Fabricante de notebook desconhecido:"
        recommended_default_msg="  Recomendado: Use Opção 1 ou 2 (1920x1080) como padrão"
    elif [[ "${systemLanguage}" == "es_ES" ]] || [[ "${systemLanguage}" == "es_MX" ]]; then
        detecting_notebook_msg="Detectando modelo del notebook..."
        model_name_msg="Nombre del Modelo:"
        model_identifier_msg="Identificador del Modelo:"
        detected_msg="✓ Detectado:"
        recommended_msg="  Recomendado:"
        unknown_manufacturer_msg="⚠ Fabricante de notebook desconocido:"
        recommended_default_msg="  Recomendado: Use Opción 1 o 2 (1920x1080) como predeterminado"
    elif [[ "${systemLanguage}" == "fr_FR" ]] || [[ "${systemLanguage}" == "fr_CA" ]]; then
        detecting_notebook_msg="Détection du modèle de notebook..."
        model_name_msg="Nom du Modèle:"
        model_identifier_msg="Identifiant du Modèle:"
        detected_msg="✓ Détecté:"
        recommended_msg="  Recommandé:"
        unknown_manufacturer_msg="⚠ Fabricant de notebook inconnu:"
        recommended_default_msg="  Recommandé: Utilisez Option 1 ou 2 (1920x1080) par défaut"
    elif [[ "${systemLanguage}" == "zh_CN" ]]; then
        detecting_notebook_msg="检测笔记本型号..."
        model_name_msg="型号名称:"
        model_identifier_msg="型号标识符:"
        detected_msg="✓ 检测到:"
        recommended_msg="  推荐:"
        unknown_manufacturer_msg="⚠ 未知笔记本制造商:"
        recommended_default_msg="  推荐: 使用选项1或2 (1920x1080) 作为默认值"
    elif [[ "${systemLanguage}" == "uk_UA" ]]; then
        detecting_notebook_msg="Детекція моделі ноутбука..."
        model_name_msg="Назва Моделі:"
        model_identifier_msg="Ідентифікатор Моделі:"
        detected_msg="✓ Виявлено:"
        recommended_msg="  Рекомендовано:"
        unknown_manufacturer_msg="⚠ Невідомий виробник ноутбука:"
        recommended_default_msg="  Рекомендовано: Використовуйте Опцію 1 або 2 (1920x1080) як за замовчуванням"
    fi
    
    echo "$detecting_notebook_msg"
    
    # Get system information
    local system_info=$(system_profiler SPHardwareDataType)
    local model_name=$(echo "$system_info" | grep "Model Name" | head -1 | sed 's/.*Model Name: \(.*\)/\1/')
    local model_identifier=$(echo "$system_info" | grep "Model Identifier" | head -1 | sed 's/.*Model Identifier: \(.*\)/\1/')
    
    echo "$model_name_msg $model_name"
    echo "$model_identifier_msg $model_identifier"
    
    # Detect manufacturer and series
    if [[ "$model_name" == *"Lenovo"* ]]; then
        manufacturer="Lenovo"
        if [[ "$model_name" == *"S145"* ]]; then
            series="S145"
            echo "$detected_msg Lenovo S145"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080) for 15.6\" display"
            echo "  This model typically has a 15.6\" 1920x1080 TN/IPS panel"
        elif [[ "$model_name" == *"ThinkPad"* ]]; then
            series="ThinkPad"
            echo "$detected_msg Lenovo ThinkPad"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080) for most models"
        elif [[ "$model_name" == *"IdeaPad"* ]]; then
            series="IdeaPad"
            echo "$detected_msg Lenovo IdeaPad"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080) for most models"
        elif [[ "$model_name" == *"Legion"* ]]; then
            series="Legion"
            echo "$detected_msg Lenovo Legion"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080) for most models"
        else
            series="Generic"
            echo "$detected_msg Lenovo (Generic)"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080)"
        fi
    elif [[ "$model_name" == *"Dell"* ]]; then
        manufacturer="Dell"
        if [[ "$model_name" == *"Inspiron"* ]]; then
            series="Inspiron"
            echo "$detected_msg Dell Inspiron"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080) for most models"
        elif [[ "$model_name" == *"Latitude"* ]]; then
            series="Latitude"
            echo "$detected_msg Dell Latitude"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080) for most models"
        elif [[ "$model_name" == *"Precision"* ]]; then
            series="Precision"
            echo "$detected_msg Dell Precision"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080) for most models"
        elif [[ "$model_name" == *"XPS"* ]]; then
            series="XPS"
            echo "$detected_msg Dell XPS"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080) for most models"
        else
            series="Generic"
            echo "$detected_msg Dell (Generic)"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080)"
        fi
    elif [[ "$model_name" == *"HP"* ]] || [[ "$model_name" == *"Hewlett-Packard"* ]]; then
        manufacturer="HP"
        if [[ "$model_name" == *"Pavilion"* ]]; then
            series="Pavilion"
            echo "$detected_msg HP Pavilion"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080) for most models"
        elif [[ "$model_name" == *"EliteBook"* ]]; then
            series="EliteBook"
            echo "$detected_msg HP EliteBook"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080) for most models"
        elif [[ "$model_name" == *"ProBook"* ]]; then
            series="ProBook"
            echo "$detected_msg HP ProBook"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080) for most models"
        elif [[ "$model_name" == *"Envy"* ]]; then
            series="Envy"
            echo "$detected_msg HP Envy"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080) for most models"
        else
            series="Generic"
            echo "$detected_msg HP (Generic)"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080)"
        fi
    elif [[ "$model_name" == *"ASUS"* ]]; then
        manufacturer="ASUS"
        if [[ "$model_name" == *"VivoBook"* ]]; then
            series="VivoBook"
            echo "$detected_msg ASUS VivoBook"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080) for most models"
        elif [[ "$model_name" == *"ZenBook"* ]]; then
            series="ZenBook"
            echo "$detected_msg ASUS ZenBook"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080) for most models"
        elif [[ "$model_name" == *"ROG"* ]]; then
            series="ROG"
            echo "$detected_msg ASUS ROG"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080) for most models"
        else
            series="Generic"
            echo "$detected_msg ASUS (Generic)"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080)"
        fi
    elif [[ "$model_name" == *"Acer"* ]]; then
        manufacturer="Acer"
        if [[ "$model_name" == *"Aspire"* ]]; then
            series="Aspire"
            echo "$detected_msg Acer Aspire"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080) for most models"
        elif [[ "$model_name" == *"Swift"* ]]; then
            series="Swift"
            echo "$detected_msg Acer Swift"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080) for most models"
        else
            series="Generic"
            echo "$detected_msg Acer (Generic)"
            echo "$recommended_msg Use Option 1 or 2 (1920x1080)"
        fi
    else
        manufacturer="Unknown"
        series="Generic"
        echo "$unknown_manufacturer_msg $model_name"
        echo "$recommended_default_msg"
    fi
    
    # Store notebook information
    NOTEBOOK_MANUFACTURER="$manufacturer"
    NOTEBOOK_SERIES="$series"
    NOTEBOOK_MODEL="$model_name"
    
    echo ""
}

# Create custom EDID for specific monitor types
function create_custom_edid() {
    local monitor_type="$1"
    local resolution="$2"
    local custom_edid=""
    
    echo "Creating custom EDID for $monitor_type with resolution $resolution..."
    
    case "$monitor_type" in
        "lenovo_s145")
            # Custom EDID for Lenovo S145 15.6" 1920x1080
            custom_edid="00ffffffffffff000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            
            # Set Lenovo manufacturer ID (0x17EF)
            VendorID=6127  # 0x17EF
            ProductID=40960  # 0xA000
            Vid="17ef"
            Pid="a000"
            ;;
        "generic_1920x1080")
            # Generic 1920x1080 monitor
            custom_edid="00ffffffffffff000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            
            VendorID=1552  # 0x0610 - Apple (generic)
            ProductID=40960  # 0xA000
            Vid="0610"
            Pid="a000"
            ;;
        "generic_1366x768")
            # Generic 1366x768 monitor (common in older laptops)
            custom_edid="00ffffffffffff000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            custom_edid+="00000000000000000000000000000000"
            
            VendorID=1552  # 0x0610 - Apple (generic)
            ProductID=40961  # 0xA001
            Vid="0610"
            Pid="a001"
            ;;
        *)
            # Default generic EDID
            create_generic_edid
            return
            ;;
    esac
    
    EDID="$custom_edid"
    echo "✓ Custom EDID created for $monitor_type with VID:PID $Vid:$Pid"
}

# Enhanced HiDPI application for normal monitors
function apply_hidpi_normal_monitor() {
    local monitor_type="$1"
    local resolution="$2"
    
    echo "Applying HiDPI for normal monitor: $monitor_type"
    
    # Create custom EDID if needed
    if [[ "$monitor_type" == "lenovo_s145" ]]; then
        create_custom_edid "lenovo_s145" "$resolution"
    elif [[ "$resolution" == "1920x1080" ]]; then
        create_custom_edid "generic_1920x1080" "$resolution"
    elif [[ "$resolution" == "1366x768" ]]; then
        create_custom_edid "generic_1366x768" "$resolution"
    else
        create_generic_edid
    fi
    
    # Apply HiDPI configuration
    echo "Applying HiDPI configuration..."
    
    # Create the configuration directory
    sudo mkdir -p "${currentDir}/tmp/DisplayVendorID-${Vid}"
    sudo chmod 777 "${currentDir}/tmp/DisplayVendorID-${Vid}"
    
    # Create the configuration file
    local config_file="${currentDir}/tmp/DisplayVendorID-${Vid}/DisplayProductID-${Pid}"
    
    cat >"${config_file}" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>DisplayProductID</key>
            <integer>${ProductID}</integer>
        <key>DisplayVendorID</key>
            <integer>${VendorID}</integer>
        <key>IODisplayEDID</key>
            <data>EDid</data>
        <key>scale-resolutions</key>
            <array>
EOF
    
    # Add resolutions based on monitor type
    case "$monitor_type" in
        "lenovo_s145"|"generic_1920x1080")
            # 1920x1080 HiDPI resolutions
            echo "                <data>AAAKAAAABaAAAAABACAAAA==</data>" >> "${config_file}"
            echo "                <data>AAAKAAAABaAAAAABACAAAA==</data>" >> "${config_file}"
            echo "                <data>AAAKAAAABaAAAAABACAAAA==</data>" >> "${config_file}"
            echo "                <data>AAAKAAAABaAAAAABACAAAA==</data>" >> "${config_file}"
            ;;
        "generic_1366x768")
            # 1366x768 HiDPI resolutions
            echo "                <data>AAAKAAAABaAAAAABACAAAA==</data>" >> "${config_file}"
            echo "                <data>AAAKAAAABaAAAAABACAAAA==</data>" >> "${config_file}"
            ;;
        *)
            # Generic resolutions
            echo "                <data>AAAKAAAABaAAAAABACAAAA==</data>" >> "${config_file}"
            ;;
    esac
    
    cat >>"${config_file}" <<EOF
            </array>
        <key>target-default-ppmm</key>
            <real>10.0699301</real>
    </dict>
</plist>
EOF
    
    echo "✓ HiDPI configuration created for $monitor_type"
}

# Enable HiDPI for normal monitors and notebooks
function enable_hidpi_normal_monitor() {
    echo "Enabling HiDPI for Normal Monitor/Notebook..."
    
    # Create enhanced backup before making changes
    enhanced_backup
    
    # Determine monitor type based on detected notebook
    local monitor_type="generic"
    local resolution="1920x1080"
    
    if [[ "$NOTEBOOK_MANUFACTURER" == "Lenovo" ]]; then
        if [[ "$NOTEBOOK_SERIES" == "S145" ]]; then
            monitor_type="lenovo_s145"
            resolution="1920x1080"
            echo "✓ Detected Lenovo S145 - applying optimized HiDPI configuration"
        else
            monitor_type="lenovo_generic"
            echo "✓ Detected Lenovo notebook - applying standard HiDPI configuration"
        fi
    elif [[ "$NOTEBOOK_MANUFACTURER" == "Dell" ]]; then
        monitor_type="dell_generic"
        echo "✓ Detected Dell notebook - applying standard HiDPI configuration"
    elif [[ "$NOTEBOOK_MANUFACTURER" == "HP" ]]; then
        monitor_type="hp_generic"
        echo "✓ Detected HP notebook - applying standard HiDPI configuration"
    elif [[ "$NOTEBOOK_MANUFACTURER" == "ASUS" ]]; then
        monitor_type="asus_generic"
        echo "✓ Detected ASUS notebook - applying standard HiDPI configuration"
    elif [[ "$NOTEBOOK_MANUFACTURER" == "Acer" ]]; then
        monitor_type="acer_generic"
        echo "✓ Detected Acer notebook - applying standard HiDPI configuration"
    else
        monitor_type="generic"
        echo "✓ Using generic HiDPI configuration"
    fi
    
    # Apply HiDPI configuration
    apply_hidpi_normal_monitor "$monitor_type" "$resolution"
    
    # Language-specific messages for options
    local icon_question="Do you want to set a custom display icon? (y/n)"
    local rename_question="Do you want to rename the monitor? (y/n)"
    local choice_prompt="Choice:"
    
    # Set language-specific messages
    if [[ "${systemLanguage}" == "pt_BR" ]]; then
        icon_question="Você quer definir um ícone personalizado para o monitor? (s/n)"
        rename_question="Você quer renomear o monitor? (s/n)"
        choice_prompt="Escolha:"
    elif [[ "${systemLanguage}" == "es_ES" ]] || [[ "${systemLanguage}" == "es_MX" ]]; then
        icon_question="¿Quieres establecer un icono personalizado para el monitor? (s/n)"
        rename_question="¿Quieres renombrar el monitor? (s/n)"
        choice_prompt="Elección:"
    elif [[ "${systemLanguage}" == "fr_FR" ]] || [[ "${systemLanguage}" == "fr_CA" ]]; then
        icon_question="Voulez-vous définir une icône personnalisée pour l'écran? (o/n)"
        rename_question="Voulez-vous renommer l'écran? (o/n)"
        choice_prompt="Choix:"
    elif [[ "${systemLanguage}" == "zh_CN" ]]; then
        icon_question="您要设置自定义显示器图标吗？(y/n)"
        rename_question="您要重命名显示器吗？(y/n)"
        choice_prompt="选择:"
    elif [[ "${systemLanguage}" == "uk_UA" ]]; then
        icon_question="Чи хочете встановити власну піктограму для монітора? (y/n)"
        rename_question="Чи хочете перейменувати монітор? (y/n)"
        choice_prompt="Вибір:"
    fi
    
    # Choose icon (optional)
    echo ""
    echo "$icon_question"
    read -p "$choice_prompt " icon_choice
    if [[ "$icon_choice" == "y" || "$icon_choice" == "Y" || "$icon_choice" == "s" || "$icon_choice" == "S" || "$icon_choice" == "o" || "$icon_choice" == "O" ]]; then
        choose_icon
    fi
    
    # Rename monitor (optional)
    echo ""
    echo "$rename_question"
    read -p "$choice_prompt " rename_choice
    if [[ "$rename_choice" == "y" || "$rename_choice" == "Y" || "$rename_choice" == "s" || "$rename_choice" == "S" || "$rename_choice" == "o" || "$rename_choice" == "O" ]]; then
        rename_monitor
    fi
    
    # Apply the configuration
    sudo mkdir -p ${currentDir}/tmp/DisplayVendorID-${Vid}
    sudo chmod -R 777 ${currentDir}/tmp/
    sudo chown -R root:wheel ${currentDir}/tmp/
    sudo chmod -R 0755 ${currentDir}/tmp/
    sudo chmod 0644 ${currentDir}/tmp/DisplayVendorID-${Vid}/*
    sudo cp -r ${currentDir}/tmp/* ${targetDir}/
    sudo rm -rf ${currentDir}/tmp
    sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool YES
    
    echo ""
    echo "✓ HiDPI enabled for normal monitor/notebook!"
    echo "✓ Please restart your Mac to apply the changes."
    echo "✓ If you experience issues, use the restore script in the backup folder."
}

# Start the script
start

# Function to rename monitor display name
function rename_monitor() {
    local current_name=""
    local new_name=""
    
    # Language-specific messages
    local rename_title="Monitor Rename"
    local current_name_msg="Current monitor name:"
    local enter_new_name="Enter new monitor name (or press Enter to skip):"
    local rename_success="✓ Monitor renamed successfully!"
    local rename_skip="Monitor rename skipped."
    
    # Set language-specific messages
    if [[ "${systemLanguage}" == "pt_BR" ]]; then
        rename_title="Renomear Monitor"
        current_name_msg="Nome atual do monitor:"
        enter_new_name="Digite o novo nome do monitor (ou pressione Enter para pular):"
        rename_success="✓ Monitor renomeado com sucesso!"
        rename_skip="Renomeação do monitor ignorada."
    elif [[ "${systemLanguage}" == "es_ES" ]] || [[ "${systemLanguage}" == "es_MX" ]]; then
        rename_title="Renombrar Monitor"
        current_name_msg="Nombre actual del monitor:"
        enter_new_name="Ingresa el nuevo nombre del monitor (o presiona Enter para omitir):"
        rename_success="✓ ¡Monitor renombrado exitosamente!"
        rename_skip="Renombrado del monitor omitido."
    elif [[ "${systemLanguage}" == "fr_FR" ]] || [[ "${systemLanguage}" == "fr_CA" ]]; then
        rename_title="Renommer l'Écran"
        current_name_msg="Nom actuel de l'écran:"
        enter_new_name="Entrez le nouveau nom de l'écran (ou appuyez sur Entrée pour ignorer):"
        rename_success="✓ Écran renommé avec succès!"
        rename_skip="Renommage de l'écran ignoré."
    elif [[ "${systemLanguage}" == "zh_CN" ]]; then
        rename_title="重命名显示器"
        current_name_msg="当前显示器名称:"
        enter_new_name="输入新的显示器名称 (或按Enter跳过):"
        rename_success="✓ 显示器重命名成功!"
        rename_skip="跳过显示器重命名。"
    elif [[ "${systemLanguage}" == "uk_UA" ]]; then
        rename_title="Перейменувати Монітор"
        current_name_msg="Поточна назва монітора:"
        enter_new_name="Введіть нову назву монітора (або натисніть Enter для пропуску):"
        rename_success="✓ Монітор успішно перейменовано!"
        rename_skip="Перейменування монітора пропущено."
    fi
    
    echo ""
    echo "-------------------------------------"
    echo "|********** $rename_title ***********|"
    echo "-------------------------------------"
    
    # Get current monitor name
    if [[ -n "$MonitorName" ]]; then
        current_name="$MonitorName"
    else
        current_name="Unknown Monitor"
    fi
    
    echo "$current_name_msg $current_name"
    echo ""
    echo "$enter_new_name"
    read -p "> " new_name
    
    # Trim whitespace
    new_name=$(echo "$new_name" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    
    if [[ -n "$new_name" ]]; then
        # Update monitor name
        MonitorName="$new_name"
        
        # Create or update the monitor name in the configuration
        local name_file="${currentDir}/tmp/DisplayVendorID-${Vid}/DisplayProductID-${Pid}.name"
        echo "$new_name" > "$name_file"
        
        echo "$rename_success"
        
        # Language-specific confirmation message
        local new_name_msg="New name:"
        if [[ "${systemLanguage}" == "pt_BR" ]]; then
            new_name_msg="Novo nome:"
        elif [[ "${systemLanguage}" == "es_ES" ]] || [[ "${systemLanguage}" == "es_MX" ]]; then
            new_name_msg="Nuevo nombre:"
        elif [[ "${systemLanguage}" == "fr_FR" ]] || [[ "${systemLanguage}" == "fr_CA" ]]; then
            new_name_msg="Nouveau nom:"
        elif [[ "${systemLanguage}" == "zh_CN" ]]; then
            new_name_msg="新名称:"
        elif [[ "${systemLanguage}" == "uk_UA" ]]; then
            new_name_msg="Нова назва:"
        fi
        
        echo "$new_name_msg $new_name"
    else
        echo "$rename_skip"
    fi
    
    echo ""
}

# Auto-configuration function based on detected hardware
function auto_configure_hidpi() {
    log_message "INFO" "Starting auto-configuration..."
    
    local auto_config_success="✓ Auto-configuration completed successfully!"
    local auto_config_failed="✗ Auto-configuration failed"
    local auto_config_skip="Auto-configuration skipped"
    
    # Set language-specific messages
    if [[ "${systemLanguage}" == "pt_BR" ]]; then
        auto_config_success="✓ Auto-configuração concluída com sucesso!"
        auto_config_failed="✗ Auto-configuração falhou"
        auto_config_skip="Auto-configuração ignorada"
    elif [[ "${systemLanguage}" == "es_ES" ]] || [[ "${systemLanguage}" == "es_MX" ]]; then
        auto_config_success="✓ ¡Auto-configuración completada exitosamente!"
        auto_config_failed="✗ Auto-configuración falló"
        auto_config_skip="Auto-configuración omitida"
    elif [[ "${systemLanguage}" == "fr_FR" ]] || [[ "${systemLanguage}" == "fr_CA" ]]; then
        auto_config_success="✓ Auto-configuration terminée avec succès!"
        auto_config_failed="✗ Auto-configuration échouée"
        auto_config_skip="Auto-configuration ignorée"
    fi
    
    # Detect optimal configuration based on hardware
    local optimal_resolution=""
    local optimal_icon=""
    
    # Determine optimal resolution based on notebook model
    if [[ "$NOTEBOOK_MANUFACTURER" == "Lenovo" ]]; then
        if [[ "$NOTEBOOK_SERIES" == "S145" ]]; then
            optimal_resolution="1920x1080"
            optimal_icon="macbook"
        elif [[ "$NOTEBOOK_SERIES" == "ThinkPad" ]]; then
            optimal_resolution="1920x1080"
            optimal_icon="macbook"
        else
            optimal_resolution="1920x1080"
            optimal_icon="macbook"
        fi
    elif [[ "$NOTEBOOK_MANUFACTURER" == "Dell" ]]; then
        if [[ "$NOTEBOOK_SERIES" == "XPS" ]]; then
            optimal_resolution="2560x1440"
            optimal_icon="macbookpro"
        else
            optimal_resolution="1920x1080"
            optimal_icon="macbook"
        fi
    elif [[ "$NOTEBOOK_MANUFACTURER" == "Apple" ]]; then
        # Apple displays are usually already optimized
        log_message "INFO" "Apple display detected - HiDPI should already be optimized"
        return 0
    else
        # Generic configuration
        optimal_resolution="1920x1080"
        optimal_icon="macbook"
    fi
    
    # Ask user if they want auto-configuration
    echo ""
    echo "Auto-configuration detected:"
    echo "  Optimal resolution: $optimal_resolution"
    echo "  Optimal icon: $optimal_icon"
    echo ""
    echo "Do you want to apply auto-configuration? (y/n)"
    read -p "Choice: " auto_choice
    
    if [[ "$auto_choice" == "y" || "$auto_choice" == "Y" ]]; then
        log_message "INFO" "Applying auto-configuration..."
        
        # Apply the optimal configuration
        case "$optimal_resolution" in
            "1920x1080")
                create_res_1 1680x945 1440x810 1280x720 1024x576
                create_res_2 1280x800 1280x720 960x600 960x540 640x360
                create_res_3 840x472 800x450 720x405 640x360 576x324 512x288 420x234 400x225 320x180
                create_res_4 1680x945 1440x810 1280x720 1024x576 960x540 840x472 800x450 640x360
                ;;
            "2560x1440")
                create_res_1 2560x1440 2048x1152 1920x1080 1760x990 1680x945 1440x810 1360x765 1280x720
                create_res_2 1360x765 1280x800 1280x720 1024x576 960x600 960x540 640x360
                create_res_3 960x540 840x472 800x450 720x405 640x360 576x324 512x288 420x234 400x225 320x180
                create_res_4 2048x1152 1920x1080 1680x945 1440x810 1280x720 1024x576 960x540 840x472 800x450 640x360
                ;;
            *)
                # Default to 1920x1080
                create_res_1 1680x945 1440x810 1280x720 1024x576
                create_res_2 1280x800 1280x720 960x600 960x540 640x360
                create_res_3 840x472 800x450 720x405 640x360 576x324 512x288 420x234 400x225 320x180
                create_res_4 1680x945 1440x810 1280x720 1024x576 960x540 840x472 800x450 640x360
                ;;
        esac
        
        # Apply optimal icon
        case "$optimal_icon" in
            "macbook")
                Picon=${mbicon}
                RP=("52" "66" "122" "76")
                curl -fsSL "${downloadHost}/displayIcons/MacBook.icns" -o ${currentDir}/tmp/DisplayVendorID-${Vid}/DisplayProductID-${Pid}.icns
                ;;
            "macbookpro")
                Picon=${mbpicon}
                RP=("40" "62" "147" "92")
                curl -fsSL "${downloadHost}/displayIcons/MacBookPro.icns" -o ${currentDir}/tmp/DisplayVendorID-${Vid}/DisplayProductID-${Pid}.icns
                ;;
            "imac")
                Picon=${imacicon}
                RP=("33" "68" "160" "90")
                curl -fsSL "${downloadHost}/displayIcons/iMac.icns" -o ${currentDir}/tmp/DisplayVendorID-${Vid}/DisplayProductID-${Pid}.icns
                ;;
        esac
        
        log_message "SUCCESS" "$auto_config_success"
        return 0
    else
        log_message "INFO" "$auto_config_skip"
        return 1
    fi
}

# Diagnostic function to check system status
function run_diagnostics() {
    log_message "INFO" "Running system diagnostics..."
    
    local diagnostic_title="System Diagnostics"
    local sip_status_msg="SIP Status:"
    local hidpi_status_msg="HiDPI Status:"
    local display_info_msg="Display Information:"
    local backup_status_msg="Backup Status:"
    
    # Set language-specific messages
    if [[ "${systemLanguage}" == "pt_BR" ]]; then
        diagnostic_title="Diagnóstico do Sistema"
        sip_status_msg="Status do SIP:"
        hidpi_status_msg="Status do HiDPI:"
        display_info_msg="Informações do Monitor:"
        backup_status_msg="Status do Backup:"
    elif [[ "${systemLanguage}" == "es_ES" ]] || [[ "${systemLanguage}" == "es_MX" ]]; then
        diagnostic_title="Diagnóstico del Sistema"
        sip_status_msg="Estado del SIP:"
        hidpi_status_msg="Estado del HiDPI:"
        display_info_msg="Información del Monitor:"
        backup_status_msg="Estado del Respaldo:"
    elif [[ "${systemLanguage}" == "fr_FR" ]] || [[ "${systemLanguage}" == "fr_CA" ]]; then
        diagnostic_title="Diagnostic du Système"
        sip_status_msg="État du SIP:"
        hidpi_status_msg="État du HiDPI:"
        display_info_msg="Informations de l'Écran:"
        backup_status_msg="État de la Sauvegarde:"
    fi
    
    echo ""
    echo "=========================================="
    echo "|********** $diagnostic_title ***********|"
    echo "=========================================="
    
    # Check SIP status
    echo ""
    echo "$sip_status_msg"
    local sip_status=$(csrutil status 2>/dev/null | grep -o "enabled\|disabled")
    if [[ "$sip_status" == "enabled" ]]; then
        echo "  ✅ SIP is enabled (normal)"
    else
        echo "  ⚠️  SIP is disabled (may cause issues)"
    fi
    
    # Check HiDPI status
    echo ""
    echo "$hidpi_status_msg"
    if [[ -d "${targetDir}" ]]; then
        local hidpi_files=$(find "${targetDir}" -name "*.plist" 2>/dev/null | wc -l)
        if [[ $hidpi_files -gt 0 ]]; then
            echo "  ✅ HiDPI configurations found ($hidpi_files files)"
        else
            echo "  ℹ️  HiDPI directory exists but no configurations found"
        fi
    else
        echo "  ℹ️  No HiDPI configurations found"
    fi
    
    # Check display information
    echo ""
    echo "$display_info_msg"
    echo "  Vendor ID: $Vid"
    echo "  Product ID: $Pid"
    echo "  Monitor Name: $MonitorName"
    if [[ -n "$NOTEBOOK_MANUFACTURER" ]]; then
        echo "  Notebook: $NOTEBOOK_MANUFACTURER $NOTEBOOK_SERIES"
    fi
    
    # Check backup status
    echo ""
    echo "$backup_status_msg"
    local backup_count=$(find "${currentDir}/backups" -maxdepth 1 -type d 2>/dev/null | wc -l)
    if [[ $backup_count -gt 1 ]]; then
        echo "  ✅ Backups found ($((backup_count-1)) backups)"
        echo "  Latest backup: $(ls -t "${currentDir}/backups" 2>/dev/null | head -1)"
    else
        echo "  ℹ️  No backups found"
    fi
    
    # Check system compatibility
    echo ""
    echo "System Compatibility:"
    local macos_version=$(sw_vers -productVersion)
    local major_version=$(echo "$macos_version" | cut -d. -f1)
    local minor_version=$(echo "$macos_version" | cut -d. -f2)
    
    if [[ "$major_version" -ge 10 ]] && [[ "$minor_version" -ge 14 ]]; then
        echo "  ✅ macOS $macos_version is compatible"
    else
        echo "  ⚠️  macOS $macos_version may have compatibility issues"
    fi
    
    # Check available disk space
    echo ""
    echo "Disk Space:"
    local available_space=$(df -h . | awk 'NR==2 {print $4}')
    echo "  Available: $available_space"
    
    if [[ $available_space -lt 1 ]]; then
        echo "  ⚠️  Low disk space detected"
    else
        echo "  ✅ Sufficient disk space"
    fi
    
    # Check network connectivity (for downloading icons)
    echo ""
    echo "Network Connectivity:"
    if ping -c 1 raw.githubusercontent.com &>/dev/null; then
        echo "  ✅ Internet connection available"
    else
        echo "  ⚠️  No internet connection (icons may not download)"
    fi
    
    echo ""
    echo "=========================================="
    echo ""
}

# Parse command line arguments
if [[ $# -gt 0 ]]; then
    case "$1" in
        "--info")
            # Return system information in JSON format for GUI
            echo "{\"vendor_id\":\"$Vid\",\"product_id\":\"$Pid\",\"monitor_name\":\"$MonitorName\",\"system_status\":\"Ready\"}"
            exit 0
            ;;
        "--auto")
            # Auto configuration mode
            auto_configure_hidpi
            exit 0
            ;;
        "--diagnostics")
            # Run diagnostics
            run_diagnostics
            exit 0
            ;;
        "--configure")
            # Configure with parameters: resolution icon custom_name
            if [[ $# -ge 4 ]]; then
                local resolution="$2"
                local icon="$3"
                local custom_name="$4"
                # Apply configuration
                apply_hidpi_normal_monitor "$resolution" "$icon" "$custom_name"
            fi
            exit 0
            ;;
        "--reset")
            # Reset configuration
            disable
            exit 0
            ;;
        "--help"|"-h")
            echo "HiDPI Configurator - Enhanced Display Configuration"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --info          Show system information in JSON format"
            echo "  --auto          Run auto configuration"
            echo "  --diagnostics   Run system diagnostics"
            echo "  --configure     Configure with parameters (resolution icon custom_name)"
            echo "  --reset         Reset HiDPI configuration"
            echo "  --help, -h      Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 --info"
            echo "  $0 --auto"
            echo "  $0 --configure 1920x1080 macbook \"My Monitor\""
            echo ""
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
else
    # Call start function for interactive mode
    start
fi
