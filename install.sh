#!/data/data/com.termux/files/usr/bin/bash

# Unduh semua skrip
cd $HOME
base_url="https://raw.githubusercontent.com/AlterStrong/Roblox-BSS-launcher-V2.0/main"

files=("roblox_monitor.sh" "start.sh" "stop.sh" "touch_ping.sh" "remove_ping.sh")
for file in "${files[@]}"; do
  curl -o "$file" "$base_url/$file"
  chmod +x "$file"
done

# Minta izin termux-api
termux-toast "Meminta izin..."
termux-notification --title "Roblox Monitor" --content "Pastikan izinkan akses penggunaan aplikasi & overlay."
termux-open-app com.termux
am start -a android.settings.USAGE_ACCESS_SETTINGS

echo "Setup selesai. Gunakan 'bash start.sh' untuk memulai."
