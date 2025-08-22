#!/bin/bash

cat <<EEF
  _    _   _____   _____    _____    _____ 
 | |  | | |_   _| |  __ \  |  __ \  |_   _|
 | |__| |   | |   | |  | | | |__) |   | |  
 |  __  |   | |   | |  | | |  ___/    | |  
 | |  | |  _| |_  | |__| | | |       _| |_ 
 |_|  |_| |_____| |_____/  |_|      |_____|
                                           
============================================
EEF

# Diretório do script
currentDir="$(cd $(dirname -- $0) && pwd)"

# Detecta idioma do sistema
systemLanguage=($(locale | grep LANG | sed s/'LANG='// | tr -d '"' | cut -d "." -f 1))

# Detecta se é Apple Silicon
is_applesilicon=$([[ "$(uname -m)" == "arm64" ]] && echo true || echo false)

# Idiomas padrão (English)
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
langCustomRes="Enter the HIDPI resolution, separated by a space, like this: 1680x945 1600x900 1440x810"

langChooseIcon="Display Icon"
langNotChange="Do not change"

langEnableHIDPI="(%d) Enable HIDPI"
langEnableHIDPIEDID="(%d) Enable HIDPI (with EDID)"
langDisableHIDPI="(%d) Disable HIDPI"

langDisableOpt1="(1) Disable HIDPI on this monitor"
langDisableOpt2="(2) Reset all settings to macOS default"

langChooseRes="Resolution config"
langChooseResOp1="(1) 1920x1080 Display"
langChooseResOp2="(2) 1920x1080 Display (use 1424x802, fix underscaled after sleep)"
langChooseResOp3="(3) 1920x1200 Display"
langChooseResOp4="(4) 2560x1440 Display"
langChooseResOp5="(5) 3000x2000 Display"
langChooseResOp6="(6) 3440x1440 Display"
langChooseResOpCustom="(7) Manual input resolution"

langNoMonitFound="No monitors were found. Exiting..."
langMonitVIDPID="Your monitor VID:PID:"

# Idioma chinês simplificado
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
    langChooseResOpCustom="(7) 手动输入分辨率"

    langNoMonitFound="没有找到监视器。 退出..."
    langMonitVIDPID="您的显示器 供应商ID:产品ID:"
fi

# Idioma ucraniano
if [[ "${systemLanguage}" == "uk_UA" ]]; then
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
    langChooseResOpCustom="(7) Ввести роздільну здатність вручну"

    langNoMonitFound="Моніторів не знайдено. Завершую роботу..."
    langMonitVIDPID="ID Виробника:ID пристрою твого монітора:"
fi

# Idioma português do Brasil
if [[ "${systemLanguage}" == "pt_BR" ]]; then
    langDisplay="Monitor"
    langMonitors="Monitores"
    langIndex="Índice"
    langVendorID="ID do Fabricante"
    langProductID="ID do Produto"
    langMonitorName="Nome do Monitor"
    langChooseDis="Escolha o monitor"
    langInputChoice="Digite sua escolha"
    langEnterError="Erro na entrada, saindo..."
    langBackingUp="Fazendo backup..."
    langEnabled="Ativado, reinicie o sistema."
    langDisabled="Desativado, reinicie para aplicar."
    langEnabledLog="Ao reiniciar pela primeira vez, o logo ficará gigante, depois não mudará mais."
    langCustomRes="Digite a resolução HIDPI desejada, separadas por espaço, ex.: 1680x945 1600x900 1440x810"

    langChooseIcon="Ícone do Monitor"
    langNotChange="Não alterar"

    langEnableHIDPI="(%d) Ativar HIDPI"
    langEnableHIDPIEDID="(%d) Ativar HIDPI (com EDID)"
    langDisableHIDPI="(%d) Desativar HIDPI"

    langDisableOpt1="(1) Desativar HIDPI neste monitor"
    langDisableOpt2="(2) Restaurar todas as configurações para padrão do macOS"

    langChooseRes="Configuração de resolução"
    langChooseResOp1="(1) 1920x1080 Display"
    langChooseResOp2="(2) 1920x1080 Display (usar 1424x802, corrige subescala após sleep)"
    langChooseResOp3="(3) 1920x1200 Display"
    langChooseResOp4="(4) 2560x1440 Display"
    langChooseResOp5="(5) 3000x2000 Display"
    langChooseResOp6="(6) 3440x1440 Display"
    langChooseResOpCustom="(7) Inserir resolução manualmente"

    langNoMonitFound="Nenhum monitor encontrado. Saindo..."
    langMonitVIDPID="VID:PID do monitor:"
fi
########################################
# Parte 2/4 - Detecção de monitores e EDID
########################################

# Função para detectar monitores conectados
detect_monitors() {
    monitors=($(system_profiler SPDisplaysDataType | grep "Display Type" | awk -F": " '{print $2}'))
    if [ ${#monitors[@]} -eq 0 ]; then
        echo "$langNoMonitFound"
        exit 1
    fi
}

# Função para listar monitores com índices
list_monitors() {
    echo "======================================"
    for i in "${!monitors[@]}"; do
        echo "[$i] ${monitors[$i]}"
    done
    echo "======================================"
}

# Função para obter VID:PID de um monitor específico
get_vid_pid() {
    monitor_index=$1
    vidpid=$(ioreg -lw0 | grep -A7 IODisplayConnect | grep -E "DisplayVendorID|DisplayProductID" | awk '{print $5}' | sed -n "$((monitor_index+1))p" | tr '\n' ':')
    echo "$langMonitVIDPID $vidpid"
}

# Função para backup de EDID
backup_edid() {
    backup_dir="${currentDir}/EDID_backup"
    mkdir -p "$backup_dir"
    chmod 777 "$backup_dir"
    for i in "${!monitors[@]}"; do
        edid_file="${backup_dir}/monitor_${i}_EDID.bin"
        ioreg -lw0 | grep -A64 IODisplayEDID | grep -E "IODisplayEDID" | awk '{print $5}' | xxd -r -p > "$edid_file"
        echo "Backup do monitor $i salvo em $edid_file"
    done
    echo "$langBackingUp"
}

# Função para escolher monitor
choose_monitor() {
    list_monitors
    read -p "$langInputChoice: " choice
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -ge "${#monitors[@]}" ]; then
        echo "$langEnterError"
        exit 1
    fi
    selected_monitor=${monitors[$choice]}
    echo "Você selecionou: $selected_monitor"
    get_vid_pid "$choice"
}

# Detecta monitores automaticamente
detect_monitors

# Escolhe monitor
choose_monitor
########################################
# Parte 3/4 - Configuração HIDPI e resoluções
########################################

# Função para escolher ícone do monitor
choose_icon() {
    echo "-------------------------------------"
    echo "|********** ${langChooseIcon} ***********|"
    echo "-------------------------------------"
    echo "(1) iMac"
    echo "(2) MacBook"
    echo "(3) MacBook Pro"
    echo "(4) LG ${langDisplay}"
    echo "(5) Pro Display XDR"
    echo "(6) ${langNotChange}"
    echo ""

    read -p "${langInputChoice} [1~6]: " logo
    case $logo in
        1)
            icon_file="iMac.icns"
            ;;
        2)
            icon_file="MacBook.icns"
            ;;
        3)
            icon_file="MacBookPro.icns"
            ;;
        4)
            icon_file="LG.icns"
            ;;
        5)
            icon_file="ProDisplayXDR.icns"
            ;;
        6)
            icon_file=""
            ;;
        *)
            echo "${langEnterError}"
            exit 1
            ;;
    esac

    if [[ -n "$icon_file" ]]; then
        echo "Ícone escolhido: $icon_file"
    fi
}

# Função para criar resoluções HIDPI
create_resolutions() {
    resolutions=("$@")
    echo "<array>" >> "${dpiFile}"
    for res in "${resolutions[@]}"; do
        width=$(echo $res | cut -d x -f 1)
        height=$(echo $res | cut -d x -f 2)
        hidpi=$(printf '%08x %08x' $((width*2)) $((height*2)) | xxd -r -p | base64)
        echo "        <data>${hidpi:0:11}AAAAB</data>" >> "${dpiFile}"
    done
    echo "</array>" >> "${dpiFile}"
}

# Função para resolução customizada
custom_res() {
    echo "$langCustomRes"
    read -p ": " input_resolutions
    IFS=' ' read -r -a resolution_array <<< "$input_resolutions"
    create_resolutions "${resolution_array[@]}"
}

# Função para ativar HIDPI
enable_hidpi() {
    choose_icon
    dpiFile="${currentDir}/tmp/DisplayVendorID-${Vid}/DisplayProductID-${Pid}"
    mkdir -p "$(dirname "$dpiFile")"
    touch "$dpiFile"
    
    echo "<?xml version='1.0' encoding='UTF-8'?>" > "$dpiFile"
    echo "<plist version='1.0'><dict>" >> "$dpiFile"
    echo "<key>DisplayVendorID</key><integer>$Vid</integer>" >> "$dpiFile"
    echo "<key>DisplayProductID</key><integer>$Pid</integer>" >> "$dpiFile"

    echo "Escolha uma resolução:"
    echo "$langChooseResOp1"
    echo "$langChooseResOp2"
    echo "$langChooseResOp3"
    echo "$langChooseResOp4"
    echo "$langChooseResOp5"
    echo "$langChooseResOp6"
    echo "$langChooseResOpCustom"
    read -p "$langInputChoice: " res

    case $res in
        1) create_resolutions 1680x945 1440x810 1280x720 ;;
        2) create_resolutions 1680x945 1424x802 1280x720 ;;
        3) create_resolutions 1920x1200 1680x1050 1440x900 ;;
        4) create_resolutions 2560x1440 2048x1152 1920x1080 ;;
        5) create_resolutions 3000x2000 2880x1920 2250x1500 ;;
        6) create_resolutions 3440x1440 2752x1152 2580x1080 ;;
        7) custom_res ;;
        *) echo "$langEnterError"; exit 1 ;;
    esac

    echo "</dict></plist>" >> "$dpiFile"
    echo "$langEnabled"
}

# Função para desativar HIDPI
disable_hidpi() {
    echo ""
    echo "$langDisableOpt1"
    echo "$langDisableOpt2"
    echo ""
    read -p "$langInputChoice [1~2]: " input
    case $input in
        1)
            sudo rm -rf "${targetDir}/DisplayVendorID-${Vid}"
            ;;
        2)
            sudo rm -rf "$targetDir"
            ;;
        *) echo "$langEnterError"; exit 1 ;;
    esac
    echo "$langDisabled"
}

# Função para aplicar HIDPI com patch (para EDID)
enable_hidpi_patch() {
    enable_hidpi
    # Ajusta EDID e checksum
    version=${EDID:38:2}
    basicparams=${EDID:40:2}
    checksum=${EDID:254:2}
    newchecksum=$(printf '%x' $((0x$checksum + 0x$version + 0x$basicparams - 0x04 - 0x90)) | tail -c 2)
    newedid=${EDID:0:38}0490${EDID:42:6}e6${EDID:50:204}${newchecksum}
    EDid=$(printf ${newedid} | xxd -r -p | base64)
    sed -i "" "s:EDid:${EDid}:g" ${dpiFile}
    echo "$langEnabledLog"
}
########################################
# Parte 4/4 - Finalização e execução
########################################

# Função para aplicar e finalizar
finalize() {
    sudo mkdir -p "${targetDir}/DisplayVendorID-${Vid}"
    sudo cp -r "${currentDir}/tmp/DisplayVendorID-${Vid}/"* "${targetDir}/DisplayVendorID-${Vid}/"
    
    # Ajusta permissões
    sudo chown -R root:wheel "${targetDir}/DisplayVendorID-${Vid}"
    sudo chmod -R 0755 "${targetDir}/DisplayVendorID-${Vid}"
    
    # Ativa HIDPI no sistema
    sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool YES
    
    echo "$langEnabled"
    echo "$langEnabledLog"
}

# Função principal para escolher ação
start() {
    echo ""
    echo "1) ${langEnableHIDPI}"
    if [[ $is_applesilicon == false ]]; then
        echo "2) ${langEnableHIDPIEDID}"
        echo "3) ${langDisableHIDPI}"
    else
        echo "2) ${langDisableHIDPI}"
    fi

    read -p "$langInputChoice [1~3]: " input
    if [[ $is_applesilicon == true ]]; then
        case $input in
            1) enable_hidpi ;;
            2) disable_hidpi ;;
            *) echo "$langEnterError"; exit 1 ;;
        esac
    else
        case $input in
            1) enable_hidpi ;;
            2) enable_hidpi_patch ;;
            3) disable_hidpi ;;
            *) echo "$langEnterError"; exit 1 ;;
        esac
    fi
    finalize
}

# Diretório atual
currentDir="$(cd $(dirname -- "$0") && pwd)"

# Diretorio de Overrides do macOS
targetDir="/Library/Displays/Contents/Resources/Overrides"

# Verifica arquitetura
is_applesilicon=$([[ "$(uname -m)" == "arm64" ]] && echo true || echo false)

# Mensagens padrão em Português do Brasil
langDisplay="Monitor"
langMonitors="Monitores"
langIndex="Índice"
langVendorID="ID do Fabricante"
langProductID="ID do Produto"
langMonitorName="Nome do Monitor"
langChooseDis="Escolha o monitor"
langInputChoice="Digite sua escolha"
langEnterError="Entrada inválida. Saindo..."
langBackingUp="Fazendo backup..."
langEnabled="HIDPI ativado com sucesso!"
langDisabled="HIDPI desativado. Reinicie para aplicar."
langEnabledLog="Após o primeiro boot, o logo pode ficar grande, depois normaliza."
langCustomRes="Digite a resolução HIDPI, separadas por espaço, ex: 1680x945 1600x900 1440x810"
langChooseIcon="Escolha o ícone do monitor"
langNotChange="Não alterar"
langEnableHIDPI="Ativar HIDPI"
langEnableHIDPIEDID="Ativar HIDPI (com EDID)"
langDisableHIDPI="Desativar HIDPI"
langDisableOpt1="(1) Desativar HIDPI neste monitor"
langDisableOpt2="(2) Restaurar todas as configurações padrão do macOS"
langChooseRes="Configuração de resolução"
langChooseResOp1="(1) 1920x1080 Display"
langChooseResOp2="(2) 1920x1080 Display (usar 1424x802)"
langChooseResOp3="(3) 1920x1200 Display"
langChooseResOp4="(4) 2560x1440 Display"
langChooseResOp5="(5) 3000x2000 Display"
langChooseResOp6="(6) 3440x1440 Display"
langChooseResOpCustom="(7) Entrada manual de resolução"
langNoMonitFound="Nenhum monitor encontrado. Saindo..."
langMonitVIDPID="VID:PID do seu monitor:"

# Inicia script
start
