# Techizat OS - Tasarım Kılavuzu

## 🎨 Renkler ve Tasarım Sistemimiz

### Renk Paleti

PRIMARY COLORS (Ana Renkler):
- Mavi (Blue): #3A86FF
- Mor (Purple): #7B2CBF
- Cyan (Accent): #06FFA5

BACKGROUND COLORS (Arka Plan):
- Koyu (Dark): #0a0e27
- Koyu-2 (Dark-2): #1a1f3a
- Koyu-3 (Dark-3): #2a2f4a

STATUS COLORS (Durum Göstergeleri):
- Başarılı (Success): #06FFA5
- Uyarı (Warning): #FFD60A
- Hata (Error): #FF006E
- Bilgi (Info): #3A86FF

### Gradients (Degrade)

```css
/* Primary Gradient */
linear-gradient(135deg, #3A86FF 0%, #7B2CBF 100%)

/* Neon Gradient */
linear-gradient(135deg, #7B2CBF 0%, #06FFA5 100%)

/* Cyber Gradient */
linear-gradient(90deg, #3A86FF 0%, #06FFA5 100%)

/* Dark Gradient */
linear-gradient(180deg, #1a1f3a 0%, #0a0e27 100%)
```

## 🦉 Logo & İkon Tasarımı

### Baykuş Logo
- Sembol: Vizyon, İstihbarat, Gece Görüşü
- Stil: Altıgensel Geometri
- Renk: Mavi-Mor-Cyan Gradient
- Glow Efekti: Neon ışık efektleri
- Dosya: design/logos/techizat-owl-logo.svg

### İkon Özellikleri
- Tüm ikonlar SVG formatında
- Minimum 24x24px boyut
- Neon renginde stroke (çizgi)
- Glow filter ile parlak efekt

## 🖼️ Wallpaper & Splash Screen

### Wallpaper Özellikleri
- Çözünürlük: 3840x2160px (4K)
- Format: SVG (ölçeklenebilir)
- Tema: Hexagonal Grid + Neon Lines
- Gradient: Koyu arka plan + Neon detaylar

### Splash Screen
- Çözünürlük: 1920x1080px
- Yazı: TECHIZAT OS + Loading...
- İlerleme Çubuğu: Animated gradient
- Baykuş Logo: Merkez konumda

## 🎯 GTK+ Tema Özellikleri

### Butonlar
- Background: Linear Gradient (Mavi → Mor)
- Hover: Daha parlak gradient + Cyan glow
- Active: Koyu gradient + inner shadow
- Border: Neon cyan rengi
- Box-shadow: Neon glow efekti

### Input Alanları
- Background: Yarı saydam koyu
- Border: Neon mavi
- Focus: Daha parlak, Cyan glow
- Text Color: Açık gri
- Caret: Neon cyan

### Scrollbars
- Background: Yarı saydam koyu
- Slider: Mavi-Mor gradient
- Slider Hover: Daha parlak + glow

### Tabs/Notebook
- Header Background: Koyu gradient
- Active Tab: Mavi renk + Cyan alt çizgi
- Tab Hover: Açık renk + glow

## 💻 LightDM Login Ekranı

### Tasarım Özellikleri
- Arka Plan: Wallpaper (bulanık veya yarı saydam)
- Login Box: Merkez, bordayı neon mavi
- Glow Effect: Çoklu glow shadow
- Butonlar: Mavi-Mor gradient
- Metin: Açık gri renk
- Hata Mesajı: Neon kırmızı

## 🔧 GRUB Önyükleyici Teması

### Tasarım
- Arka Plan: Koyu gradient
- Metin Rengi: Cyan ve Mavi
- İlerleme Çubuğu: Neon gradient
- Boot Menüsü: Neon bordaya sahip

## 🎬 Animasyonlar

### Neon Glow Efekti
filter: drop-shadow(0 0 15px rgba(58, 134, 255, 0.3))

### Button Hover Animasyonu
transition: all 200ms ease;
transform: translateY(-2px);
box-shadow: 0 0 25px rgba(6, 255, 165, 0.4);

### Input Focus Animasyonu
transition: all 150ms ease;
box-shadow: 0 0 20px rgba(6, 255, 165, 0.3),
            0 0 10px rgba(58, 134, 255, 0.2) inset;

## 📐 Spacing & Grid

### Boşluk Ölçümleri
- 8px: Minimal spacing
- 12px: Input padding
- 16px: Button padding
- 20px: Section spacing
- 40px: Major spacing

### Border Radius
- 4px: Kıçık elementler
- 6px: Butonlar & inputs
- 8px: Kartlar & boxlar
- 12px: Büyük containerlar

---

Tasarımcı: pikachupikapii
Son Güncelleme: 2026-06-23
Versiyon: 1.0
