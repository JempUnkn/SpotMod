#!/bin/bash

# Definir o diretório do script
diretorio_script=$(dirname "$(realpath "$0")")

# Cores
YELLOW='\033[33m'
GREEN='\033[32m'
CYAN='\033[36m'
RED='\033[31m'
RESET='\033[0m'

# Exibe a hora e data
day=$(date +%d)
month=$(date +%m)
year=$(date +%Y)
hour=$(date +%H)
minute=$(date +%M)

echo -e "${CYAN}[LOG] Process Started at $hour:$minute on $day/$month/$year${RESET}"

# Verifica se o diretório de log existe
log_dir="$HOME/SpotifyLog"
log_file="$log_dir/Log.txt"

if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
    if [ $? -ne 0 ]; then
        echo -e "${RED}[Error]: Attempt to create Log Directory${RESET}"
        exit 1
    else
        echo -e "${GREEN}[INFO] Log Directory created successfully!${RESET}"
    fi
else
    echo "Process Started $hour:$minute on $day/$month/$year" >> "$log_file"
fi

# Verifica a conexão de rede
wget -q --spider https://itigic.com/wp-content/uploads/2020/01/ping-command.jpg
if [ $? -ne 0 ]; then
    echo -e "${RED}[Error]: No Internet${RESET}"
    exit 1
else
    echo -e "${GREEN}[INFO] Connected to a network....${RESET}"
    rm -f "$HOME/net.jpg" > /dev/null
fi

# Exemplo de prompt de injeção (simulado)
echo -e "${CYAN}Do you want to inject? (y/n)${RESET}"
read -r response
if [[ "$response" != "y" && "$response" != "Y" ]]; then
    echo -e "${RED}[CANCELLED...]${RESET}"
    exit
fi

# Verificação do Spotify
echo -e "${CYAN}[INFO] Checking if Spotify is installed${RESET}"
if [ -f "$HOME/.config/spotify/spotify" ]; then
    echo -e "${GREEN}[INFO] Spotify installed${RESET}"
else
    echo -e "${YELLOW}[INFO] Spotify not installed!${RESET}"

    # Baixa e instala o Spotify
    echo -e "${CYAN}[INFO] Searching for Spotify executable...${RESET}"
    if [ ! -f "$HOME/Downloads/SpotifySetup.exe" ]; then
        echo -e "${RED}[INFO] Spotify executable not found!${RESET}"
        echo -e "${YELLOW}[INFO] Downloading Spotify...${RESET}"
        wget https://download.scdn.co/SpotifySetup.exe -O "$HOME/Downloads/SpotifySetup.exe"
        echo -e "${CYAN}[INFO] Installing Spotify...${RESET}"
        wine "$HOME/Downloads/SpotifySetup.exe"
        echo -e "${GREEN}[INFO] Spotify installed successfully!${RESET}"
    else
        echo -e "${GREEN}[INFO] Spotify executable already found.${RESET}"
    fi
fi

# Verifica se o Spicetify está instalado
spicetify --help &> /dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[INFO] Spicetify detected.${RESET}"
    echo -e "${YELLOW}[UPDATING...]${RESET}"
    spicetify update
else
    echo -e "${YELLOW}[INFO] Spicetify not detected.${RESET}"
fi

# Baixa o arquivo de licença
echo -e "${CYAN}[INFO] Downloading License${RESET}"
wget -q https://raw.githubusercontent.com/JempUnkn/SpotMod/refs/heads/main/License.html -O "$TEMP_DIR/License.html"
xdg-open "$TEMP_DIR/License.html"
rm -f "$TEMP_DIR/License.html"
exit
