# Techizat OS - Geliştirme Rehberi

## 🚀 Başlangıç

### Gereksinimler
- Linux işletim sistemi (Debian/Ubuntu önerilir)
- Git
- Sudo erişimi (ISO oluşturmak için)
- ~20GB disk alanı (ISO oluşturma için)

### Kurulum

```bash
# Repoyu klonla
git clone https://github.com/pikachupikapii/techizat-os.git
cd techizat-os

# Geliştirme ortamını kur
make setup

# Sanal ortamı etkinleştir
source venv/bin/activate
```

## 📁 Proje Yapısı

```
techizat-os/
├── design/              # Tasarım dosyaları
│   ├── themes/         # GTK+ tema
│   ├── logos/          # Logo SVG dosyaları
│   ├── wallpapers/     # Duvar kağıtları
│   ├── splash/         # Açılış ekranı
│   └── colors/         # Renk paleti JSON
├── build/              # Build scripts
│   ├── build-iso.sh    # ISO oluşturma scripti
│   ├── setup-dev-env.sh
│   ├── install-theme.sh
│   ├── output/         # Çıktı ISOs
│   └── work/           # Çalışma dosyaları
├── grub/               # GRUB bootloader konfigürasyonu
│   └── grub-theme/
├── lightdm/            # LightDM login ekranı
├── docs/               # Dokümantasyon
├── Makefile            # Build komutları
├── README.md           # Proje açıklaması
└── .gitignore          # Git ignore kuralları
```

## 🎨 Tasarım Üzerinde Çalışma

### GTK+ Tema Düzenleme

```bash
# Tema dosyasını düzenle
vim design/themes/techizat-gtk/gtk-3.20/gtk.css
```

### SVG Dosyaları Düzenleme

```bash
# İnkscape ile aç
inkscape design/logos/techizat-owl-logo.svg
```

## 🔨 Build Komutları

### Makefile Komutları

```bash
# Yardım görmek
make help

# Geliştirme ortamını kur
make setup

# ISO oluştur (root gerekli)
make build

# Temayı sisteme yükle
make install

# Build dosyalarını temizle
make clean

# Shell scriptleri doğrula
make test
```

## 📝 Katkı Sağlama

### Branch Oluşturma

```bash
# Yeni branch oluştur
git checkout -b feature/yeni-ozellik

# Değişiklikleri yap
git add .

# Commit et
git commit -m "feat: Yeni özellik açıklaması"

# Push et
git push origin feature/yeni-ozellik
```

### Commit Mesajı Kuralları

```
feat:  Yeni özellik
fix:   Hata düzeltme
docs:  Dokümantasyon
style: Stil değişiklikleri
refactor: Kod yeniden düzenleme
test:  Test ekleme
```

---

Bu proje topluluk tarafından yönetilir. 🚀
