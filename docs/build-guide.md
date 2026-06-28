# Techizat OS — Build Rehberi

## Gereksinimler

- Debian tabanlı bir Linux dağıtımı (Parrot OS, Kali, Debian)
- En az 20 GB boş disk alanı
- En az 4 GB RAM
- İnternet bağlantısı

## Kurulum

### 1. Gerekli Araçları Kur

```bash
sudo apt update
sudo apt install -y live-build live-config live-boot \
  debootstrap squashfs-tools genisoimage \
  xorriso isolinux curl git
```

### 2. Projeyi İndir

```bash
git clone https://github.com/pikachupikapii/techizat-os.git
cd techizat-os
```

### 3. ISO Oluştur

```bash
chmod +x build-iso.sh
sudo ./build-iso.sh
```

Build işlemi internet hızına bağlı olarak 20-60 dakika sürebilir.

### 4. ISO'yu USB'ye Yaz

```bash
# USB adını öğren
lsblk

# Yaz (sdb yerine kendi USB adını yaz)
sudo dd if=live-image-amd64.hybrid.iso \
         of=/dev/sdb \
         bs=4M \
         status=progress \
         conv=fsync
```

## Temizlik

Yeni build yapmadan önce:

```bash
sudo lb clean
```

## Sorun Giderme

**Build yarıda kesildiyse:**
```bash
sudo lb clean --purge
sudo ./build-iso.sh
```

**İnternet hatası alıyorsan:**
```bash
sudo lb clean
sudo apt update
sudo ./build-iso.sh
```

**ISO çok büyükse:**
`config/package-lists/` içinden gereksiz paketleri çıkar, tekrar build et.