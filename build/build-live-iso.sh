#!/bin/bash
# Techizat OS Live Boot ISO Builder
# Hybrid ISO olusturucu

set -e

echo "[*] TECHIZAT OS - Live ISO Builder Basliyor..."
echo ""

# Konfigurasyonlar
BUILD_DIR="${PWD}/build/live-build"
OUTPUT_DIR="${PWD}/build/output"

# Root kontrolu
if [[ $EUID -ne 0 ]]; then
    echo "[!] Bu script root olarak calistirilmalidir"
    echo "    Calistir: sudo $0"
    exit 1
fi

# Kontroller
if [ ! -d "${BUILD_DIR}" ]; then
    echo "[!] Build dizini bulunamadi: ${BUILD_DIR}"
    echo "    Once calistir: bash build/live-build-setup.sh"
    exit 1
fi

mkdir -p "${OUTPUT_DIR}"

echo "[*] Adim 1: Tema dosyalari hazirlaniyot..."
mkdir -p "${BUILD_DIR}/config/includes.chroot/usr/share/themes"
cp -r "${PWD}/design/themes/techizat-gtk" "${BUILD_DIR}/config/includes.chroot/usr/share/themes/" 2>/dev/null || true
cp "${PWD}/design/wallpapers"/* "${BUILD_DIR}/config/includes.chroot/usr/share/pixmaps/" 2>/dev/null || true
cp "${PWD}/design/logos"/* "${BUILD_DIR}/config/includes.chroot/usr/share/pixmaps/" 2>/dev/null || true
echo "[+] Tema dosyalari hazirlanma tamamlandi"

echo "[*] Adim 2: GRUB yapilaniyor..."
mkdir -p "${BUILD_DIR}/config/includes.chroot/boot/grub"
cp "${PWD}/grub/grub-theme/grub.cfg" "${BUILD_DIR}/config/includes.chroot/boot/grub/" 2>/dev/null || true
echo "[+] GRUB yapilandi"

echo "[*] Adim 3: LightDM yapilaniyor..."
mkdir -p "${BUILD_DIR}/config/includes.chroot/etc/lightdm"
cp "${PWD}/lightdm/techizat-greeter.conf" "${BUILD_DIR}/config/includes.chroot/etc/lightdm/lightdm.conf" 2>/dev/null || true
echo "[+] LightDM yapilandi"

echo ""
echo "[*] Adim 4: Live build baslatiliyor (Bu uzun surebilir)..."
echo "[*] Bekliyoruz..."
echo ""

cd "${BUILD_DIR}"

# Paket listelerini kontrol et
if [ ! -d "config/package-lists" ]; then
    echo "[*] Paket listeleri kopyalaniyor..."
    mkdir -p config/package-lists
    cp ../../build/live-build/config/package-lists/* config/package-lists/ 2>/dev/null || true
fi

# Live build calistir
echo "[*] ISO olusturuluyor..." 
lb build 2>&1 | tee "${OUTPUT_DIR}/build.log" || true

# Sonuc kontrolu
if [ -f "live-image-amd64.hybrid.iso" ]; then
    echo ""
    echo "========================================"
    echo "[+] ISO BASARIYLA OLUSTURULDU!"
    echo "========================================"
    
    ISO_NAME="techizat-os-2026.1-live.iso"
    mv live-image-amd64.hybrid.iso "${OUTPUT_DIR}/${ISO_NAME}"
    
    ISO_SIZE=$(du -h "${OUTPUT_DIR}/${ISO_NAME}" | cut -f1)
    
    echo ""
    echo "ISO Bilgileri:"
    echo "  Adi: ${ISO_NAME}"
    echo "  Boyut: ${ISO_SIZE}"
    echo "  Konum: ${OUTPUT_DIR}/${ISO_NAME}"
    echo ""
    echo "Ozellikler:"
    echo "  [+] Live Boot (Kuruluma gerek yok)"
    echo "  [+] Neon Tema (Mavi-Mor-Cyan)"
    echo "  [+] Guvenlik Araclari (Tor, Anonsurf, vb.)"
    echo "  [+] Pentest Araclari (Metasploit, Burp, vb.)"
    echo "  [+] AI Destegi (Ollama)"
    echo ""
    echo "USB Yazma:"
    echo "  sudo dd if=${OUTPUT_DIR}/${ISO_NAME} of=/dev/sdX bs=4M status=progress"
    echo ""
else
    echo "[!] ISO olusturma basarisiz oldu"
    echo "    Log dosyasini kontrol et: ${OUTPUT_DIR}/build.log"
    exit 1
fi
