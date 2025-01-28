#!/bin/bash

baseversion="0.2.4.2"
diretorio_script="$(dirname "$(realpath "$0")")"
PTBR="00000416"
ENUS="00000409"
user=$(whoami)
cd /home
temp_dir="/home/$user"

clear
echo -e "\e[32m                                               "
echo -e "\e[32m          _____ _____ _____ _____    _____ _____ ____  "
echo -e "\e[32m         |   __|  _  |     |_   _|  |     |     |    \\ "
echo -e "\e[32m         |__   |   __|  |  | | |    | | | |  |  |  |  |"
echo -e "\e[32m         |_____|__|  |_____| |_|    |_|_|_|_____|____/ "
echo -e "\e[31m         [$baseversion] \e[0m"
echo
echo

echo -e "\e[33m[INFO] O MOD foi executado a partir do diretório: $diretorio_script.\e[0m"

echo -e "\e[33m[INFO] Verificando atualização...\e[0m"
exec 3<>/dev/tcp/raw.githubusercontent.com/443
echo -e "GET /JempUnkn/SpotMod/refs/heads/main/version HTTP/1.1\r\nHost: raw.githubusercontent.com\r\nConnection: close\r\n\r\n" >&3
cat <&3 > "$temp_dir/version.txt"
exec 3>&-

if [[ -f "$temp_dir/version.txt" ]]; then
    # Verifica o conteúdo do arquivo para garantir que não tem bytes nulos
    version=$(cat "$temp_dir/version.txt" | tr -d '\0')  # Remove bytes nulos, se houver

    if [[ "$version" == "$baseversion" ]]; then
        echo -e "\e[31m[INFO] Versão desatualizada\e[0m"
        echo -e "\e[33m[INFO] Recomandamos baixar e utilizar a versão mais recente.\e[0m"
        sleep 5
        rm -f "$temp_dir/version.txt"
        exit
    else
        echo "Atualizado [$baseversion]"
    fi

    rm -f "$temp_dir/version.txt"
else
    echo -e "\e[31m[ERROR] Falha ao verificar atualização.\e[0m"
fi

# Detecta idioma do sistema
locale=$(locale | grep LANG | cut -d= -f2 | cut -d_ -f1)

if [[ "$locale" == "pt" ]]; then
    echo -e "\e[33m[INFO] Idioma detectado: PTBR.\e[0m"
    curl -s -o "$temp_dir/langPTBR.bash" "https://raw.githubusercontent.com/JempUnkn/SpotMod/refs/heads/main/langPTBR.bash"
    source "$temp_dir/langPTBR.sh"
    rm -f "$temp_dir/langPTBR.sh"
    exit
elif [[ "$locale" == "en" ]]; then
    echo -e "\e[33m[INFO] Idioma detectado: EN.\e[0m"

    # Baixa o arquivo de linguagem usando curl
    curl -sL "https://raw.githubusercontent.com/JempUnkn/SpotMod/refs/heads/main/langEN.bash" -o "$temp_dir/LangEN.sh"

    # Verifica se o arquivo foi baixado corretamente
    if [ ! -f "$temp_dir/LangEN.sh" ]; then
        echo -e "\e[31m[ERROR] Falha ao baixar o arquivo langEN.bash.\e[0m"
        exit 1
    fi

    # Carrega o arquivo
    source "$temp_dir/LangEN.sh"

    # Remove o arquivo temporário
    rm -f "$temp_dir/LangEN.sh"

    exit
else
    echo -e "\e[31m[ERROR] Idioma não detectado.\e[0m"
    echo -e "\e[33m[INFO] Definindo idioma padrão!\e[0m"
    curl -s -o "$temp_dir/langEN.sh" "https://raw.githubusercontent.com/JempUnkn/SpotMod/refs/heads/main/langEN.bash"
    source "$temp_dir/langEN.sh"
    rm -f "$temp_dir/langEN.sh"
    exit
fi
