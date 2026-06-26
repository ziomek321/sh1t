#!/usr/bin/env bash
set -euo pipefail

mkdir -p ~/.local/share/PrismLauncher
echo '{"accounts": [{"entitlement": {"canPlayMinecraft": true,"ownsMinecraft": true},"type": "MSA"}],"formatVersion": 3}' > ~/.local/share/PrismLauncher/accounts.json


clear

PRISM_URL="https://github.com/PrismLauncher/PrismLauncher/releases/download/9.4/PrismLauncher-Linux-x86_64.AppImage"
MRPACK_URL="https://raw.githubusercontent.com/ziomek321/fo-down/main/fodown.mrpack"

PRISM_ROOT="$HOME/.local/share/PrismLauncher"
DESKTOP_DIR="${XDG_DESKTOP_DIR:-}"

if [ -z "${DESKTOP_DIR}" ]; then
    if command -v xdg-user-dir >/dev/null 2>&1; then
        DESKTOP_DIR="$(xdg-user-dir DESKTOP 2>/dev/null || true)"
    fi
fi

if [ -z "${DESKTOP_DIR:-}" ] || [ ! -d "$DESKTOP_DIR" ]; then
    if [ -d "$HOME/Pulpit" ]; then
        DESKTOP_DIR="$HOME/Pulpit"
    else
        DESKTOP_DIR="$HOME/Desktop"
    fi
fi

mkdir -p "$DESKTOP_DIR"
mkdir -p "$PRISM_ROOT/instances"

PRISM_BIN="$DESKTOP_DIR/prism"
DESKTOP_FILE="$DESKTOP_DIR/Prism.desktop"
MRPACK_FILE="$DESKTOP_DIR/fodown.mrpack"

die() {
    echo "Blad: $*" >&2
    exit 1
}

info() {
    echo "[INFO] $*"
}

need() {
    command -v "$1" >/dev/null 2>&1 || die "Brak wymaganego programu: $1"
}

need wget
need chmod
need cat
need read

echo "======================================"
echo "        FO MODPACK INSTALLER"
echo "======================================"
echo

info "Pobieranie Prism 9.4..."
wget -O "$PRISM_BIN" "$PRISM_URL"
chmod +x "$PRISM_BIN"

info "Tworzenie skrótu na pulpicie..."
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Prism
Comment=Uruchom Prism Launcher
Exec=$PRISM_BIN
Terminal=false
Categories=Game;
StartupNotify=true
EOF
chmod +x "$DESKTOP_FILE"

echo
read -r -p "Czy chcesz zainstalowac FO Down? (t/N): " choice
choice="${choice,,}"

if [[ "$choice" == "t" || "$choice" == "tak" || "$choice" == "y" || "$choice" == "yes" ]]; then
    info "Pobieranie FO Down..."
    wget -O "$MRPACK_FILE" "$MRPACK_URL"

    info "Importowanie modpacka do PrismLaunchera..."
    "$PRISM_BIN" -d "$PRISM_ROOT" -I "$MRPACK_FILE"

    echo
    echo "FO Down zostal zaimportowany."
else
    echo
    echo "Pominięto FO Down."
fi

echo
echo "Gotowe."
echo "Prism: $PRISM_BIN"
echo "Skrót: $DESKTOP_FILE"
