---
name: ExamKit
colors:
  surface: '#faf8ff'
  surface-dim: '#d9d9e5'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3fe'
  surface-container: '#ededf9'
  surface-container-high: '#e7e7f3'
  surface-container-highest: '#e1e2ed'
  on-surface: '#191b23'
  on-surface-variant: '#434655'
  inverse-surface: '#2e3039'
  inverse-on-surface: '#f0f0fb'
  outline: '#737686'
  outline-variant: '#c3c6d7'
  surface-tint: '#0053db'
  primary: '#004ac6'
  on-primary: '#ffffff'
  primary-container: '#2563eb'
  on-primary-container: '#eeefff'
  inverse-primary: '#b4c5ff'
  secondary: '#006c4a'
  on-secondary: '#ffffff'
  secondary-container: '#82f5c1'
  on-secondary-container: '#00714e'
  tertiary: '#943700'
  on-tertiary: '#ffffff'
  tertiary-container: '#bc4800'
  on-tertiary-container: '#ffede6'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dbe1ff'
  primary-fixed-dim: '#b4c5ff'
  on-primary-fixed: '#00174b'
  on-primary-fixed-variant: '#003ea8'
  secondary-fixed: '#85f8c4'
  secondary-fixed-dim: '#68dba9'
  on-secondary-fixed: '#002114'
  on-secondary-fixed-variant: '#005137'
  tertiary-fixed: '#ffdbcd'
  tertiary-fixed-dim: '#ffb596'
  on-tertiary-fixed: '#360f00'
  on-tertiary-fixed-variant: '#7d2d00'
  background: '#faf8ff'
  on-background: '#191b23'
  surface-variant: '#e1e2ed'
  primary-dark: '#3B82F6'
  primary-bg-light: '#DBEAFE'
  primary-bg-dark: '#1E3A8A'
  success-light: '#059669'
  success-dark: '#10B981'
  warning-light: '#D97706'
  warning-dark: '#F59E0B'
  error-light: '#DC2626'
  error-dark: '#EF4444'
  bg-light: '#F1F5F9'
  bg-dark: '#0F172A'
  surface-light: '#FFFFFF'
  surface-dark: '#1E293B'
  surface-variant-light: '#F8FAFC'
  surface-variant-dark: '#334155'
  text-primary-light: '#0F172A'
  text-primary-dark: '#F8FAFC'
  text-secondary-light: '#475569'
  text-secondary-dark: '#94A3B8'
  border-light: '#E2E8F0'
  border-dark: '#334155'
typography:
  display:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: '1.2'
  headline:
    fontFamily: Inter
    fontSize: 26px
    fontWeight: '700'
    lineHeight: '1.3'
  title-lg:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '600'
    lineHeight: '1.4'
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.5'
  body:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.5'
  label:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: '1.4'
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  gutter: 16px
  margin: 24px
---

# ExamKit — DESIGN.md

> Google Stitch DESIGN.md — Bu dosya tasarım sistemini tanımlar.
> Tüm ekranlar bu kurallara göre oluşturulur.
> GÜNCELLEME: Karanlık Mod (Dark Mode) desteği eklendi.

---

## App Identity

- **App Name:** ExamKit
- **Platform A:** Flutter mobile app — Öğretmen (iOS + Android)
- **Platform B:** Next.js responsive web — Öğrenci (mobil tarayıcı)
- **Kategori:** Eğitim / Üretkenlik
- **Ton:** Profesyonel, güvenilir, sade, hızlı
- **Hedef Kullanıcı:** 25–65 yaş öğretmenler + 10–25 yaş öğrenciler

---

## Color System (Light & Dark Support)

### Primary (Ana Renk)
| Token | Light | Dark | Kullanım |
|-------|-------|------|---------|
| primary | #2563EB | #3B82F6 | Butonlar, aktif sekmeler, linkler |
| primary-light | #DBEAFE | #1E3A8A | Arka plan vurgusu, chip |
| on-primary | #FFFFFF | #FFFFFF | Primary üzeri metin |

### Semantic Renkler
| Token | Light | Dark | Kullanım |
|-------|-------|------|---------|
| success | #059669 | #10B981 | Tamamlandı, doğru cevap |
| warning | #D97706 | #F59E0B | Taslak, dikkat |
| error | #DC2626 | #EF4444 | Hata, yanlış cevap |

### Nötr Renkler
| Token | Light | Dark | Kullanım |
|-------|-------|------|---------|
| background | #F1F5F9 | #0F172A | Sayfa arka planı |
| surface | #FFFFFF | #1E293B | Kart yüzeyi |
| surface-variant | #F8FAFC | #334155 | Hafif arka plan |
| text-primary | #0F172A | #F8FAFC | Ana metin |
| text-secondary | #475569 | #94A3B8 | İkincil metin |
| border | #E2E8F0 | #334155 | Ayırıcılar |

---

## Typography (Inter)

| Stil | Boyut | Ağırlık |
|------|-------|---------|
| display | 32sp | 700 |
| headline | 26sp | 700 |
| title-large | 22sp | 600 |
| body-large | 18sp | 400 |
| body | 16sp | 400 |
| label | 14sp | 500 |

---

## Component Specs

### Heatmap Cell (Yeni)
- **High Success:** success-light arka plan, success metin
- **Medium Success:** warning-light arka plan, warning metin
- **Low Success:** error-light arka plan, error metin
- **Radius:** radius-sm (8dp)

### Checklist Item (Yeni)
- **State:** Tappable row
- **Icon:** Leading (status), Trailing (chevron/check)
- **Typography:** body (16sp)
