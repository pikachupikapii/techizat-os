#!/bin/bash
set -e
set -o pipefail

echo "[*] TechizatOS ISO build basliyor..."
echo "[*] Bu islem surebilir, sabirla bekleyin."
echo ""

cd "$(dirname "$0")"

echo "[*] Onceki build temizleniyor..."
sudo lb clean --purge

echo "[*] Eski uretilmis config klasorleri siliniyor..."
sudo rm -rf config/binary config/bootstrap config/chroot config/common config/source .build

echo "[*] live-build config olusturuluyor..."
chmod +x auto/config
sudo lb config

echo "[*] ISO olusturuluyor..."

MAX_DENEME=6
DENEME=1
BASARILI=0

while [ "$DENEME" -le "$MAX_DENEME" ]; do
	echo ""
	echo "[*] Build denemesi: $DENEME / $MAX_DENEME"

	if [ "$DENEME" -gt 1 ]; then
		echo "[*] Onceki denemeden kalan yarim/bozuk asama temizleniyor (cache korunuyor)..."
		sudo lb clean
	fi

	if sudo lb build 2>&1 | tee -a build.log; then
		BASARILI=1
		break
	fi
	echo "[!] Build basarisiz oldu, 10 saniye sonra tekrar denenecek..."
	sleep 10
	DENEME=$((DENEME + 1))
done

if [ "$BASARILI" -ne 1 ]; then
	echo ""
	echo "[X] Build $MAX_DENEME denemeden sonra basarisiz oldu. build.log dosyasini kontrol et."
	exit 1
fi

echo ""
echo "[OK] ISO basariyla olusturuldu!"
echo "[OK] Dosya: live-image-amd64.hybrid.iso"
echo ""
echo "USB'ye yazmak icin:"
echo "  sudo dd if=live-image-amd64.hybrid.iso of=/dev/sdX bs=4M status=progress conv=fsync"
