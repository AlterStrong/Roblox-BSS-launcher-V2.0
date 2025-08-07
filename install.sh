#!/data/data/com.termux/files/usr/bin/bash

# === Konfigurasi repo ===
REPO_URL="https://raw.githubusercontent.com/AlterStrong/Roblox-BSS-launcher-V2.0/main"

# === Buat folder shortcuts jika belum ada ===
mkdir -p ~/.shortcuts

# === Unduh semua skrip ===
curl -o "$HOME/roblox_monitor.sh" "$REPO_URL/roblox_monitor.sh"
curl -o "$HOME/start.sh" "$REPO_URL/start.sh"
curl -o "$HOME/stop.sh" "$REPO_URL/stop.sh"
curl -o "$HOME/touch_ping.sh" "$REPO_URL/touch_ping.sh"
curl -o "$HOME/remove_ping.sh" "$REPO_URL/remove_ping.sh"

# === Beri izin eksekusi ===
chmod +x "$HOME/"*.sh

# === Pindahkan ke folder shortcut untuk Termux Widget ===
mv "$HOME/start.sh" "$HOME/stop.sh" "$HOME/touch_ping.sh" "$HOME/remove_ping.sh" "$HOME/.shortcuts/"

echo "✅ Semua skrip telah diinstal dan shortcut telah disiapkan di Termux Widget."
