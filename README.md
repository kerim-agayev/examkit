# ExamKit

**Hızlı, hafif, ücretsiz sınav platformu.**

Öğretmenler Flutter mobil uygulamasından anlık sınav oluşturur, öğrenciler tarayıcıdan uygulama indirmeden katılır.

---

## 🎯 Proje
- **Platform A:** Flutter 3.44 (iOS + Android) — Öğretmen uygulaması
- **Platform B:** Next.js 15.5 (Web, mobil-first) — Öğrenci web
- **Backend:** Firebase Spark (Firestore + Realtime DB, $0 maliyet)
- **Hedef:** Azerbaycan ve Türkiye'deki öğretmen ve öğrenciler

---

## 📁 Dizin

```
project/
├── docs/                  # Mimari, ADR'ler, planlama
│   ├── phase_1/           # MVP geliştirme
│   │   ├── architecture/  # Firebase şeması, API, Flutter/Next.js yapısı
│   │   └── decisions/     # 6 ADR (Architecture Decision Records)
│   └── phase_2/           # Büyüme özellikleri
│
├── design/                # Tasarım referansları
│   └── stitch_screens/    # 40+ Google Stitch HTML mockup (tüm ekranlar)
│
├── student_web/           # Next.js 15.5 öğrenci web uygulaması
│   └── app/               # App Router sayfaları
│
├── flutter_app/           # Flutter öğretmen uygulaması (yakında)
│
├── CLAUDE.md              # AI agent master kurallar
└── CLAUDE_CODE_PROMPT.md  # Geliştirme prompt'u
```

---

## 🚀 Başlangıç (Develop)

```bash
# Next.js öğrenci web
cd student_web
npm install
npm run dev          # → http://localhost:3000

# Flutter öğretmen uygulaması (Flutter SDK gerekli)
cd flutter_app
flutter pub get
flutter run
```

> Firebase yapılandırması için `docs/phase_1/secrets_management.md`'ye bak.

---

## 📊 Durum

- **Phase 1 (MVP):** 0% — Dokümantasyon + scaffold aşamasında
- **Phase 2 (Büyüme):** Planlamada

Detaylı ilerleme: [`docs/phase_1/index.md`](docs/phase_1/index.md)

---

*Haziran 2026 · kerim-agayev*
