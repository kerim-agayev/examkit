# ExamKit — Next.js Öğrenci Web

Next.js 15.5 (App Router) + TypeScript + Tailwind CSS 4 + Firebase + Zustand 5

## Geliştirme

```bash
npm install
npm run dev
```

## Firebase Yapılandırması

```bash
# .env.local oluştur (gitignored — asla commit edilmez)
cp .env.local.example .env.local
# → Firebase Console'dan Web config değerlerini doldur
# Bkz: docs/phase_1/secrets_management.md
```

## Mimari

```
app/
├── page.tsx                  # W1 — Kod giriş
├── join/[code]/page.tsx      # W2 — Ad-soyad girişi
├── waiting/[sessionId]/page.tsx  # W3 — Bekleme odası
├── exam/[sessionId]/page.tsx     # W4/5 — Sınav (scroll/sequential)
└── results/[sessionId]/page.tsx  # W6/7 — Sonuçlar

lib/          # Firebase, i18n, firestore helpers
stores/       # Zustand (examStore)
components/   # Paylaşılan UI bileşenleri
messages/     # Çeviri dosyaları (az, tr)
```

## Deploy

Cloudflare Pages:
- Build: `npm run build`
- Output: `.next`
- Node: 22
