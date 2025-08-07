#!/data/data/com.termux/files/usr/bin/bash

GAME_LINK="roblox://placeId=1537690962/"
PKG_NAME="com.roblox.client"
DISCORD_WEBHOOK="https://discord.com/api/webhooks/..."  # Ganti dengan milikmu

LOG_FILE="$HOME/roblox_log.txt"
PING_FLAG="$HOME/.roblox_ping_active"
TOUCH_FILE="$HOME/.roblox_touched"

MAX_RUNNING_TIME=$((1 * 60))  # 1 menit
SPAM_INTERVAL=10  # Detik
TOUCH_TIMEOUT=30  # Detik

running_duration=0
previous_state="closed"
last_notif_time=0

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

send_discord() {
  curl -s -X POST -H "Content-Type: application/json" \
    -d "{\"content\": \"$1\"}" "$DISCORD_WEBHOOK" >/dev/null
}

is_roblox_open() {
  dumpsys window windows | grep -qE "mCurrentFocus.+$PKG_NAME"
}

while true; do
  if is_roblox_open; then
    if [ "$previous_state" = "closed" ]; then
      send_discord "@everyone Roblox dibuka"
      log "Roblox dibuka"
      running_duration=0
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
