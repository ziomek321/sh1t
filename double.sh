#!/bin/bash

# Sprawdzenie czy wget jest zainstalowany
if ! command -v wget &> /dev/null; then
    echo -e "\033[0;31m[!]\033[0m Brak pakietu wget. Próba instalacji..."
    sudo apt-get update && sudo apt-get install -y wget
fi

# Definicje kolorów
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # Reset koloru
BOLD='\033[1m'

# URL do surowych plików z GitHuba
BASE_URL="https://raw.githubusercontent.com/ziomek321/sh1t/main"
INSTALL_URL="$BASE_URL/install.sh"
BLOAT_URL="$BASE_URL/bloat.sh"

# Tworzenie unikalnego katalogu tymczasowego w /tmp
TEMP_DIR=$(mktemp -d /tmp/debian_scripts_XXXXXX)

# Trap gwarantuje, że katalog tymczasowy usunie się ZAWSZE, nawet przy Ctrl+C lub błędzie
trap 'rm -rf "$TEMP_DIR"' EXIT INT TERM

# Funkcja rysująca menu
show_menu() {
    clear
    echo -e "${CYAN}================================================================${NC}"
    echo -e "${BOLD}${GREEN}             Skrypty Debian - ziomek321                 ${NC}"
    echo -e "${CYAN}================================================================${NC}"
    echo -e "${YELLOW}  Wybierz opcję, aby kontynuować:${NC}\n"
    
    echo -e "  ${BOLD}[1]${NC} ${GREEN}▶ Uruchom install.sh${NC}"
    echo -e "  ${BOLD}[2]${NC} ${BLUE}▶ Uruchom bloat.sh${NC}"
    echo -e "  ${BOLD}[3]${NC} ${MAGENTA}▶ Uruchom OBA (install + bloat)${NC}"
    echo -e "  ${BOLD}[0]${NC} ${RED}▶ Wyjście${NC}\n"
    
    echo -e "${CYAN}----------------------------------------------------------------${NC}"
    echo -e "  ${BOLD}Kontakt / Discord:${NC} ${YELLOW}piekne.jajeczko${NC}"
    echo -e "${CYAN}================================================================${NC}"
    echo -ne "\n${BOLD}Twój wybór [0-3]: ${NC}"
}

# Funkcja pobierająca i uruchamiająca skrypty
run_scripts() {
    local run_install=$1
    local run_bloat=$2
    
    # Przechodzimy do katalogu tymczasowego
    cd "$TEMP_DIR" || exit 1

    echo -e "\n${CYAN}[*]${NC} Pobieranie skryptów do katalogu tymczasowego ($TEMP_DIR)..."
    
    if [ "$run_install" = true ]; then
        echo -e "${GREEN}[+]${NC} Pobieranie install.sh..."
        wget -q -O install.sh "$INSTALL_URL"
        chmod +x install.sh
    fi
    
    if [ "$run_bloat" = true ]; then
        echo -e "${GREEN}[+]${NC} Pobieranie bloat.sh..."
        wget -q -O bloat.sh "$BLOAT_URL"
        chmod +x bloat.sh
    fi

    echo -e "${CYAN}[*]${NC} Uruchamianie wybranych skryptów...\n"
    sleep 1

    if [ "$run_install" = true ]; then
        echo -e "${BOLD}${GREEN}--- Uruchamianie install.sh ---${NC}"
        bash ./install.sh
        echo -e "\n"
    fi

    if [ "$run_bloat" = true ]; then
        echo -e "${BOLD}${BLUE}--- Uruchamianie bloat.sh ---${NC}"
        bash ./bloat.sh
        echo -e "\n"
    fi

    # Czyszczenie zawartości temp po wykonaniu, przed powrotem do menu
    rm -rf "$TEMP_DIR"/*
    
    echo -e "${GREEN}[✔]${NC} Gotowe! Pliki tymczasowe usunięte. Naciśnij ENTER, aby wrócić do menu..."
    read -r
}

# Pętla główna programu
while true; do
    show_menu
    read -r choice
    case $choice in
        1)
            run_scripts true false
            ;;
        2)
            run_scripts false true
            ;;
        3)
            run_scripts true true
            ;;
        0)
            echo -e "\n${YELLOW}Do zobaczenia!${NC}"
            exit 0
            ;;
        *)
            echo -e "\n${RED}[!]${NC} Nieprawidłowy wybór. Spróbuj ponownie."
            sleep 1.5
            ;;
    esac
done
