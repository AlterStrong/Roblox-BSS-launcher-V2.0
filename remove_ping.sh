#!/data/data/com.termux/files/usr/bin/bash
# Menghapus file indikator agar spam bisa aktif kembali saat waktunya

rm -f "$HOME/touch_ping.txt"
echo "Touch ping dihapus (spam bisa aktif kembali)"
