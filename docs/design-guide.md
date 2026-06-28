# Techizat OS — Tasarım Kılavuzu

## Renk Paleti

| İsim | HEX | Kullanım Yeri |
|---|---|---|
| Amber | `#FFBF00` | Ana vurgu, başlıklar, butonlar |
| Koyu Mor | `#4B0082` | İkincil vurgu, gradient |
| Lacivert | `#080a5c` | Ana arka plan |
| Turkuaz | `#40E0D0` | Hover efektleri, focus |
| Bakır | `#B87333` | Dekoratif detaylar |
| Adaçayı | `#BCB88A` | İkincil metin, açıklamalar |
| Wenge | `#645452` | Devre dışı elementler |
| Bordo | `#800000` | Uyarı/hata rengi |

## Tipografi

| Kullanım | Font | Boyut |
|---|---|---|
| Arayüz genel | DejaVu Sans | 11px |
| Terminal | Fira Code | 10px |
| GRUB başlık | DejaVu Sans Bold | 28px |
| GRUB menü | DejaVu Sans | 16px |
| Panel saat | DejaVu Sans | 11px |

## Gradient Kullanımı

```css
/* Ana gradient — başlık çubukları */
background: linear-gradient(135deg, #080a5c 0%, #4B0082 100%);

/* Hover gradient — butonlar */
background: linear-gradient(135deg, #40E0D0, #4B0082);

/* Panel gradient */
background: linear-gradient(180deg, #080a5c, #0d1068);

/* Progress bar */
background: linear-gradient(90deg, #4B0082, #40E0D0);
```

## Logo Kullanımı

- **Tam logo**: Giriş ekranı, karşılama ekranı, hakkında sayfası
- **Küçük logo**: Panel, GRUB menüsü
- **Format**: SVG tercih edilir, PNG fallback
- **Minimum boyut**: 32x32px

## Masaüstü Düzeni