#!/data/data/com.termux/files/usr/bin/bash

# === KONFIGURASI ===
GAME_LINK="roblox://placeId=1537690962"
PKG_NAME="com.roblox.client"
DISCORD_WEBHOOK="https://discord.com/api/webhooks/1363321007389020200/l6y9LMQzwcFu15uiQfC8XawlcqixNLukLcPoREBXyXYNqK9mFwGRW6qbgNJYmCTi9v_f"
CHECK_INTERVAL=300  # 5 menit (dalam detik)
MAX_RUNNING_TIME=$((2 * 60 * 60))  # 2 jam dalam detik
SPAM_INTERVAL=10  # Spam ping setiap 10 detik
LOG_FILE="$HOME/roblox_monitor_log.txt"

# === FUNGSI ===
send_discord() {
  curl -s -X POST -H "Content-Type: application/json" \
    -d "{\"content\": \"$1\"}" "$DISCORD_WEBHOOK" > /dev/null
}

is_roblox_running() {
  dumpsys window windows | grep -i "$PKG_NAME" > /dev/null 2>&1
  return $?
}

# === LOOP MONITORING ===
echo "[$(date)] Monitoring Roblox dimulai..." >> "$LOG_FILE"
send_discord "@everyone Skrip monitoring Roblox telah AKTIF."

start_time=0
already_opened=false
spam_active=false

while true; do
  if is_roblox_running; then
    if [ "$already_opened" = false ]; then
      already_opened=true
      start_time=$(date +%s)
      send_discord "@everyone Roblox telah DIBUKA!"
      echo "[$(date)] Roblox dibuka." >> "$LOG_FILE"
    fi

    current_time=$(date +%s)
    running_duration=$((current_time - start_time))

    # Uptime reminder setiap 2 jam
    if (( running_duration % 7200 < CHECK_INTERVAL )); then
      uptime_hours=$((running_duration / 3600))
      send_discord "Reminder: Roblox sudah terbuka selama ${uptime_hours} jam."
    fi

    # Jika lebih dari MAX_RUNNING_TIME (2 jam nonstop)
    if (( running_duration >= MAX_RUNNING_TIME )); then
      if [ -f "$HOME/stop_ping" ]; then
        echo "[$(date)] Ping dihentikan oleh file stop_ping." >> "$LOG_FILE"
        spam_active=false
      elif [ "$spam_active" = false ]; then
        spam_active=true
        send_discord "@here Roblox kemungkinan STUCK DI LAYAR DISCONNECT! Mulai spam ping setiap 10 detik."
        echo "[$(date)] Mulai spam ping." >> "$LOG_FILE"
      fi

      while [ "$spam_active" = true ]; do
        if ! is_roblox_running || [ -f "$HOME/stop_ping" ]; then
          spam_active=false
          echo "[$(date)] Spam ping dihentikan." >> "$LOG_FILE"
          break
        fi
        send_discord "@here Roblox masih terbuka lebih dari 2 jam! Periksa perangkatmu!"
        sleep "$SPAM_INTERVAL"
      done
    fi

  else
    if [ "$already_opened" = true ]; then
      already_opened=false
      send_discord "@everyone Roblox DITUTUP atau CRASH!"
      echo "[$(date)] Roblox tidak aktif." >> "$LOG_FILE"
    fi

    send_discord "@everyone Roblox tidak aktif, membuka ulang game..."
    monkey -p "$PKG_NAME" -c android.intent.category.LAUNCHER 1
    am start -a android.intent.action.VIEW -d "$GAME_LINK"
    sleep 5
  fi

  sleep "$CHECK_INTERVAL"
done      send_discord "⏱️ Reminder: Roblox aktif selama $uptime jam."
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
