# Techizat OS - Instalasyon Rehberi

## 📥 İndirme

### En Son Versiyon
```
Techizat OS 2026.1
İndirme: https://github.com/pikachupikapii/techizat-os/releases
Boyut: ~2.5GB
Arşiv: .iso (Hybrid)
```

### Doğrulama
```bash
# SHA256 doğrulaması
sha256sum techizat-os-2026.1.iso
```

## 💿 USB'ye Yazma

### Linux'ta
```bash
# USB cihazını bul
lsblk

# ISO'yu yaz
sudo dd if=techizat-os-2026.1.iso of=/dev/sd* bs=4M status=progress
sudo sync
sudo eject /dev/sd*
```

### Windows'ta
Önerileni: Balena Etcher
1. https://www.balena.io/etcher/ adresinden indirin
2. Programı açın
3. ISO dosyasını seçin
4. USB cihazını seçin
5. Flash butonuna tıklayın

## 🖥️ Kurulum Adımları

### 1. Bilgisayarı USB'den Başlat
- USB'yi takın
- Bilgisayarı yeniden başlatın
- Boot menüsüne girin (F2, F12, Del, vb.)
- USB cihazını seçin

### 2. GRUB Menüsü
Enter tuşuna basın (varsayılan seçenek normal moddur)

### 3. Sistem Başlatılması
Sistem yüklendikten sonra login ekranı görünecektir.

### 4. Login Ekranı
**Varsayılan Kullanıcı:**
- Kullanıcı: root (veya techizat)
- Şifre: (Kurulum sırasında belirleyin)

## ⚙️ İlk Başlatma Konfigürasyonu

### Ağ Kurulumu
1. Sağ alt köşedeki ağ ikonuna tıkla
2. Wi-Fi veya Ethernet bağlantısı seç
3. Bağlan tuşuna basın

### Sistem Güncellemeleri
```bash
sudo apt-get update
sudo apt-get upgrade -y
```

## 📦 Paket Yöneticisi Kullanımı

### APT Komutları
```bash
# Paket ara
apt-cache search paketadı

# Paket yükle
sudo apt-get install paketadı

# Paket kaldır
sudo apt-get remove paketadı

# Sistemi güncelle
sudo apt-get update && sudo apt-get upgrade -y
```

---

Kurulum başarılı! Techizat OS'ü kullanmayı keyifle! 🦉🚀
