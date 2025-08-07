#!/data/data/com.termux/files/usr/bin/bash

# === KONFIGURASI ===
PKG_NAME="com.roblox.client"
LOG_FILE="$HOME/roblox_log.txt"
WEBHOOK_URL="https://discord.com/api/webhooks/1363321007389020200/l6y9LMQzwcFu15uiQfC8XawlcqixNLukLcPoREBXyXYNqK9mFwGRW6qbgNJYmCTi9v_f"

# === FUNGSI ===
send_discord() {
  curl -s -X POST -H "Content-Type: application/json" \
    -d "{\"content\": \"$1\"}" "$WEBHOOK_URL" > /dev/null
}

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# === MONITORING ===
prev_status="closed"
uptime_start=$(date +%s)
last_reminder=$(date +%s)
reminder_interval=$((2 * 60 * 60)) # 2 jam

while true; do
  app_status=$(dumpsys window windows | grep -i "mCurrentFocus" | grep "$PKG_NAME")

  if [ -n "$app_status" ]; then
    if [ "$prev_status" = "closed" ]; then
      send_discord "@everyone ✅ Roblox telah DIBUKA kembali."
      log "Roblox dibuka"
      prev_status="opened"
    fi

    now=$(date +%s)
    if (( now - last_reminder >= reminder_interval )); then
      uptime=$(( (now - uptime_start) / 3600 ))
      send_discord "⏱️ Reminder: Roblox aktif selama $uptime jam."
      last_reminder=$now
    fi

  else
    if [ "$prev_status" = "opened" ]; then
      send_discord "@everyone ❌ Roblox DITUTUP oleh pengguna."
      log "Roblox ditutup"
      prev_status="closed"
    fi

    # Coba buka kembali
    am start -a android.intent.action.VIEW -d "roblox://placeId=1537690962" > /dev/null 2>&1
    log "Roblox dibuka kembali via link"
    send_discord "@everyone 🚀 Membuka ulang Roblox..."
  fi

  sleep 300 # tunggu 5 menit
done    if [ "$running_duration" -ge "$MAX_RUNNING_TIME" ]; then
      echo "[!] Roblox kemungkinan stuck di tampilan disconnect!"
      send_discord "@here Roblox kemungkinan stuck di layar disconnect!"

      # Spam loop
      while true; do
        [ -f "$PING_FILE" ] && echo "[!] Ditemukan stop_spam, hentikan spam." && rm "$PING_FILE" && break
        send_discord "@here Roblox masih stuck! Periksa HP kamu!"
        sleep "$SPAM_INTERVAL"
      done

      # Reset agar loop utama bisa jalan lagi
      last_open_time=0
    fi

  else
    echo "[!] Roblox tidak aktif, membuka ulang..."
    am start -a android.intent.action.VIEW -d "$GAME_LINK"
    send_discord "@everyone Roblox tidak aktif, membuka ulang game..."
    last_open_time=0
  fi

  sleep "$CHECK_INTERVAL"
done
