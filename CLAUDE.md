# CLAUDE.md — Öğretmen Sınav Uygulaması

> **Bu dosyayı herhangi bir işe başlamadan önce eksiksiz oku.**  
> Her özellik tamamlandığında `docs/phase_1/logs/` içine kayıt ekle.  
> Mimari karar verirsen `docs/phase_1/decisions/` güncelle.  
> Hata bulursan `docs/phase_1/bugs/` güncelle.

---

## 🚫 MUTLAK KURALLAR — ASLA İHLAL ETME

| Yasak | Neden | Alternatif |
|-------|-------|-----------|
| `GetX` paketi | Nisan 2026'da GitHub'dan silindi | `Riverpod 3.0` |
| `Vercel` deployment | Ücretsiz planda ticari kullanım yasak | `Cloudflare Pages` |
| `Firebase SMS OTP` | Her SMS ücretli ($0.01–0.06) | `Google Sign-In` |
| `Firebase Cloud Storage` | Şubat 2026'dan itibaren Blaze plan gerekli | Faz 2'de `Cloudinary` free tier |
| `BLoC / GetIt / Provider` | Riverpod 3.0 standart seçildi | `Riverpod 3.0` |
| `console.log / print()` | Production'a bırakma | Logger paketi veya kaldır |
| Hardcoded string | Tüm metinler l10n/i18n üzerinden geçmeli | `.arb` (Flutter) / `next-intl` (Next.js) |
| `display: none` animasyon | UI donukluğuna yol açar | `AnimatedSwitcher` / CSS transition |

---

## 📋 Proje Genel Bakış

**Proje Adı:** ExamKit  
**Versiyon:** 0.1.0 (Phase 1 MVP)  
**Durum:** Geliştirme devam ediyor  
**Son Güncelleme:** Bkz. `docs/phase_1/logs/index.md`

### Nedir?
Öğretmenlerin mobil uygulamadan anında sınav oluşturup WhatsApp üzerinden paylaştığı, öğrencilerin herhangi bir uygulama indirmeden **tarayıcıdan** katılabildiği sınav platformu.

### Roller
| Rol | Platform | Teknoloji |
|-----|----------|-----------|
| Öğretmen | iOS + Android (native) | Flutter 3.44.0 |
| Öğrenci | Tarayıcı (uygulama indirme yok) | Next.js 15.5 web |
| Backend | Sunucusuz (serverless) | Firebase Spark (ücretsiz) |

### Hedef Pazar
- **Birincil:** Azerbaycan (128K+ öğretmen, ort. yaş 45, %36'sı 50+)
- **İkincil:** Türkiye (1.17M+ öğretmen)
- **Dil:** Azerbaycan Türkçesi (`az`) + Türkçe (`tr`)

---

## 🏗️ Teknoloji Yığını

### Flutter Uygulaması (Öğretmen)

```yaml
# pubspec.yaml — kesin versiyon pinleri
dependencies:
  flutter: sdk
  flutter_localizations: sdk

  # Firebase
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0
  firebase_database: ^11.0.0
  google_sign_in: ^6.0.0

  # State & Navigation
  flutter_riverpod: ^3.0.0
  riverpod_annotation: ^3.0.0
  go_router: ^14.0.0

  # UI & Utils
  share_plus: ^10.0.0
  qr_flutter: ^4.0.0
  flutter_svg: ^2.0.0
  intl: ^0.19.0

dev_dependencies:
  build_runner: ^2.0.0
  riverpod_generator: ^3.0.0
  flutter_lints: ^4.0.0
```

### Next.js Web (Öğrenci)

```json
{
  "dependencies": {
    "next": "15.5.x",
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "firebase": "^11.0.0",
    "zustand": "^5.0.0",
    "next-intl": "^3.0.0",
    "lucide-react": "latest"
  },
  "devDependencies": {
    "typescript": "^5.7.0",
    "@types/node": "^22.0.0",
    "@types/react": "^19.0.0",
    "tailwindcss": "^4.0.0"
  }
}
```

### Backend & Deployment

| Servis | Plan | Limit | Kullanım |
|--------|------|-------|---------|
| Firebase Auth (Google) | Spark | 50K MAU/ay | Öğretmen girişi |
| Cloud Firestore | Spark | 50K okuma + 20K yazma/gün | Ana veri |
| Firebase Realtime DB | Spark | **100 eş zamanlı bağlantı**, 1GB | Canlı sınav sync |
| Firebase Hosting | Spark | 10GB, 360MB/gün bant | (Next.js için kullanma) |
| Cloudflare Pages | Free | Sınırsız bant, ticari OK | Next.js deployment |
| Android APK | — | — | MVP test dağıtımı |

---

## 📁 Klasör Yapısı

### Proje Kökü

```
examkit/
├── CLAUDE.md                    ← BU DOSYA
├── flutter_app/                 ← Öğretmen mobil uygulaması
├── student_web/                 ← Öğrenci web arayüzü
└── docs/                        ← Tüm dokümantasyon ve hafıza
    ├── index.md
    ├── phase_1/
    │   ├── index.md
    │   ├── architecture/
    │   ├── decisions/
    │   ├── logs/
    │   └── bugs/
    └── phase_2/
        └── index.md
```

### Flutter Uygulaması: `flutter_app/`

```
flutter_app/
├── lib/
│   ├── main.dart                          # Uygulama giriş noktası
│   ├── router.dart                        # go_router — tüm rotalar
│   ├── firebase_options.dart              # FlutterFire CLI çıktısı
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart            # Renk sistemi
│   │   │   ├── app_sizes.dart             # Spacing, radius, font size
│   │   │   └── app_constants.dart         # MAX_QUESTIONS, MIN_TIMER vb.
│   │   ├── theme/
│   │   │   └── app_theme.dart             # MaterialTheme light/dark
│   │   ├── utils/
│   │   │   ├── exam_code_generator.dart   # 6 haneli benzersiz kod üretimi
│   │   │   ├── validators.dart            # Form validasyonları
│   │   │   └── date_formatter.dart        # Tarih formatlama
│   │   └── widgets/
│   │       ├── app_button.dart            # Primary/secondary/danger butonlar
│   │       ├── app_text_field.dart        # Özelleştirilmiş TextField
│   │       ├── app_card.dart              # Standart kart bileşeni
│   │       ├── loading_overlay.dart       # Full-screen loading
│   │       ├── confirmation_dialog.dart   # Onay diyaloğu
│   │       └── empty_state.dart           # Boş liste durumu
│   │
│   ├── features/
│   │   │
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   └── auth_repository.dart   # Firebase Auth işlemleri
│   │   │   ├── models/
│   │   │   │   └── teacher_model.dart     # Öğretmen veri modeli
│   │   │   ├── providers/
│   │   │   │   └── auth_provider.dart     # Riverpod: auth state
│   │   │   └── screens/
│   │   │       ├── splash_screen.dart
│   │   │       ├── onboarding_screen.dart
│   │   │       ├── login_screen.dart
│   │   │       └── profile_setup_screen.dart
│   │   │
│   │   ├── home/
│   │   │   ├── providers/
│   │   │   │   └── home_provider.dart     # Dashboard istatistikleri
│   │   │   └── screens/
│   │   │       └── home_screen.dart
│   │   │
│   │   ├── groups/
│   │   │   ├── data/
│   │   │   │   └── group_repository.dart
│   │   │   ├── models/
│   │   │   │   └── group_model.dart
│   │   │   ├── providers/
│   │   │   │   └── group_provider.dart
│   │   │   └── screens/
│   │   │       ├── group_list_screen.dart
│   │   │       ├── group_create_screen.dart
│   │   │       └── group_detail_screen.dart
│   │   │
│   │   ├── exams/
│   │   │   ├── data/
│   │   │   │   └── exam_repository.dart
│   │   │   ├── models/
│   │   │   │   ├── exam_model.dart
│   │   │   │   ├── exam_settings_model.dart
│   │   │   │   └── question_model.dart
│   │   │   ├── providers/
│   │   │   │   ├── exam_provider.dart
│   │   │   │   └── question_provider.dart
│   │   │   └── screens/
│   │   │       ├── exam_list_screen.dart
│   │   │       ├── exam_create_screen.dart       # Adım 1: başlık + grup
│   │   │       ├── exam_settings_screen.dart     # Adım 2: ayarlar
│   │   │       ├── question_list_screen.dart     # Adım 3: soru listesi
│   │   │       ├── question_create_screen.dart   # Soru oluştur/düzenle
│   │   │       ├── exam_preview_screen.dart      # Adım 4: önizleme
│   │   │       └── exam_share_screen.dart        # Adım 5: paylaşım
│   │   │
│   │   ├── live/
│   │   │   ├── data/
│   │   │   │   └── live_exam_repository.dart     # RTDB işlemleri
│   │   │   ├── providers/
│   │   │   │   └── live_exam_provider.dart
│   │   │   └── screens/
│   │   │       └── live_exam_screen.dart         # Canlı kontrol paneli
│   │   │
│   │   ├── results/
│   │   │   ├── data/
│   │   │   │   └── results_repository.dart
│   │   │   ├── providers/
│   │   │   │   └── results_provider.dart
│   │   │   └── screens/
│   │   │       ├── exam_results_screen.dart      # Sınıf özeti
│   │   │       └── student_result_screen.dart    # Öğrenci detayı
│   │   │
│   │   └── settings/
│   │       └── screens/
│   │           └── settings_screen.dart
│   │
│   ├── l10n/
│   │   ├── app_az.arb             # Azerbaycan Türkçesi çevirileri
│   │   └── app_tr.arb             # Türkçe çevirileri
│   │
│   └── services/
│       ├── firestore_service.dart     # Firestore CRUD yardımcıları
│       ├── realtime_db_service.dart   # RTDB stream/write
│       └── auth_service.dart          # Auth state stream
│
├── test/
│   ├── unit/
│   └── widget/
├── pubspec.yaml
└── analysis_options.yaml
```

### Next.js Web: `student_web/`

```
student_web/
├── app/
│   ├── layout.tsx                        # Root layout — providers + fonts
│   ├── page.tsx                          # "/" — Kod giriş sayfası
│   ├── join/
│   │   └── [code]/
│   │       └── page.tsx                  # Ad-soyad girişi
│   ├── waiting/
│   │   └── [sessionId]/
│   │       └── page.tsx                  # Bekleme odası (öğretmeni bekle)
│   ├── exam/
│   │   └── [sessionId]/
│   │       └── page.tsx                  # Sınav ekranı (scroll / sequential)
│   └── results/
│       └── [sessionId]/
│           └── page.tsx                  # Sonuçlar + liderboard
│
├── components/
│   ├── exam/
│   │   ├── ScrollExam.tsx                # Tüm sorular görünür mod
│   │   ├── SequentialExam.tsx            # Tek soru mod
│   │   ├── QuestionCard.tsx              # Soru bileşeni (tüm tipler)
│   │   ├── MCQOptions.tsx                # Çoktan seçmeli şıklar
│   │   ├── TrueFalseOptions.tsx          # D/Y butonları
│   │   ├── ShortAnswerInput.tsx          # Metin giriş
│   │   ├── GlobalTimer.tsx               # Üst bar geri sayım
│   │   ├── QuestionTimer.tsx             # Soru başı geri sayım
│   │   └── ProgressBar.tsx               # X / Y soru
│   ├── results/
│   │   ├── ScoreDisplay.tsx              # Büyük puan kartı
│   │   ├── AnswerBreakdown.tsx           # Doğru/Yanlış/Boş özeti
│   │   ├── Leaderboard.tsx               # Sınıf sıralaması
│   │   └── AnswerReview.tsx              # Cevap inceleme (izin varsa)
│   ├── waiting/
│   │   └── WaitingRoom.tsx               # Bekleme odası UI
│   └── ui/
│       ├── Button.tsx
│       ├── Input.tsx
│       ├── Card.tsx
│       ├── LoadingSpinner.tsx
│       └── Toast.tsx
│
├── hooks/
│   ├── useExamSession.ts                 # Session yönetimi
│   ├── useRealtimeSync.ts                # RTDB dinleme
│   ├── useGlobalTimer.ts                 # Global timer mantığı
│   └── useQuestionTimer.ts               # Soru başı timer
│
├── lib/
│   ├── firebase.ts                       # Firebase init (singleton)
│   ├── firestore.ts                      # Firestore read helpers
│   ├── realtime.ts                       # RTDB subscribe/write
│   └── scoring.ts                        # Puan hesaplama mantığı
│
├── stores/
│   └── examStore.ts                      # Zustand: tüm sınav state'i
│
├── types/
│   └── index.ts                          # Paylaşılan TypeScript tipleri
│
├── messages/
│   ├── az.json                           # Azerbaycan Türkçesi
│   └── tr.json                           # Türkçe
│
└── public/
    └── icons/
```

---

## 🗄️ Veritabanı Şeması

> **Tam şema:** `docs/phase_1/architecture/firebase_schema.md`

### Firestore Collections Özeti

```
users/{userId}
├── uid, name, school?, lang, plan, createdAt, updatedAt

groups/{groupId}
├── id, teacherId, name, description?, examCount, lastUsedAt, createdAt

exams/{examId}
├── id, teacherId, groupId, title, code(6-char), status
├── mode: 'scroll' | 'sequential'
├── settings: { globalTimerMinutes?, shuffleQuestions, shuffleOptions,
│              showCorrectAnswers, showScoreToStudent, showLeaderboard,
│              allowLateJoin }
├── totalPoints, questionCount, startedAt?, endedAt?, createdAt

exams/{examId}/questions/{questionId}
├── id, examId, type: 'mcq'|'true_false'|'short_answer'
├── text, points, timerSeconds?, orderIndex
├── options?: [{id, text}]        (MCQ)
├── correctOptionId?: string      (MCQ)
├── correctBool?: boolean         (True/False)
├── acceptedAnswers?: string[]    (Short Answer)

sessions/{sessionId}
├── id, examId, teacherId, groupId
├── studentName, studentDisplayName (çakışmada "Ali V. (2)")
├── status: 'waiting'|'active'|'completed'|'abandoned'
├── answers: { [questionId]: { value, answeredAt? } }
├── score, totalPoints, percentage, rank?
├── startedAt?, completedAt?, durationSeconds?
```

### Firebase Realtime Database

```
live_exams/{examId}/
├── status: 'waiting'|'active'|'completed'
├── startedAt: unix_timestamp
├── globalTimerEndsAt: unix_timestamp (null if no timer)
└── students/
    └── {sessionId}/
        ├── name: string
        ├── status: 'waiting'|'active'|'completed'
        ├── answeredCount: number
        ├── totalQuestions: number
        └── joinedAt: unix_timestamp
```

---

## 🔑 Naming Conventions

### Flutter (Dart)

| Tip | Format | Örnek |
|-----|--------|-------|
| Dosyalar | `snake_case` | `exam_list_screen.dart` |
| Sınıflar | `PascalCase` | `ExamListScreen` |
| Değişkenler | `camelCase` | `groupRepository` |
| Sabitler | `SCREAMING_SNAKE_CASE` | `MAX_QUESTION_COUNT` |
| Provider'lar | `camelCase` + `Provider` | `examListProvider` |
| Modeller | `PascalCase` + `Model` | `ExamModel` |
| Repository'ler | `PascalCase` + `Repository` | `ExamRepository` |
| Screen'ler | `PascalCase` + `Screen` | `GroupListScreen` |

### Next.js (TypeScript)

| Tip | Format | Örnek |
|-----|--------|-------|
| Bileşen dosyaları | `PascalCase.tsx` | `QuestionCard.tsx` |
| Hook dosyaları | `use` + `PascalCase.ts` | `useExamSession.ts` |
| Util dosyaları | `kebab-case.ts` | `exam-helpers.ts` |
| Tipler/Interface | `PascalCase` | `ExamSession`, `QuestionType` |
| Store | `camelCase` + `Store` | `examStore` |
| Route klasörleri | `kebab-case` | `exam-results/` |

### Firebase / Firestore

| Tip | Format | Örnek |
|-----|--------|-------|
| Collection'lar | `camelCase` plural | `exams`, `groups`, `sessions` |
| Field'lar | `camelCase` | `teacherId`, `createdAt` |
| Composite index | açıkça tanımla | `teacherId ASC, createdAt DESC` |

---

## ✅ Phase 1 — Özellik Checklist

> Her tamamlanan özelliğin `[ ]` → `[x]` yapılır ve log eklenir.

### 🔐 Auth & Profil
- [ ] Splash screen
- [ ] Onboarding ekranı (ilk açılış)
- [ ] Google Sign-In
- [ ] İlk kurulum profil ekranı (ad, okul, dil)
- [ ] Kalıcı oturum
- [ ] Çıkış yapma (onay ile)

### 🏠 Ana Sayfa / Dashboard
- [ ] İstatistik kartları (grup, sınav, bugün'ün katılımcıları)
- [ ] Hızlı aksiyon butonları (Yeni Grup, Yeni Sınav)
- [ ] Son 5 sınav listesi (durum renk kodlaması)
- [ ] Alt navigasyon çubuğu (4 sekme)
- [ ] Bağlantı durumu göstergesi

### 👥 Grup Yönetimi
- [ ] Grup listesi (son kullanılan üstte)
- [ ] Grup oluşturma (ad + açıklama)
- [ ] Grup düzenleme
- [ ] Grup silme (onay diyaloğu, aktif sınavda engel)
- [ ] Grup detay sayfası (geçmiş sınavlar)
- [ ] Grup yeniden kullanım mantığı (öğrenci önceden eklenmez)

### 📝 Sınav Oluşturma Akışı
- [ ] Adım 1: Başlık + grup seçimi
- [ ] Adım 2: Sınav ayarları ekranı (12 ayar)
- [ ] Adım 3: Soru listesi
- [ ] Adım 4: Sınav önizleme
- [ ] Adım 5: Yayınlama + 6 haneli kod üretimi
- [ ] Taslak otomatik kayıt

### ❓ Soru Editörü
- [ ] MCQ soru tipi (4 şık, 1 doğru)
- [ ] Doğru/Yanlış soru tipi
- [ ] Kısa cevap soru tipi (çoklu kabul edilen cevap)
- [ ] Soru başına puan atama (1–100)
- [ ] Soru başına timer (5–300 sn)
- [ ] Drag-drop sıralama
- [ ] Soru kopyalama
- [ ] Soru silme
- [ ] Soru önizleme (modal)

### ⚙️ Sınav Ayarları
- [ ] Scroll modu
- [ ] Sequential modu
- [ ] Global timer (1–180 dk)
- [ ] Soru karıştırma toggle
- [ ] Şık karıştırma toggle
- [ ] Cevapları öğrenciye göster toggle
- [ ] Skoru öğrenciye göster toggle
- [ ] Liderboard görünürlük toggle
- [ ] Geç katılım izni toggle
- [ ] Sınav durum makinesi (draft→active→live→completed)
- [ ] Boş sınav yayınlama engeli
- [ ] Aktif sınavı silme engeli

### 📤 Paylaşım Sistemi
- [ ] 6 haneli benzersiz kod üretimi (özel algoritma)
- [ ] WhatsApp paylaşım (TR/AZ yerelleştirilmiş mesaj)
- [ ] QR kod üretimi (qr_flutter)
- [ ] Link kopyalama (panoya + toast bildirimi)
- [ ] Sistem paylaşımı (share_plus)

### 📡 Canlı Sınav Kontrolü
- [ ] Katılan öğrenci listesi (RTDB real-time)
- [ ] Sınavı başlatma (onay diyaloğu)
- [ ] Öğrenci ilerleme takibi (X/Y soru)
- [ ] Tamamlayan vs devam eden gösterimi
- [ ] Erken bitirme (onay + tamamlanmayanları gönder)
- [ ] Öğretmen timer göstergesi
- [ ] Bağlantı durumu izleme
- [ ] Öğretmen offline olduğunda sınav devamı

### 📊 Sonuçlar & Analitik
- [ ] Sınıf özet istatistikleri (ort, min, max, pass rate)
- [ ] Puan dağılımı bar grafiği
- [ ] Liderboard (eşit puanda süreye göre)
- [ ] Öğrenci bazlı detay (soru soru doğru/yanlış)
- [ ] Soru bazlı analiz (doğruluk yüzdesi, renk kodlama)
- [ ] Geçmiş sınavlar listesi

### ⚙️ Uygulama Ayarları
- [ ] Dil değiştirme (AZ/TR, anlık)
- [ ] Profil güncelleme (ad, okul)
- [ ] Çıkış yap
- [ ] Uygulama versiyonu gösterimi

### 🌐 Öğrenci Web — Katılım
- [ ] Ana sayfa: kod giriş kutusu
- [ ] Link ile direkt katılım (`/join/[code]`)
- [ ] Geçersiz kod hata mesajı
- [ ] Ad-soyad girişi (her ikisi zorunlu)
- [ ] Çakışan isim yönetimi ("Ali V. (2)")
- [ ] Bekleme odası (RTDB real-time, öğrenci sayısı)

### 🌐 Öğrenci Web — Sınav
- [ ] Scroll modu: tüm sorular listesi
- [ ] Sequential modu: tek soru görünümü
- [ ] MCQ seçenekleri UI
- [ ] True/False UI
- [ ] Short Answer text input
- [ ] Cevap değiştirme (scroll modda, gönderilmeden)
- [ ] "İlerle" butonu kilidi (sequential, cevap yokken)
- [ ] Global timer (countdown, renkli uyarılar)
- [ ] Soru başı timer (sequential: otomatik ilerleme)
- [ ] İlerleme çubuğu (X/Y cevaplandı)
- [ ] Yanıtsız soru uyarısı (scroll, gönder öncesi)
- [ ] Timer dolunca otomatik gönder
- [ ] Bağlantı kesilmesi banner'ı + cevap korunması

### 🌐 Öğrenci Web — Sonuçlar
- [ ] Puan ve yüzde gösterimi (büyük, net)
- [ ] Doğru/Yanlış/Boş sayısı (renk kodlu)
- [ ] Sınıf sırası (öğretmen izni varsa)
- [ ] Liderboard listesi (öğretmen izni varsa)
- [ ] Cevap inceleme (öğretmen izni varsa)
- [ ] Tamamlama süresi

### ⚠️ Edge Cases (Denetim Sonrası Güncellenmiş)
- [ ] Öğrenci internet kesilmesi → local state + localStorage korunur, sync gelince yazar
- [ ] Tarayıcı kapatma/yenileme → sessionId localStorage'dan restore, questionOrder session'dan
- [ ] Timer dolduğunda auto-submit → "Süre doldu!" toast + completeSession() çağrılır
- [ ] Geç katılım: `globalTimerEndsAt - Date.now()` → geç gelen otomatik daha az süre bulur (tam süre VERİLMEZ)
- [ ] Aynı isimli öğrenci → Firestore transaction ile "(2)" eki, race condition korumalı
- [ ] **99** bağlantı limiti → 99. öğrenciye "Sınav kapasitesi doldu" (100 - 1 öğretmen bağlantısı)
- [ ] Boş sınav yayınlama engeli → en az 1 soru zorunlu
- [ ] Öğretmen offline → Firebase sınavı devam ettirir, yeniden bağlanınca sync
- [ ] 0 öğrencili sınav bitirme → "Hiç öğrenci katılmadı, yine de bitir?" onay diyaloğu
- [ ] publishExam atomikliği → Firestore transaction (kod üretimi + status değişimi tek işlem)
- [ ] Soru başı timer ≤ global timer → editörde kontrol, aşılırsa hata mesajı

### 🌍 Lokalizasyon
- [ ] Flutter AZ dil dosyası (app_az.arb) — tüm stringler
- [ ] Flutter TR dil dosyası (app_tr.arb) — tüm stringler
- [ ] Next.js AZ (az.json) — tüm stringler
- [ ] Next.js TR (tr.json) — tüm stringler

---

## 📚 Dokümantasyon Sistemi

### Klasör Yapısı
```
docs/
├── index.md                         # Ana indeks — tüm dökümanlar
├── phase_1/
│   ├── index.md                     # Faz 1 durum özeti + checklist yüzdesi
│   ├── architecture/
│   │   ├── index.md                 # Mimari karar özeti
│   │   ├── flutter_structure.md     # Flutter proje detayı
│   │   ├── nextjs_structure.md      # Next.js proje detayı
│   │   ├── firebase_schema.md       # Tam DB şeması
│   │   └── api_design.md            # Servis katmanı tasarımı
│   ├── decisions/
│   │   ├── index.md                 # Tüm ADR'lerin listesi
│   │   ├── ADR-001_tech_stack.md
│   │   ├── ADR-002_auth.md
│   │   ├── ADR-003_state_management.md
│   │   ├── ADR-004_deployment.md
│   │   └── ADR-005_exam_modes.md
│   ├── logs/
│   │   ├── index.md                 # Log indeksi
│   │   ├── _template.md             # Log şablonu
│   │   └── YYYY-MM-DD_konu.md       # Oturum logları
│   └── bugs/
│       ├── index.md                 # Aktif + çözülen buglar
│       └── _template.md             # Bug şablonu
└── phase_2/
    └── index.md                     # Faz 2 planlama
```

### Her Adım Sonrası Yapılacaklar (ZORUNLU)

1. **`docs/phase_1/logs/`** → `YYYY-MM-DD_ozellik.md` dosyası oluştur
2. **`docs/phase_1/index.md`** → Checklist güncellemesi (`[ ]` → `[x]`)
3. **`docs/phase_1/bugs/`** → Yeni bug keşfedilirse `BUG-XXX.md` ekle
4. **`docs/phase_1/decisions/`** → Mimari karar verilirse `ADR-XXX.md` ekle
5. **`docs/phase_1/architecture/`** → Şema veya yapı değişirse güncelle

---

## 🔄 Sınav Yaşam Döngüsü

```
draft ──► active ──► live ──► completed
  │          │         │
  │     (link/QR    (öğretmen
  │      üretildi)  başlattı)
  │
  └─► silinebilir (aktifken silinemez)
```

| Durum | Açıklama | Öğrenci Katılabilir mi? |
|-------|----------|------------------------|
| `draft` | Oluşturuldu, yayınlanmadı | Hayır |
| `active` | Link paylaşıldı, bekleniyor | Evet (bekleme odasına) |
| `live` | Öğretmen başlattı, sınav sürüyor | Sadece geç katılım açıksa |
| `completed` | Sona erdi, sonuçlar kilitlendi | Hayır |

---

## 🌍 Lokalizasyon Kuralları

### Flutter (`.arb` dosyaları)
```json
// lib/l10n/app_az.arb
{
  "@@locale": "az",
  "appTitle": "İmtahan Tətbiqi",
  "createGroup": "Qrup yarat",
  "examCode": "İmtahan kodu: {code}",
  "@examCode": {
    "placeholders": {
      "code": { "type": "String" }
    }
  }
}
```

### Next.js (`messages/*.json`)
```json
// messages/az.json
{
  "join": {
    "title": "İmtahana qoşul",
    "enterCode": "İmtahan kodunu daxil et",
    "enterName": "Ad Soyad"
  }
}
```

---

## 🛠️ Geliştirme Kuralları (Ek)

### Firebase Güvenlik
- Her Firestore yazma işlemini `try-catch` ile sar
- Security Rules: öğretmen sadece kendi verisini okur/yazar
- Session ID'leri tahmin edilemez olmalı (UUID v4)

### Performans
- Firestore'dan **sadece gerekli field'ları** çek (select)
- Realtime DB'yi **sadece** canlı sınav senkronu için kullan
- Flutter'da `const` widget'larını mümkün olduğunca kullan
- Next.js'de gereksiz `'use client'` ekleme

### Test
- Her Repository sınıfı için unit test yaz
- Kritik UI akışları için widget test yaz
- Edge case'ler için ayrı test dosyası

### Erişilebilirlik
- Minimum dokunma hedefi: 48dp (Flutter) / 44px (Web)
- Renk kontrastı WCAG AA standardında
- Screen reader etiketi (semanticsLabel / aria-label)
- Büyük yazı desteği — AppBar hariç tüm metinler ölçeklenebilir

---

## 🚀 Kurulum Komutları

### Flutter
```bash
cd flutter_app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutterfire configure    # firebase_options.dart üretir
flutter run
```

### Next.js (Öğrenci Web)
```bash
cd student_web
npm install
cp .env.example .env.local   # Firebase config ekle
npm run dev
```

### Cloudflare Pages Deploy
```bash
# GitHub'a push → otomatik deploy
# veya
npx wrangler pages publish ./out --project-name=examkit-student
```

### Firebase CLI
```bash
npm install -g firebase-tools
firebase login
firebase init firestore    # indexes + security rules
firebase init database     # RTDB rules
firebase deploy --only firestore:rules,database
```

---

## 📊 Ücretsiz Tier Limitler & Uyarılar

| Servis | Limit | Aşılırsa |
|--------|-------|---------|
| Firestore okuma | 50,000/gün | Hata, okuma durur |
| Firestore yazma | 20,000/gün | Hata, yazma durur |
| RTDB bağlantı | 100 eş zamanlı | 100. öğrenciye "dolu" mesajı |
| Firebase Auth MAU | 50,000/ay | Giriş durur |
| Cloudflare Pages bant | Sınırsız | — |

> **Not:** Faz 1 MVP için bu limitler fazlasıyla yeterli. Büyümede Firebase Blaze planına geç.

## 🔧 Düzeltilmiş Kritik Kararlar (Denetim Sonrası)

### Kritik #1 — Firestore Güvenlik Kuralları (DÜZELTİLDİ)
Öğrenciler (unauthenticated) sınavı ve soruları okuyabilmeli.
- `exams/`: `status != 'draft'` ise herkes okuyabilir
- `questions/`: `exam.status in ['active','live']` ise herkes okuyabilir
- `exam_answers/`: SADECE öğretmen — doğru cevaplar burada, öğrenci okuyamaz

### Kritik #2 — Puanlama Mimarisi (DÜZELTİLDİ)
Puanlama Next.js öğrenci tarayıcısında DEĞİL, öğretmen Flutter uygulamasında yapılır.
- Öğrenci web: sadece `answers: { [questionId]: value }` yazar
- Öğretmen "Sınavı Bitir" → `ScoreCalculator.calculateAllScores(examId)` çağrılır
- Flutter uygulama `exam_answers/` okur (auth'lu), skorları hesaplar, session'lara yazar
- Öğrenci web `session.score` ve `session.percentage` okur

### Önemli #3 — Shuffle Sırası Kalıcı (DÜZELTİLDİ)
Session oluşturulurken shuffle hesaplanıp `questionOrder` ve `optionOrders` alanlarına kaydedilir.
Tarayıcı yenilenirse aynı sıra kullanılır → cevaplar kaybolmaz.

### Önemli #4 — Global Timer (DÜZELTİLDİ)
`globalTimerEndsAt` = sınav başlangıcı + toplam süre (RTDB'de sabit).
Tüm öğrenciler bu tek timestamp'e göre geri sayar.
Geç katılan öğrenci otomatik olarak daha az süre bulur.
**"Timer başından başlar" ifadesi kaldırıldı — bu yanlıştı.**

### Önemli #5 — Öğrenci Web URL Sabiti (DÜZELTİLDİ)
```dart
// lib/core/constants/app_constants.dart
const String kStudentWebBaseUrl = String.fromEnvironment(
  'STUDENT_WEB_URL',
  defaultValue: 'https://examkit.pages.dev',
);
const int kMaxStudentsPerExam = 99; // RTDB 100 limit - 1 öğretmen bağlantısı
// WhatsApp paylaşım linki: '$kStudentWebBaseUrl/join/${exam.code}'
```

```
# student_web/.env.local
NEXT_PUBLIC_STUDENT_WEB_URL=https://examkit.pages.dev
NEXT_PUBLIC_FIREBASE_API_KEY=...
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=...
NEXT_PUBLIC_FIREBASE_PROJECT_ID=...
NEXT_PUBLIC_FIREBASE_DATABASE_URL=...
```

### Önemli #6 — RTDB Bağlantı Limiti (DÜZELTİLDİ)
- Öğretmen Flutter uygulaması da RTDB'ye bağlanır = 1 bağlantı
- Gerçek maksimum öğrenci sayısı: **99** (100 - 1)
- `kMaxStudentsPerExam = 99` sabiti tanımlandı
- 99. öğrenci sonrası: "Sınav kapasitesi doldu" mesajı

---

`CLAUDE_CODE_PROMPT.md` dosyasını Claude Code'a ver. O dosya 26 ekranın tamamını adım adım inşa etmek için hazırlanmış tam geliştirme planını içerir.

Başlangıç komutu:
```
CLAUDE.md dosyasını oku, docs/phase_1/index.md'yi oku.
Ardından CLAUDE_CODE_PROMPT.md dosyasını eksiksiz oku.
AŞAMA 0'dan başla. Her aşamayı tamamladıktan sonra durup onay iste.
```

---

*Son güncelleme: Bkz. `docs/phase_1/logs/index.md`*  
*Sürüm: 1.0.0 — Phase 1 Başlangıç*
