#!/bin/bash

# Definir o diretório do script
diretorio_script=$(dirname "$0")

# Definir cores para as mensagens
yellow="\033[1;33m"
green="\033[1;32m"
cyan="\033[1;36m"
red="\033[1;31m"
reset="\033[0m"

# Exibir data e hora
hora=$(date +"%H")
minuto=$(date +"%M")
dia=$(date +"%d")
mes=$(date +"%m")
ano=$(date +"%Y")

echo -e "${cyan}[LOG] Processo Iniciado às ${hora}:${minuto} em ${dia}/${mes}/${ano}${reset}"

# Verifica se o diretório de logs do Spotify existe, caso contrário cria
if [ ! -d "$HOME/SpotifyLog" ]; then
    mkdir "$HOME/SpotifyLog"
    if [ $? -ne 0 ]; then
        echo -e "${red}[Error]: Falha ao criar o diretório Log para o SpotMod${reset}"
        exit 1
    else
        echo -e "${green}[INFO] Diretório Log criado com sucesso!${reset}"
    fi
else
    echo "Processo Iniciado às ${hora}:${minuto} no dia ${dia}/${mes}/${ano}" >> "$HOME/SpotifyLog/Log.txt"
fi

# Baixar imagem de teste
curl -s https://itigic.com/wp-content/uploads/2020/01/ping-command.jpg --output "$HOME/net.jpg"
if [ $? -ne 0 ]; then
    echo -e "${red}Desconectado de uma rede${reset}"
    exit 1
else
    echo -e "${green}[INFO] Conectado a uma rede....${reset}"
    rm "$HOME/net.jpg"
fi

# Script temporário em VBScript (salvando como arquivo)
echo "Set objShell = CreateObject(\"WScript.Shell\")" > temp.vbs
echo "resposta = objShell.Popup(\"Deseja Injectar?\", 0, \"Marketplace\", 4)" >> temp.vbs
echo "If resposta = 6 Then WScript.Quit(0)" >> temp.vbs
echo "If resposta = 7 Then WScript.Quit(1)" >> temp.vbs

# Executa o VBScript e captura o código de saída
cscript //nologo temp.vbs
exitCode=$?

# Aguarda o término da execução do VBScript antes de proceder
if [ $exitCode -eq 0 ]; then
    echo -e "${yellow}[INFO] Continuando o processo...${reset}"
else
    echo -e "${red}[CANCELANDO...]${reset}"
    rm temp.vbs
    exit 1
fi

# Exclui o arquivo temporário
rm temp.vbs

# Verifica se o Spotify está instalado
echo -e "${cyan}[INFO] Verificando se o Spotify está instalado${reset}"
if [ -f "$HOME/.config/spotify/Spotify.exe" ]; then
    echo -e "${green}[INFO] Spotify Instalado${reset}"
else
    echo -e "${yellow}[INFO] Spotify não instalado!${reset}"
    sleep 3
    echo -e "${cyan}[INFO] Procurando o executável do Spotify...${reset}"

    if [ ! -f "$HOME/Downloads/SpotifySetup.exe" ]; then
        echo -e "${red}[INFO] Executável do Spotify não encontrado!${reset}"
        echo -e "${yellow}[INFO] Baixando o Spotify...${reset}"
        mkdir -p $HOME/temp/spotmod
        curl -O https://download.scdn.co/SpotifySetup.exe -o $HOME/temp/spotmod/SpotifySetup.exe
        echo -e "${cyan}[INFO] Baixando & Instalando o Spotify...${reset}"
        sudo $HOME/temp/spotmod/SpotifySetup.exe
        rm -rf $HOME/temp/spotmod
        echo -e "${green}[INFO] Spotify instalado com sucesso!${reset}"
        echo -e "${yellow}[IMPORTANT] Faça login numa conta do Spotify antes de continuar!${reset}"
        sleep 7
        echo -e "[Pressione qualquer tecla para continuar]"
    else
        echo -e "${green}[INFO] Executável do Spotify já encontrado.${reset}"
        curl -O https://download.scdn.co/SpotifySetup.exe -o $HOME/Downloads/SpotifySetup.exe
        echo -e "${cyan}[INFO] Baixando & Instalando o Spotify...${reset}"
        sudo $HOME/Downloads/SpotifySetup.exe
        echo -e "${green}[INFO] Spotify instalado com sucesso!${reset}"
        echo -e "${yellow}[IMPORTANT] Faça login numa conta do Spotify antes de continuar!${reset}"
        sleep 7
        echo -e "[Pressione qualquer tecla para continuar]"
    fi
fi

# Continuar o processo
echo -e "${yellow}[INFO] Continuando o processo...${reset}"

# Verificar se o spicetify está instalado
spicetify --help &>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${green}[INFO] Spicetify Detectado.${reset}"
    echo -e "${yellow}[UPDATING...]${reset}"
    spicetify update
else
    echo -e "${yellow}[INFO] Spicetify não Detectado.${reset}"
fi

# Finalizar o processo
echo -e "${green}[INFO] Concluído com sucesso!${reset}"
echo -e "Reabrindo o Spotify"
exit 0
