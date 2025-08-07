#!/data/data/com.termux/files/usr/bin/bash
# Jalankan roblox_monitor.sh di background (jika belum jalan)

if pgrep -f roblox_monitor.sh >/dev/null; then
  echo "Script sudah berjalan."
else
  nohup bash "$HOME/roblox_monitor.sh" > /dev/null 2>&1 &
  echo "Script roblox_monitor.sh dimulai."
fi
