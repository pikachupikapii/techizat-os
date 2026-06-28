#!/bin/bash
# ============================================
# NyxOS - ISO Build Script
# Parrot OS / Debian üzerinde çalıştır
# ============================================

set -e

echo "[*] NyxOS ISO build başlıyor..."
echo "[*] Bu işlem 20-60 dakika sürebilir."
echo ""

cd "$(dirname "$0")"

# Önceki build temizle
echo "[*] Önceki build temizleniyor..."
sudo lb clean

# Build başlat
echo "[*] ISO oluşturuluyor..."
sudo lb build 2>&1 | tee build.log

echo ""
echo "[✓] ISO başarıyla oluşturuldu!"
echo "[✓] Dosya: live-image-amd64.hybrid.iso"
echo ""
echo "USB'ye yazmak için:"
echo "  sudo dd if=live-image-amd64.hybrid.iso of=/dev/sdX bs=4M status=progress conv=fsync"