# ExamKit — Öğrenci Web Test Rehberi

> **Sunucu:** `http://localhost:3002` (çalışıyor)  
> **Son güncelleme:** 2026-06-18

---

## 🚀 Hızlı Başlangıç

```bash
cd student_web
npm run dev          # localhost:3000 (veya 3002)
npm test             # 5 unit test
npm run build        # production build
```

---

## 🧪 Unit Testler (vitest)

```bash
npm test              # tüm testleri çalıştır (tek sefer)
npm run test:watch    # watch modda
npm run test:coverage # coverage raporu
```

| Test | Dosya | Kapsam |
|------|-------|--------|
| `getRemainingMs` | `__tests__/realtime.test.ts` | Global timer: future, now, past, late joiner, overflow |

---

## 📱 Sayfa Sayfa Manuel Test

### W1 — Kod Giriş (`/`)
| URL | Kontrol |
|-----|---------|
| http://localhost:3002/ | Logo, "Sınava Katıl" başlığı, kod input'u, Devam butonu |
| 3 harf yaz | Buton disabled |
| 4+ harf yaz (örn: ABCD) | Buton aktifleşir, mavi |
| Boş bırak + Devam | "Geçersiz kod" hatası, input shake |
| MAT7K2 + Devam | `/join/MAT7K2` sayfasına yönlenir |

### W2 — Ad-Soyad (`/join/[code]`)
| URL | Kontrol |
|-----|---------|
| http://localhost:3002/join/MAT7K2 | Sınav bilgi kartı (mavi), ad-soyad input'ları |
| Ad ve soyad gir + Sınava Katıl | `/waiting/...` sayfasına yönlenir |
| Geri linki | `/` sayfasına döner |
| Mobil: 375px | Container ortalanmış, tam genişlik |

### W3 — Bekleme Odası (`/waiting/[sessionId]`)
| URL | Kontrol |
|-----|---------|
| http://localhost:3002/waiting/mock123 | Pulse animasyonlu mavi daire, sayaç, "Katılan: ..." |
| 10 sn bekle | Sayaç değişebilir (mock) |
| "Vazgeç ve çık" linki | `/` sayfasına döner |

### W4 — Scroll Sınav (`/exam/[sessionId]?mode=scroll`)
| URL | Kontrol |
|-----|---------|
| http://localhost:3002/exam/mock123?mode=scroll | **Tüm 5 soru** alt alta görünür |
| Timer | Sağ üstte geri sayım (20:00 → 19:59 ...) |
| Progress bar | Her cevapta ilerler |
| Cevap ver + Sınavı Gönder | Confirm dialog çıkar |
| Confirm: Evet | Checkmark animasyonu → `/results/...` |
| Progress bar aria | `role="progressbar"` ekran okuyucuda okunur |

### W5 — Sequential Sınav (`/exam/[sessionId]?mode=sequential`)
| URL | Kontrol |
|-----|---------|
| http://localhost:3002/exam/mock123?mode=sequential | **Tek soru** görünür, `1 / 5` göstergesi |
| Cevap yok → İlerle | Buton disabled (gri) |
| Cevap seç → İlerle | Buton aktif (mavi), `İlerle →` |
| Tüm soruları cevapla | Son soruda `✓ Sınavı Tamamla` |
| Tamamla → Onayla | Checkmark → sonuç |
| `?mode=scroll` ile karşılaştır | Aynı exam sayfası, farklı UI |

### W6 — Tamamlandı Geçişi
| Tetikleme | Kontrol |
|-----------|---------|
| W4 veya W5'te sınavı tamamla | Yeşil checkmark SVG animasyonu |
| | "Sınav Tamamlandı! 🎉" başlığı |
| | "Sonuçlar hesaplanıyor..." + loading bar |
| | 2 sn sonra otomatik `/results/...` yönlenir |

### W7 — Sonuçlar (`/results/[sessionId]`)
| URL | Kontrol |
|-----|---------|
| http://localhost:3002/results/mock123 | Puan kartı (%96, 48/50), yeşil yuvarlak progress |
| | 🥇 Sınıfta 1. sıradasınız |
| | Doğru/Yanlış/Boş özet (46✓ 3✗ 1–) |
| | Liderlik tablosu (3 kişi) |
| | Soru inceleme: doğru (yeşil), yanlış (kırmızı), boş (gri) |
| Çıkış (✕) linki | `/` sayfasına döner |

---

## 📐 Responsive Test (Chrome DevTools)

1. F12 → Device Toolbar (Ctrl+Shift+M)
2. Şu genişliklerde test et:

| Genişlik | Beklenen |
|----------|---------|
| **375px** (iPhone SE) | Container tam genişlik, yazılar 16px+, butonlar 56px |
| **390px** (iPhone 14) | Aynı, küçük padding farkı |
| **768px** (iPad) | Container max 480-640px, ortalanmış, kenar boşlukları |
| **1024px+** (Desktop) | max-w-[480px] veya max-w-[640px] konteyner, gri arka plan |

3. Her sayfada scroll testi yap (özellikle W4 scroll modda 5 soru)

---

## 🌐 Dil Testi

| URL | Dil |
|-----|-----|
| http://localhost:3002/ | Türkçe (varsayılan) |
| Tarayıcı dilini Azerbaycanca yapıp tekrar aç | next-intl otomatik algılar |

---

## ⚙️ Mevcut Bilinen Sınırlamalar

- **Firebase olmadan** tüm sayfalar mock veri ile çalışır (DEMO badge'i görünür)
- **Scroll mod** URL param ile aktif: `?mode=scroll`
- **Sequential mod** varsayılan: param yoksa sequential
- **Timer** mock: gerçek RTDB yerine client-side sayar
- **Firebase bağlantısı** için `.env.local` oluşturulmalı (bkz. `secrets_management.md`)

---

## 🔧 Komut Özeti

```bash
cd student_web

npm run dev          # Geliştirme sunucusu
npm test             # Unit testler (5 test)
npm run build        # Production build
npm run lint         # ESLint

# Test edilecek URL'ler:
# http://localhost:3002/
# http://localhost:3002/join/MAT7K2
# http://localhost:3002/waiting/mock123
# http://localhost:3002/exam/mock123?mode=scroll
# http://localhost:3002/exam/mock123?mode=sequential
# http://localhost:3002/results/mock123
```
