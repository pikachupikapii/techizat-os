#!/bin/bash
# Techizat OS - Live Build Configuration
# Debian Live Build sistemi icin yapilandirma

set -e

echo "[*] Techizat OS Live Build Kurulumu Basliyor..."

# Yapilandirma
BUILD_NAME="techizat-os"
BUILD_VERSION="2026.1"
BUILD_DIR="${PWD}/build/live-build"
DISTRIBUTION="bookworm"
ARCH="amd64"

echo "[*] Build Adi: ${BUILD_NAME}"
echo "[*] Versiyon: ${BUILD_VERSION}"
echo "[*] Daglitim: ${DISTRIBUTION}"
echo ""

# Live build dizini olustur
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

echo "[*] Live build yapisi olusturuluyor..."

# Live build baslat
lb config \
    --distribution ${DISTRIBUTION} \
    --architectures ${ARCH} \
    --debootstrap-options "--variant=minbase" \
    --bootappend-live "boot=live config username=root" \
    --bootloader grub-efi \
    --binary-filesystem fat32 \
    --image-type iso-hybrid \
    --iso-application "Techizat OS" \
    --iso-preparer "pikachupikapii" \
    --iso-publisher "Techizat OS Project" \
    --iso-volume "TECHIZAT" \
    --memtest memtest86+ \
    --uefi-secure-boot disable

echo "[+] Live build yapisi olusturuldu"

# Config klasorlerini olustur
mkdir -p config/includes.chroot/etc
mkdir -p config/includes.chroot/usr/share/themes
mkdir -p config/includes.chroot/usr/share/pixmaps
mkdir -p config/includes.chroot/etc/lightdm
mkdir -p config/includes.chroot/boot/grub
mkdir -p config/hooks/live

echo "[+] Konfigurasyon hazirlanmasi tamamlandi"
echo ""
echo "Sonraki adimlar:"
echo "  1. Paket listesini ekle: cp ../live-build/config/package-lists/* ./config/package-lists/"
echo "  2. Build basla: sudo lb build"
echo ""
