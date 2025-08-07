#!/data/data/com.termux/files/usr/bin/bash

cd "$HOME"
FILES=(roblox_monitor.sh start.sh stop.sh touch_ping.sh remove_ping.sh)

for file in "${FILES[@]}"; do
  curl -o "$file" "https://raw.githubusercontent.com/AlterStrong/Roblox-BSS-launcher-V2.0/main/$file"
  chmod +x "$file"
done

mkdir -p "$HOME/.shortcuts"
mv touch_ping.sh "$HOME/.shortcuts/"
mv remove_ping.sh "$HOME/.shortcuts/"

termux-reload-settings
echo "Install selesai. Shortcut sudah tersedia di Termux Widget."
