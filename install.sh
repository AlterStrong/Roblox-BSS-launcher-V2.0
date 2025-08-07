#!/data/data/com.termux/files/usr/bin/bash

echo "[*] Menginstal dependency..."
pkg update -y
pkg install -y termux-api curl jq

echo "[*] Meminta izin akses storage..."
termux-setup-storage

echo "[*] Instalasi selesai. Jalankan ./start.sh untuk mulai."
