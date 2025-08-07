#!/data/data/com.termux/files/usr/bin/bash

# === KONFIGURASI ===
GAME_LINK="roblox://placeId=1537690962"
PKG_NAME="com.roblox.client"
DISCORD_WEBHOOK="https://discord.com/api/webhooks/1363321007389020200/l6y9LMQzwcFu15uiQfC8XawlcqixNLukLcPoREBXyXYNqK9mFwGRW6qbgNJYmCTi9v_f"
CHECK_INTERVAL=300  # 5 menit
SPAM_INTERVAL=10
MAX_RUNNING_TIME=360  # 6 menit untuk deteksi freeze
PING_FILE="$HOME/stop_spam"

last_open_time=0
already_notified=0

send_discord() {
  curl -s -H "Content-Type: application/json" \
    -X POST -d "{\"content\": \"$1\"}" "$DISCORD_WEBHOOK" > /dev/null
}

is_roblox_running() {
  dumpsys window windows | grep -i "$PKG_NAME" > /dev/null 2>&1
  return $?
}

while true; do
  timestamp=$(date +%s)

  if is_roblox_running; then
    echo "[✓] Roblox sedang berjalan..."

    if [ "$last_open_time" -eq 0 ]; then
      last_open_time=$timestamp
    fi

    # Deteksi apakah stuck terlalu lama
    running_duration=$((timestamp - last_open_time))
    if [ "$running_duration" -ge "$MAX_RUNNING_TIME" ]; then
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
