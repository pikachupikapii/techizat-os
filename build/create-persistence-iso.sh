#!/bin/bash
# Techizat OS - Persistence Mode ISO Creator
# Kalici depolama modlu ISO

set -e

echo "[*] TECHIZAT OS - Persistence Mode ISO Creator"
echo ""

if [[ $EUID -ne 0 ]]; then
    echo "[!] Bu script root olarak calistirilmalidir"
    echo "    Calistir: sudo $0 <base-iso>"
    exit 1
fi

BASE_ISO="${1}"
OUTPUT_DIR="${2:-.}"
PERSISTENCE_SIZE="${3:-4G}"

if [ ! -f "${BASE_ISO}" ]; then
    echo "[!] ISO dosyasi bulunamadi: ${BASE_ISO}"
    exit 1
fi

echo "[*] Persistence Volume hazirlaniyot..."

WORK_DIR="/tmp/techizat-persist-$$"
mkdir -p "${WORK_DIR}"

echo "[*] ISO monte ediliyor..."
mkdir -p "${WORK_DIR}/iso"
mount -o loop "${BASE_ISO}" "${WORK_DIR}/iso"

echo "[*] Dosyalar kopyalaniyor..."
cp -r "${WORK_DIR}/iso" "${WORK_DIR}/iso-persistence"

echo "[*] Persistence partition olusturuluyor..."
PERSIST_SIZE_MB=$(echo ${PERSISTENCE_SIZE} | sed 's/G/*1024/;s/M//;s/^/echo /' | bash)
dd if=/dev/zero of="${WORK_DIR}/persistence.img" bs=1M count=${PERSIST_SIZE_MB} 2>/dev/null
mkfs.ext4 -L persistence "${WORK_DIR}/persistence.img"

echo "[*] Persistence konfigurasyon ayarlaniyot..."
mkdir -p "${WORK_DIR}/persistence-mount"
mount -o loop "${WORK_DIR}/persistence.img" "${WORK_DIR}/persistence-mount"

echo "/ union" > "${WORK_DIR}/persistence-mount/persistence.conf"
echo "/root union" >> "${WORK_DIR}/persistence-mount/persistence.conf"
echo "/home union" >> "${WORK_DIR}/persistence-mount/persistence.conf"
echo "/tmp union" >> "${WORK_DIR}/persistence-mount/persistence.conf"

echo "Techizat OS Persistence Volume" > "${WORK_DIR}/persistence-mount/README.txt"
echo "Olusturma Tarihi: $(date)" >> "${WORK_DIR}/persistence-mount/README.txt"

umount "${WORK_DIR}/persistence-mount"

echo "[*] ISO yeniden olusturuluyor..."
PERSISTENCE_ISO="${OUTPUT_DIR}/techizat-os-2026.1-persistence.iso"

xorriso -as mkisofs \
    -iso-level 3 \
    -full-iso9660-filenames \
    -volid "TECHIZAT_PERSIST" \
    -output "${PERSISTENCE_ISO}" \
    "${WORK_DIR}/iso-persistence" 2>/dev/null || true

echo "[*] Temizleniyor..."
cd /
umount "${WORK_DIR}/iso" 2>/dev/null || true
rm -rf "${WORK_DIR}"

if [ -f "${PERSISTENCE_ISO}" ]; then
    SIZE=$(du -h "${PERSISTENCE_ISO}" | cut -f1)
    echo ""
    echo "========================================"
    echo "[+] Persistence Modu ISO Olusturuldu!"
    echo "========================================"
    echo ""
    echo "ISO Bilgileri:"
    echo "  Adi: techizat-os-2026.1-persistence.iso"
    echo "  Boyut: ${SIZE}"
    echo "  Konum: ${PERSISTENCE_ISO}"
    echo ""
    echo "Kullanim:"
    echo "  1. ISO'yu USB'ye yaz"
    echo "  2. Boot sirasinda 'persistence' etkinlestir"
    echo "  3. Dosyalariniz kaydedilecek"
    echo ""
else
    echo "[!] Persistence ISO olusturulamadi"
    exit 1
fi
