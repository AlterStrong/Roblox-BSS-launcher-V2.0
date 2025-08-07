#!/data/data/com.termux/files/usr/bin/bash

chmod +x roblox_monitor.sh
pkill -f roblox_monitor.sh > /dev/null 2>&1
nohup ./roblox_monitor.sh > /dev/null 2>&1 &
echo "[*] Monitoring Roblox dimulai..."
