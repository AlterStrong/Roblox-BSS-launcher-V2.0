#!/data/data/com.termux/files/usr/bin/bash

# === KONFIGURASI ===
GAME_LINK="roblox://placeId=1537690962/"
PKG_NAME="com.roblox.client"
LOG_FILE="$HOME/roblox_log.txt"
DISCORD_WEBHOOK="https://discord.com/api/webhooks/1363321007389020200/l6y9LMQzwcFu15uiQfC8XawlcqixNLukLcPoREBXyXYNqK9mFwGRW6qbgNJYmCTi9v_f"

REMINDER_INTERVAL=$((2 * 60 * 60))  # 2 jam
PING_TIMEOUT=30  # detik

# === FUNGSI ===

send_discord() {
  local message="$1"
  curl -s -X POST -H "Content-Type: application/json" \
    -d "{\"content\": \"$message\"}" "$DISCORD_WEBHOOK" >/dev/null
}

launch_roblox() {
  am start -a android.intent.action.VIEW -d "$GAME_LINK" >/dev/null 2>&1
}

is_roblox_running() {
  dumpsys window windows | grep -i "$PKG_NAME" | grep -q "mCurrentFocus"
  return $?
}

# === MONITORING ===
echo "[$(date)] Monitoring Roblox dimulai." >> "$LOG_FILE"
last_state=""
start_time=$(date +%s)
next_reminder=$((start_time + REMINDER_INTERVAL))
spam_active=false
spam_start=0

while true; do
  now=$(date +%s)

  if is_roblox_running; then
    if [[ "$last_state" != "on" ]]; then
      echo "[$(date)] Roblox dibuka." >> "$LOG_FILE"
      send_discord "@everyone Roblox telah DIBUKA."
      last_state="on"
      start_time=$now
      next_reminder=$((now + REMINDER_INTERVAL))
    fi
  else
    if [[ "$last_state" != "off" ]]; then
      echo "[$(date)] Roblox ditutup. Membuka ulang..." >> "$LOG_FILE"
      send_discord "@everyone Roblox ditutup. Membuka ulang..."
      launch_roblox
      last_state="off"
    fi
  fi

  # Reminder setiap 2 jam
  if [[ $now -ge $next_reminder ]]; then
    if [ -f "$HOME/remove_ping.lock" ]; then
      echo "[$(date)] Reminder diblokir oleh remove_ping.lock" >> "$LOG_FILE"
    else
      uptime=$(( (now - start_time) / 3600 ))
      send_discord "Uptime Roblox: ${uptime} jam"
    fi
    next_reminder=$((now + REMINDER_INTERVAL))
  fi

  # Spam ping jika disconnect (aplikasi terbuka tapi stuck)
  if is_roblox_running && [[ "$last_state" == "on" ]]; then
    if [ ! -f "$HOME/touch_ping.lock" ]; then
      if ! $spam_active; then
        spam_active=true
        spam_start=$now
        echo "[$(date)] Mulai spam ping karena tidak ada touch_ping.lock" >> "$LOG_FILE"
      fi

      # spam jika sudah 2 jam
      if (( now - start_time >= REMINDER_INTERVAL )); then
        send_discord "@here ⚠️ Roblox kemungkinan DISCONNECT. Sentuh widget Touch Ping untuk berhenti spam."
      fi

      # stop spam otomatis jika tidak ditekan dalam 30 detik
      if (( now - spam_start >= PING_TIMEOUT )); then
        spam_active=false
        echo "[$(date)] Spam otomatis berhenti karena tidak ditekan 30 detik." >> "$LOG_FILE"
      fi
    else
      spam_active=false
      spam_start=0
    fi
  fi

  sleep 5
done
