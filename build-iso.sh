#!/bin/bash
# ============================================
# NyxOS - ISO Build Script
# Parrot OS / Debian üzerinde çalıştır
# ============================================

set -e
set -o pipefail

echo "[*] NyxOS ISO build başlıyor..."
echo "[*] Bu işlem 20-60 dakika sürebilir."
echo ""

cd "$(dirname "$0")"

# Onceki build temizle
echo "[*] Onceki build temizleniyor..."
sudo lb clean --purge

# Config olustur (mimari, bootloader, kernel, mirror ayarlari)
# BU ADIM DAHA ONCE HIC YOKTU - vmlinuz hatasinin asil sebebi buydu.
echo "[*] live-build config olusturuluyor..."
chmod +x auto/config
sudo lb config

# Build başlat
echo "[*] ISO oluşturuluyor..."
sudo lb build 2>&1 | tee build.log

echo ""
echo "[✓] ISO başarıyla oluşturuldu!"
echo "[✓] Dosya: live-image-amd64.hybrid.iso"
echo ""
echo "USB'ye yazmak için:"
echo "  sudo dd if=live-image-amd64.hybrid.iso of=/dev/sdX bs=4M status=progress conv=fsync"
