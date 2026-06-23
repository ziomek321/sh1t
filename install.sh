#!/bin/bash
echo 'welcome to my installer!'

cd ~/Pulpit
wget https://github.com/PrismLauncher/PrismLauncher/releases/download/9.4/PrismLauncher-Linux-x86_64.AppImage
mkdir -p ~/.local/share/PrismLauncher/instances/
echo '{"accounts": [{"entitlement": {"canPlayMinecraft": true,"ownsMinecraft": true},"type": "MSA"}],"formatVersion": 3}' > ~/.local/share/PrismLauncher/accounts.json
echo 'instalation done | by https://ziomek321.github.io'
echo 'if u like my script join https://discord.gg/sYphRUeaVC'
echo 'thx for use | i dont add any rat virus its just my auto download script'
read -p "Wanna install this shit?(MODDED FO MODPACK FROM https://github.com/ziomek321/fo-down  ) (y/N): " choice
[[ "${choice,,}" == "y" ]] && echo "Instalowanie..." && mkdir -p ~/.local/share/PrismLauncher/instances/ && cd ~/.local/share/PrismLauncher/instances/ && wget https://github.com/ziomek321/fo-down/raw/refs/heads/main/fodown.mrpack
[[ "${choice,,}" != "y" ]] && echo "Anulowano."
