#!/data/data/com.termux/files/usr/bin/bash

# === KONFIGURASI ===
GAME_LINK="roblox://placeId=1537690962"
PKG_NAME="com.roblox.client"
LOG_FILE="$HOME/roblox_log.txt"
DISCORD_WEBHOOK="https://discord.com/api/webhooks/..."  # Ganti dengan milikmu
PING_FILE="$HOME/ping_active"

# === VARIABEL ===
last_status="unknown"
start_time=$(date +%s)
last_ping_check=$(date +%s)

send_discord() {
  local message="$1"
  curl -H "Content-Type: application/json" \
       -X POST \
       -d "{\"content\": \"$message\"}" \
       "$DISCORD_WEBHOOK" >/dev/null 2>&1
}

is_roblox_running() {
  dumpsys window windows | grep -iq "$PKG_NAME"
  return $?
}

check_ping_touched() {
  local now=$(date +%s)
  if [[ -f "$PING_FILE" ]]; then
    local last_touch=$(stat -c %Y "$PING_FILE")
    local diff=$((now - last_touch))
    if (( diff <= 30 )); then
      return 0
    fi
  fi
  return 1
}

start_spam_ping() {
  echo "[$(date)] Memulai spam ping karena 2 jam aktif." >> "$LOG_FILE"
  while true; do
    if check_ping_touched; then
      echo "[$(date)] Touch ping terdeteksi, menghentikan spam sementara." >> "$LOG_FILE"
      break
    fi
    send_discord "@here Cek HP kamu! Roblox sudah 2 jam nonstop."
    sleep 10
  done
}

echo "[$(date)] Monitoring Roblox dimulai." >> "$LOG_FILE"

while true; do
  if is_roblox_running; then
    if [[ "$last_status" != "running" ]]; then
      send_discord "@everyone Roblox dibuka."
      echo "[$(date)] Roblox dibuka." >> "$LOG_FILE"
      start_time=$(date +%s)
      last_ping_check=$start_time
      last_status="running"
    else
      now=$(date +%s)
      uptime=$((now - start_time))

      if (( uptime >= 7200 )); then
        # Sudah 2 jam
        if (( now - last_ping_check >= 7200 )); then
          start_spam_ping
          last_ping_check=$(date +%s)
        fi
      fi
    fi
  else
    if [[ "$last_status" != "stopped" ]]; then
      send_discord "@everyone Roblox ditutup."
      echo "[$(date)] Roblox ditutup." >> "$LOG_FILE"
      last_status="stopped"
    fi
    start_time=$(date +%s)
    last_ping_check=$start_time
  fi
  sleep 300
done      running_duration=0
      previous_state="open"
    fi

    sleep 5
    running_duration=$((running_duration + 5))

    if [ "$running_duration" -ge "$MAX_RUNNING_TIME" ]; then
      if [ ! -f "$PING_FLAG" ]; then
        touch "$PING_FLAG"
        log "Mulai spam ping karena sudah 1 menit"
      fi

      touch_start_time=$(date +%s)

      while [ -f "$PING_FLAG" ]; do
        send_discord "@here Sudah 1 menit (TEST)! Cek HP sekarang!"
        sleep "$SPAM_INTERVAL"

        if [ -f "$TOUCH_FILE" ]; then
          rm -f "$TOUCH_FILE"
          touch_start_time=$(date +%s)
        else
          now=$(date +%s)
          elapsed=$((now - touch_start_time))
          if [ "$elapsed" -ge "$TOUCH_TIMEOUT" ]; then
            log "Spam dihentikan karena tidak ada touch dalam 30 detik"
            rm -f "$PING_FLAG"
            running_duration=0
            break
          fi
        fi
      done
    fi

  else
    if [ "$previous_state" = "open" ]; then
      send_discord "@everyone Roblox ditutup"
      log "Roblox ditutup"
      previous_state="closed"
      running_duration=0
      rm -f "$PING_FLAG"
    fi

    log "Roblox tidak terbuka, mencoba membuka..."
    am start -a android.intent.action.VIEW -d "$GAME_LINK"
    send_discord "@everyone Roblox tidak aktif. Membuka kembali..."
    sleep 5
  fi

  sleep 295
done      echo "[$(date)] Roblox dibuka." >> "$LOG_FILE"
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
