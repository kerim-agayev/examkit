# ExamKit — Claude Code Plan Mode Başlatma Promptu

> Bu dosyadaki metni Claude Code'a plan modunda ver.
> Claude Code önce analiz yapacak, plan oluşturacak, altyapıyı kuracak,
> UI ekranlarına gelince durup Google Stitch MCP isteyecek.

---

## Claude Code'a Verilecek Prompt (olduğu gibi kopyala)

```
Merhaba! ExamKit projesini birlikte inşa edeceğiz.
Plan modunda başlıyoruz. Aşağıdaki adımları sırayla izle.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ADIM 1 — DOSYA ANALİZİ (Önce bunları oku)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Şu dosyaları sırayla eksiksiz oku:
1. CLAUDE.md
2. CLAUDE_CODE_PROMPT.md
3. docs/phase_1/architecture/firebase_schema.md
4. docs/phase_1/architecture/api_design.md
5. docs/phase_1/architecture/flutter_structure.md
6. docs/phase_1/architecture/nextjs_structure.md
7. docs/phase_1/decisions/ADR-001_tech_stack.md
8. docs/phase_1/decisions/ADR-002_auth.md
9. docs/phase_1/decisions/ADR-003_state_management.md
10. docs/phase_1/decisions/ADR-004_deployment.md
11. docs/phase_1/decisions/ADR-005_exam_modes.md
12. docs/phase_1/index.md

Okuma tamamlanınca bana şunu söyle:
"Analiz tamamlandı. [X] ekran, [Y] özellik, [Z] kritik kural tespit ettim."
Ardından planı çıkar.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ADIM 2 — PLAN OLUŞTUR (Onay bekle, başlama)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Planı şu formatta çıkar:

FAZA A — ALTYAPI (UI gerekmez, başlayabilirsin)
  A1. Proje iskeletleri (flutter_app/ + student_web/ + firebase/)
  A2. Firebase rules + indexes
  A3. Flutter: core katmanı (constants, theme, widgets, services)
  A4. Flutter: tüm Riverpod providers + repositories
  A5. Flutter: tüm Dart modelleri (Teacher, Group, Exam, Question, ExamAnswer, Session, LiveExam)
  A6. Flutter: ScoreCalculator servisi
  A7. Flutter: go_router konfigürasyonu (boş ekranlar, sadece routing)
  A8. Flutter: lokalizasyon (app_az.arb + app_tr.arb)
  A9. Next.js: Firebase init, Zustand store, TypeScript tipleri
  A10. Next.js: tüm lib/ fonksiyonları (firestore.ts, realtime.ts, scoring)
  A11. Next.js: i18n (az.json + tr.json)
  A12. Next.js: tüm route iskeletleri (boş sayfalar, sadece routing)

⛔ FAZA A tamamlanınca DUR. Bana "Altyapı kuruldu. Google Stitch MCP'ye ihtiyacım var." de.

FAZA B — UI TASARIMI ÇEKİMİ (Stitch MCP sonrası)
  B1. Google Stitch MCP üzerinden ExamKit projesinin tüm ekranlarını çek
  B2. Flutter 19 ekran → Material 3 bileşenlerine dönüştür
  B3. Next.js 7 ekran → Tailwind CSS responsive bileşenlerine dönüştür

FAZA C — FLUTTER EKRANLARI (sırayla, her ekran sonrası log)
  C1. Auth akışı: Splash → Onboarding → Login → Profil Kurulumu
  C2. Ana Sayfa + Bottom Navigation Shell
  C3. Gruplar: Liste → Oluştur → Detay
  C4. Sınav: Liste → Oluştur (Adım 1) → Ayarlar (Adım 2)
  C5. Sorular: Liste (Adım 3) → Editör (MCQ + T/F + Short Answer)
  C6. Önizleme (Adım 4) → Paylaşım (Adım 5)
  C7. Canlı Kontrol
  C8. Sonuçlar → Öğrenci Detayı
  C9. Ayarlar

FAZA D — NEXT.JS EKRANLARI (sırayla, her ekran sonrası log)
  D1. Ana Sayfa (kod girişi)
  D2. Ad-Soyad girişi
  D3. Bekleme Odası
  D4. Scroll Modu Sınav
  D5. Sequential Modu Sınav
  D6. Tamamlandı geçiş ekranı
  D7. Sonuçlar ekranı

FAZA E — ENTEGRASYON + TEST
  E1. Flutter ↔ Firebase bağlantı testi
  E2. Next.js ↔ Firebase bağlantı testi
  E3. Uçtan uca tam akış testi (öğretmen sınav açar → öğrenci katılır → sonuçlar)
  E4. Edge case'ler (CLAUDE_CODE_PROMPT.md §AŞAMA 16)
  E5. Lokalizasyon kontrolü (AZ + TR)

Planı çıkardıktan sonra bana sor: "Plan onaylıyor musun? FAZA A'ya başlayayım mı?"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ADIM 3 — KURALLARI HATIRLA (Her adımda geçerli)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CLAUDE.md §Mutlak Kurallar'ı oku. Özetlersem:
- GetX kesinlikle yasak → Riverpod 3.0
- Vercel'e deploy etme → Cloudflare Pages
- Firebase SMS OTP yok → Google Sign-In
- Firebase Cloud Storage yok → Faz 2'de Cloudinary
- Puanlama Next.js'de değil, Flutter öğretmen uygulamasında
- Doğru cevaplar exam_answers/ koleksiyonunda, öğrenci erişemez
- Tüm string'ler l10n/i18n'den, hardcoded yok
- Minimum touch target: 48dp (Flutter), 44px (Web)
- Her tamamlanan özellik sonrası docs/phase_1/logs/ güncelle

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ADIM 4 — FAZA A'DA YAPILACAKLAR (Onay alınca başla)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Proje kök yapısı:
examkit/
├── CLAUDE.md
├── CLAUDE_CODE_PROMPT.md
├── firebase/
│   ├── firebase.json
│   ├── firestore.rules       ← firebase_schema.md §Security Rules'tan
│   ├── firestore.indexes.json
│   └── database.rules.json   ← firebase_schema.md §RTDB Rules'tan
├── flutter_app/
└── student_web/

Flutter'da önce çalıştır:
  flutter create flutter_app --org com.examkit --platforms ios,android
  flutterfire configure  (firebase_options.dart üretir)

Next.js'de:
  npx create-next-app@15.5 student_web --typescript --tailwind --app

Her iki projeye bağımlılıkları ekle (CLAUDE.md §Teknoloji Yığını).

FAZA A tamamlanınca:
- Firebase rules deploy edilmiş olacak
- Tüm modeller yazılmış olacak
- Tüm service metodları yazılmış olacak
- Tüm routerlar çalışıyor olacak (boş ekranlarla)
- ScoreCalculator tam yazılmış olacak
- Hiçbir ekran tasarımı henüz yapılmamış olacak

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ADIM 5 — STITCH MCP SONRASI (Ben verince)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Google Stitch MCP bağlandığında:
1. ExamKit Stitch projesindeki tüm ekranları listele
2. Flutter ekranları için:
   - Stitch tasarımından renk, tipografi, spacing çek
   - Material 3 (MaterialApp, ColorScheme, TextTheme) ile uygula
   - DESIGN.md'deki token değerlerini kullan
3. Next.js ekranları için:
   - Stitch tasarımından layout, bileşen yapısı çek
   - Tailwind CSS ile uygula (mobil-first)
4. Tasarımı uyguladıktan sonra FAZA C'ye geç

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ADIM 6 — HER EKRAN SONRASI (Zorunlu)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Her ekran veya özellik tamamlandıktan sonra:
1. docs/phase_1/logs/YYYY-MM-DD_ekran-adi.md oluştur
2. docs/phase_1/index.md checklist'inde ilgili maddeyi [x] yap
3. Hata oluştuysa docs/phase_1/bugs/BUG-NNN.md ekle

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ŞIMDI: Analizi yap ve planı çıkar. Başlama.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Kullanım Akışı

```
Sen                          Claude Code
───                          ───────────
Promptu ver           →      12 dosyayı okur
                      ←      "Analiz tamamlandı, plan hazır"
"Onayla, başla"       →      FAZA A başlar (altyapı)
                      ←      "Altyapı kuruldu. Stitch MCP lazım."
Stitch MCP'yi bağla   →      MCP bağlandı
"Devam et"            →      Stitch'ten tasarımları çeker
                      ←      FAZA C başlar (Flutter ekranlar)
Her ekran sonrası     ←      Log dosyası güncellenir
                      ←      FAZA D (Next.js ekranlar)
                      ←      FAZA E (entegrasyon)
                      ←      "Proje tamamlandı"
```
