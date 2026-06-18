# ExamKit — DESIGN.md

> Google Stitch DESIGN.md — Bu dosya tasarım sistemini tanımlar.
> Tüm ekranlar bu kurallara göre oluşturulur.

---

## App Identity

- **App Name:** ExamKit
- **Platform A:** Flutter mobile app — Öğretmen (iOS + Android)
- **Platform B:** Next.js responsive web — Öğrenci (mobil tarayıcı)
- **Kategori:** Eğitim / Üretkenlik
- **Ton:** Profesyonel, güvenilir, sade, hızlı
- **Hedef Kullanıcı:** 25–65 yaş öğretmenler + 10–25 yaş öğrenciler
- **Kritik Kısıt:** 60+ yaş öğretmenler de rahatça kullanabilmeli

---

## Color System

### Primary (Ana Renk)
| Token | Hex | Kullanım |
|-------|-----|---------|
| primary | #2563EB | Butonlar, aktif sekmeler, linkler |
| primary-light | #DBEAFE | Arka plan vurgusu, chip |
| primary-dark | #1E40AF | Hover, pressed state |
| on-primary | #FFFFFF | Primary üzeri metin |

### Semantic Renkler
| Token | Hex | Kullanım |
|-------|-----|---------|
| success | #059669 | Tamamlandı, doğru cevap, canlı durum |
| success-light | #D1FAE5 | Success arka plan |
| warning | #D97706 | Taslak, dikkat, timer uyarı |
| warning-light | #FEF3C7 | Warning arka plan |
| error | #DC2626 | Hata, yanlış cevap, silme |
| error-light | #FEE2E2 | Error arka plan |
| info | #0284C7 | Bilgi, aktif durum |
| info-light | #E0F2FE | Info arka plan |

### Nötr Renkler
| Token | Hex | Kullanım |
|-------|-----|---------|
| surface | #FFFFFF | Kart yüzeyi |
| background | #F1F5F9 | Sayfa arka planı |
| surface-variant | #F8FAFC | Hafif arka plan farklılaştırma |
| text-primary | #0F172A | Ana metin |
| text-secondary | #475569 | İkincil metin, etiket |
| text-disabled | #94A3B8 | Devre dışı metin |
| border | #E2E8F0 | Kart border, ayırıcı |
| divider | #F1F5F9 | Liste ayırıcı |

---

## Typography

**Font:** Inter (Google Fonts) — tüm platformlarda

| Stil | Boyut | Ağırlık | Kullanım |
|------|-------|---------|---------|
| display | 32sp | 700 | Karşılama, büyük sayılar |
| headline | 26sp | 700 | Ekran başlığı |
| title-large | 22sp | 600 | Bölüm başlığı |
| title | 18sp | 600 | Kart başlığı |
| body-large | 18sp | 400 | Ana içerik metni |
| body | 16sp | 400 | Genel metin — **MINIMUM** |
| label | 14sp | 500 | Chip, badge, etiket |
| caption | 12sp | 400 | Yardımcı metin |

**Kritik:** Minimum body text 16sp — 60+ yaş erişilebilirliği için.

---

## Spacing (8dp Grid Sistemi)

| Token | Değer |
|-------|-------|
| space-1 | 4dp |
| space-2 | 8dp |
| space-3 | 12dp |
| space-4 | 16dp |
| space-5 | 20dp |
| space-6 | 24dp |
| space-8 | 32dp |
| space-10 | 40dp |
| space-12 | 48dp |

---

## Border Radius

| Token | Değer | Kullanım |
|-------|-------|---------|
| radius-sm | 8dp | Chip, badge, küçük buton |
| radius-md | 12dp | Buton, input |
| radius-lg | 16dp | Kart |
| radius-xl | 24dp | Bottom sheet, modal |
| radius-full | 9999dp | Pill buton, avatar |

---

## Component Specs

### Butonlar
- **Primary Button:** Yükseklik 56dp, tam genişlik, radius-md, primary renk fill, beyaz metin, 18sp bold
- **Secondary Button:** Yükseklik 56dp, outlined (primary border), primary metin
- **Danger Button:** Yükseklik 56dp, error fill, beyaz metin
- **Text Button:** Padding yatay 16dp, primary renk metin
- **Icon Button:** 48×48dp minimum, circular

### Input Alanları
- Yükseklik: 56dp
- Border: 1.5dp border, radius-md
- Focus: primary renk border
- Font: 16sp (minimum)
- Label: float-up animasyonu
- Hata: error renk border + hata mesajı altında

### Kartlar
- Arka plan: surface (#FFFFFF)
- Border radius: radius-lg (16dp)
- Elevation: 0–2dp (subtle shadow)
- Padding: 16dp

### Durum Rozeti (Status Badge)
- draft: warning-light arka plan, warning metin, "Taslak"
- active: info-light arka plan, info metin, "Aktif"
- live: success-light arka plan, success metin, "● Canlı" (nokta animasyonlu)
- completed: border arka plan, text-secondary metin, "Tamamlandı"

### Alt Navigasyon (Flutter)
- Yükseklik: 72dp
- 4 sekme: Ana Sayfa, Gruplar, Sınavlar, Ayarlar
- İkon boyutu: 24dp
- Aktif: primary renk ikon + label, primary-light arka plan pill
- Pasif: text-secondary

### Liste Öğesi
- Yükseklik minimum: 64dp
- Leading ikon/avatar
- Başlık (16sp, 600)
- Alt başlık (14sp, text-secondary)
- Trailing: chevron veya aksiyon ikon

---

## Flutter Mobil App Kuralları

- Material Design 3 (Material You) temelli
- System navigation bar saygısı (bottom safe area)
- AppBar: yükseklik 64dp, beyaz arka plan, shadow yok
- FAB (Floating Action Button): primary renk, 56dp, sağ alt
- BottomSheet: radius-xl üst köşeler
- Snackbar/Toast: alt kısım, kısa mesaj
- Loading: CircularProgressIndicator primary renk
- Tüm touch target minimum 48×48dp

---

## Next.js Student Web Kuralları

- **Mobile-first:** 375px baz genişlik
- **Max container:** 480px (mobil web için optimal)
- **Tablet/Desktop:** 640px'e kadar genişle, ortala, yan boşluk artar
- Navbar yok (basit geri butonu varsa)
- Full-width primary butonlar
- Input'lar büyük (56dp yükseklik)
- Dokunma hedefi minimum 44×44px
- Scroll sayfa arka planı: background (#F1F5F9)
- İçerik kartı: surface, rounded-2xl (24px), padding 24px
