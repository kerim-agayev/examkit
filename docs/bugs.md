# Bug Listesi ve Çözümleri

## Çözülen Bug'lar

### BUG-001: Firestore gRPC bağlantısı — "database does not exist"
- **Tarih:** 18-19 Haziran 2026
- **Semptom:** Tüm Firestore yazmaları local cache'te kalıyor, buluta sync olmuyor
- **Log:** `Firestore: [WriteStream] NOT_FOUND - The database (default) does not exist`
- **Çözüm:** Tüm veri katmanı RTDB'ye taşındı (ADR-001)

### BUG-002: Grup oluşturma / Sınav oluşturma sonsuz spinner
- **Semptom:** Kaydet butonuna basınca spinner dönüyor, UI kilitleniyor
- **Kök neden:** `finally` bloğunda `if (mounted) setState(() => _saving = false)` — widget dispose olunca `mounted` false, `_saving` hiç sıfırlanmıyor
- **Çözüm:** `_saving = false; if (mounted) setState(() {});` — önce değişkeni sıfırla, sonra rebuild

### BUG-003: "Bad state: Stream has already been listened to"
- **Semptom:** Soru listesi ekranında (adım 3) hata
- **Kök neden:** RTDB `onValue` single-subscription stream. `StreamProvider.autoDispose` recreate olunca ikinci kez dinlenemiyor
- **Çözüm:** `StreamController.broadcast()` + `ref.onDispose(() => sub.cancel())` pattern'i

### BUG-004: Sınav kodu ekrandan taşıyor
- **Semptom:** Share ekranında "right overflowed by 40 pixels"
- **Çözüm:** Sabit 48px kart yerine `MediaQuery` ile responsive genişlik

### BUG-005: Web sayfaları "Permission denied"
- **Semptom:** Join/Waiting/Exam sayfaları erişim hatası
- **Kök neden 1:** `getDatabase()` direkt çağrılıyor, Firebase app initialize edilmemiş → `No Firebase App [DEFAULT]`
- **Kök neden 2:** RTDB kuralları `auth != null` istiyor ama öğrenci auth'suz → `Permission denied`
- **Kök neden 3:** Parent node'larda `.read: true` eksik → listeleyemiyor
- **Çözüm:** `@/lib/firebase` → `getRtdb()`, kurallar güncellendi

### BUG-006: Bekleme odası "8 öğrenci" / Live Control sahte isimler
- **Semptom:** Statik veri gösteriliyor
- **Çözüm:** `watchLiveExamProvider` ve `subscribeToStudents` ile gerçek RTDB verisi

### BUG-007: Öğrenci tamamlayınca öğretmende "0/2"
- **Kök neden:** `finish()` sadece `sessions/{sid}` güncelliyor, `live_exams/{eid}/students/{sid}` güncellenmiyor
- **Çözüm:** `markCompleted()` çağrısı eklendi

### BUG-008: Öğrenci sonuçları göremiyor
- **Semptom:** "Öğretmen henüz puanlamadı" — sayfa yenileyince geliyor
- **Kök neden:** Results sayfası `get()` ile bir kere okuyor, puanlama async bitmemiş oluyor
- **Çözüm:** `onValue()` realtime listener — puanlama bitince otomatik güncellenir

### BUG-009: Grup listesinde "0 sınav"
- **Kök neden:** Sınav oluşturunca `groups/{id}/examCount` güncellenmiyor
- **Çözüm:** `exam_create_screen` ve `exam_provider` → `ServerValue.increment(1)` eklendi

## Bilinen Sorunlar (Henüz Çözülmedi)

### BUG-010: Öğrenci sınavdayken öğretmen bitirirse
- **Durum:** Exam sayfası `live_exams/{eid}/status: ended` dinliyor → sonuçlara yönleniyor. Test edilmesi lazım.

### BUG-011: WhatsApp paylaşımı
- **Durum:** Telefonda WhatsApp yoksa "bulunamadı" mesajı + panoya kopyalama çalışıyor. UX iyileştirilebilir.

### BUG-012: Student web'de Firebase Analytics
- **Durum:** `contentscript.js` hataları Chrome eklentilerinden (MetaMask), ExamKit kaynaklı değil.

---

## Audit Bulguları (19 Haziran 2026 — Son Kontrol)

### Mobil (Flutter) — Yeni Bulgular

| # | Severity | Bulgu |
|---|----------|-------|
| BUG-013 | **BLOCKER** | `student_detail_screen.dart` tamamen sahte veri. Öğrenci detay sayfası çalışmıyor |
| BUG-014 | **BLOCKER** | `cloud_firestore: ^5.0.0` pubspec.yaml'da hâlâ bağımlılık olarak duruyor → **BUG-013 ile birlikte düzeltildi** |
| BUG-015 | HIGH | `group_create_screen.dart` düzenleme modunda (`_isEdit`) bile yeni grup oluşturuyor (`push().key!`), mevcut grubu güncellemiyor |
| BUG-016 | HIGH | Home "Bugün" istatistik kartı hep `—` gösteriyor, veri kaynağı yok |
| BUG-017 | HIGH | `group_create_screen` ve `exam_create_screen` kendi provider'larını (`createGroupProvider`, `createExamProvider`) bypass edip inline RTDB yazıyor — kod tekrarı |
| BUG-018 | MEDIUM | l10n altyapısı var ama hiçbir ekran `AppLocalizations` kullanmıyor, hepsi hardcoded Türkçe string |
| BUG-019 | MEDIUM | 6 shared widget (`AppCard`, `AppTextField`, `AppButton`, `EmptyState`, `LoadingOverlay`, `ConfirmationDialog`) tanımlı ama hiçbiri kullanılmıyor |
| BUG-020 | MEDIUM | Question drag-to-reorder handle'ı var ama işlevsel değil |
| BUG-021 | LOW | `validators.dart`, `edge_case_helpers.dart` tanımlı ama import edilmemiş |

### Web (Next.js) — Yeni Bulgular

| # | Severity | Bulgu |
|---|----------|-------|
| BUG-022 | **BLOCKER** | Ana sayfa (`app/page.tsx`) Firestore kullanıyordu → **BUG-022 ile RTDB'ye taşındı** |
| BUG-023 | HIGH | `hooks/useExamSession.ts` (194 satır) hiçbir sayfa tarafından import edilmiyor — ölü kod |
| BUG-024 | HIGH | `stores/examStore.ts` (93 satır) sadece ölü kod tarafından kullanılıyor |
| BUG-025 | MEDIUM | 4/7 component kullanılmıyor: `QuestionCard`, `ConfirmDialog`, `TimerBar`, `ExamKitLogo` |
| BUG-026 | MEDIUM | `lib/firestore.ts` hâlâ projede, import eden kod var (`useExamSession.ts`) |
| BUG-027 | MEDIUM | `next.config.ts` ESLint ve TypeScript hatalarını ignore ediyor — gerçek sorunlar gizlenebilir |
| BUG-028 | LOW | Duplicate i18n: `lib/i18n.ts` ve `i18n/request.ts` aynı işlevi görüyor |
| BUG-029 | LOW | `getRtdb()!` null assertion — RTDB URL yanlışsa runtime crash |
