# ExamKit — Claude Code Tam Geliştirme Promptu

> Bu promptu Claude Code'a ver. Claude Code CLAUDE.md'yi okuyarak projeyi adım adım inşa edecek.
> 26 ekran: 19 Flutter (öğretmen) + 7 Next.js (öğrenci web, mobil-responsive)

---

## 🚀 BAŞLAMADAN ÖNCE — ZORUNLU

```
CLAUDE.md dosyasını eksiksiz oku. Ardından docs/phase_1/index.md'yi oku.
Tüm kuralları, stack'i, şemayı ve checklist'i anladıktan sonra geliştirmeye başla.
Her tamamlanan ekran sonrası:
  1. docs/phase_1/logs/YYYY-MM-DD_ekran-adi.md oluştur
  2. docs/phase_1/index.md checklist'ini güncelle ([x] yap)
  3. Hata varsa docs/phase_1/bugs/ ekle
```

---

## 📋 GELİŞTİRME SIRASI

```
AŞAMA 0: İki proje kurulumu (Flutter + Next.js)
AŞAMA 1: Firebase + Auth altyapısı
AŞAMA 2: Flutter — Auth akışı (4 ekran)
AŞAMA 3: Flutter — Ana sayfa + Navigasyon (1 ekran)
AŞAMA 4: Flutter — Grup yönetimi (3 ekran)
AŞAMA 5: Flutter — Sınav oluşturma (4 ekran)
AŞAMA 6: Flutter — Soru editörü (1 ekran, 3 tip)
AŞAMA 7: Flutter — Paylaşım (1 ekran)
AŞAMA 8: Flutter — Canlı kontrol (1 ekran)
AŞAMA 9: Flutter — Sonuçlar (2 ekran)
AŞAMA 10: Flutter — Ayarlar (1 ekran)
AŞAMA 11: Next.js — Proje kurulumu
AŞAMA 12: Next.js — Öğrenci katılım akışı (3 ekran)
AŞAMA 13: Next.js — Sınav ekranları (2 ekran + ortak bileşenler)
AŞAMA 14: Next.js — Sonuç (2 ekran)
AŞAMA 15: Lokalizasyon (AZ + TR her iki projede)
AŞAMA 16: Edge case'ler + hata yönetimi
AŞAMA 17: Son test + polish
```

---

## AŞAMA 0 — PROJE KURULUMU

### Flutter Projesi

```bash
flutter create flutter_app --org com.examkit --platforms ios,android
cd flutter_app
```

`pubspec.yaml`'a tüm bağımlılıkları ekle (CLAUDE.md §Teknoloji Yığını'na bak).
Şu klasör yapısını oluştur (CLAUDE.md §Klasör Yapısı'na bak):
```
lib/core/, lib/features/, lib/l10n/, lib/services/
```

Firebase kurulumu:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
`firebase_options.dart` üretildiğini doğrula.

`analysis_options.yaml` ekle — strict mode.
`lib/main.dart`'ı yaz: Firebase init, Riverpod ProviderScope, go_router, lokalizasyon.

### Next.js Projesi

```bash
npx create-next-app@15.5 student_web --typescript --tailwind --app --no-src-dir
cd student_web
npm install firebase zustand next-intl lucide-react
```

Şu klasör yapısını oluştur (CLAUDE.md §Klasör Yapısı'na bak):
```
app/, components/, hooks/, lib/, stores/, types/, messages/
```

Firebase web SDK'yı `lib/firebase.ts`'e init et.
`tailwind.config.ts`'i yapılandır — mobil-first breakpoint'ler.

---

## AŞAMA 1 — FIREBASE + AUTH ALTYAPISI

### Flutter Servisleri

`lib/core/constants/app_constants.dart` — YENİ (Önemli #5 düzeltmesi):
```dart
// Öğrenci web URL — WhatsApp/QR paylaşım linklerinde kullanılır
const String kStudentWebBaseUrl = String.fromEnvironment(
  'STUDENT_WEB_URL',
  defaultValue: 'https://examkit.pages.dev',
);
// WhatsApp linki: '$kStudentWebBaseUrl/join/${exam.code}'

// RTDB 100 limit - 1 öğretmen bağlantısı = 99 (Önemli #6 düzeltmesi)
const int kMaxStudentsPerExam = 99;

// Soru ve global timer limitleri (Küçük düzeltme #4)
const int kMinTimerSeconds = 5;
const int kMaxQuestionTimerSeconds = 300;
const int kMinGlobalTimerMinutes = 1;
const int kMaxGlobalTimerMinutes = 180;
```

`lib/services/auth_service.dart`:
- `signInWithGoogle()` — Firebase Auth + google_sign_in
- `signOut()`
- `authStateChanges` stream
- `updateProfile({name, school, lang})`

`lib/services/firestore_service.dart`:
- Generic CRUD yardımcıları
- Error wrapping (FirebaseException → AppException)

`lib/services/realtime_db_service.dart`:
- `watchLiveExam(examId)` stream
- `startExam(examId, globalTimerMinutes)` — globalTimerEndsAt hesaplar ve yazar
- `endExam(examId)` — status: completed yazar, ardından ScoreCalculator tetiklenir
- `studentJoined(examId, sessionId, name)`
- `updateStudentProgress(examId, sessionId, count)`
- `getStudentCount(examId)` — 99 limit kontrolü için

### Firestore Security Rules

`firestore.rules` dosyasını oluştur — **CLAUDE.md §Kritik #1 düzeltmesi** bölümünü kullan.
Öğrenciler (unauthenticated) `exams/` ve `questions/` okuyabilmeli.
`exam_answers/` koleksiyonu SADECE öğretmen okuyabilir.
`database.rules.json` dosyasını oluştur (RTDB teacherId tabanlı kurallar).

### Temel Modeller (Flutter)

Şu modelleri oluştur, her biri `fromFirestore()` + `toMap()` + `copyWith()` içermeli:
- `lib/features/auth/models/teacher_model.dart`
- `lib/features/groups/models/group_model.dart`
- `lib/features/exams/models/exam_model.dart`
- `lib/features/exams/models/exam_settings_model.dart`
- `lib/features/exams/models/question_model.dart` — **doğru cevap alanları YOK** (text+options+points+timer)
- `lib/features/exams/models/exam_answer_model.dart` — **YENİ**: correctOptionId/correctBool/acceptedAnswers
- `lib/features/live/models/live_exam_model.dart`
- `lib/features/results/models/session_model.dart` — questionOrder + optionOrders alanları içermeli

### Servis Sınıfları

`lib/features/results/services/score_calculator.dart` — **YENİ (Kritik #2 düzeltmesi)**:
- `calculateAllScores(String examId)` — öğretmen "Bitir" basınca çağrılır
- `exam_answers/` koleksiyonundan doğru cevapları okur (öğretmen auth'lu)
- Tüm session'lar için skor hesaplar, Firestore'a batch write yapar
- Sıralama hesaplar (score DESC, duration ASC)
- Exam status → `completed` yazar
- Tam implementasyon için `docs/phase_1/architecture/api_design.md` §ScoreCalculator bölümünü kullan

### Shared Widgets

`lib/core/widgets/` içinde:
- `AppButton` — primary / secondary / danger varyantları, loading state
- `AppTextField` — özelleştirilmiş, hata mesajı desteği
- `AppCard` — standart kart
- `LoadingOverlay` — full-screen loading
- `ConfirmationDialog` — onay diyaloğu, geri alınamaz işlemler için
- `EmptyState` — ikon + başlık + açıklama

`lib/core/theme/app_theme.dart`:
- MaterialTheme light
- Primary color, typography, button shapes
- Min dokunma hedefi 48dp (60+ yaş uyumu)

---

## AŞAMA 2 — FLUTTER AUTH AKIŞI (4 Ekran)

### Ekran 1: Splash (`lib/features/auth/screens/splash_screen.dart`)

- Uygulama açılışında gösterilir, 1.5sn
- Firebase Auth durumunu kontrol et
- Oturum açıksa → Home'a yönlendir
- Oturum yoksa → Onboarding'e yönlendir (ilk kez) veya Login'e yönlendir

### Ekran 2: Onboarding (`lib/features/auth/screens/onboarding_screen.dart`)

- Sadece ilk açılışta gösterilir (SharedPreferences ile kontrol)
- 3 sayfa: "Anında sınav oluştur" / "WhatsApp ile paylaş" / "Canlı sonuçları takip et"
- Her sayfada büyük ikon + başlık + kısa açıklama
- Alt kısımda "Başla" butonu
- Sayfa göstergeleri (dots)

### Ekran 3: Login (`lib/features/auth/screens/login_screen.dart`)

- Uygulama logosu / ismi
- "Google ile Giriş Yap" butonu (tam genişlik, büyük)
- Loading state: butonu devre dışı bırak, spinner göster
- Hata durumunda SnackBar
- ASLA SMS OTP ekleme

### Ekran 4: Profil Kurulumu (`lib/features/auth/screens/profile_setup_screen.dart`)

- Sadece ilk girişte gösterilir (Firestore'da profil yoksa)
- Ad Soyad (zorunlu TextField)
- Okul Adı (isteğe bağlı TextField)
- Dil Seçimi: "Azərbaycan dili" / "Türkçe" (iki büyük kart, birini seç)
- "Devam Et" butonu (ad girilmeden devre dışı)
- Firestore'a `users/{uid}` oluştur

**go_router rotaları:** `/splash`, `/onboarding`, `/login`, `/profile-setup`

**Auth provider:** `lib/features/auth/providers/auth_provider.dart`
- Riverpod StreamProvider ile Firebase auth state dinle
- İlk giriş kontrolü
- Redirect mantığı go_router'a entegre et

---

## AŞAMA 3 — FLUTTER ANA SAYFA + NAVİGASYON (1 Ekran)

### Ekran 5: Ana Sayfa / Shell (`lib/features/home/screens/home_screen.dart`)

**Alt Navigasyon Çubuğu** (NavigationBar widget):
- Ana Sayfa (home ikon)
- Gruplar (people ikon)
- Sınavlar (assignment ikon)
- Ayarlar (settings ikon)
- Her sekmenin etiketi görünür, aktif sekme vurgulu

**Dashboard İçeriği:**
- Karşılama metni: "Merhaba [Öğretmen Adı]"
- 3 istatistik kartı (Row):
  - Toplam grup sayısı (Firestore'dan)
  - Toplam sınav sayısı (Firestore'dan)
  - Bugünkü katılımcı sayısı (sessions sorgusu)
- 2 büyük hızlı aksiyon butonu (Column, tam genişlik, yüksek):
  - "Yeni Grup Oluştur" → `/groups/new`
  - "Yeni Sınav Oluştur" → `/exams/new`
- Son 5 sınav listesi:
  - Sınav adı + grup adı + tarih + durum
  - Durum renk kodlaması: mavi=taslak, turuncu=aktif/canlı, yeşil=tamamlandı
  - Dokun → sınav detayı

**Riverpod:** `dashboardStatsProvider` (Firestore'dan aggregated stats)

---

## AŞAMA 4 — FLUTTER GRUP YÖNETİMİ (3 Ekran)

### Ekran 6: Grup Listesi (`lib/features/groups/screens/group_list_screen.dart`)

- AppBar: "Gruplarım" + "+" FAB (yeni grup)
- Arama çubuğu (üstte, TextField)
- Boşsa EmptyState: "Henüz grup yok" + "Oluştur" butonu
- Liste: son kullanılana göre sıralı
- Her kart:
  - Grup adı (bold) + oluşturma tarihi
  - Alt satır: kaç sınav yapıldı + son kullanım
  - Uzun basma: Düzenle / Sil menüsü (BottomSheet)
- Silme: ConfirmationDialog + aktif sınav kontrolü

**Provider:** `groupListProvider` → Firestore real-time stream

### Ekran 7: Grup Oluşturma (`lib/features/groups/screens/group_create_screen.dart`)

- AppBar: "Yeni Grup" + "Kaydet" (sağda)
- Grup Adı TextField (zorunlu, max 60 karakter, sayaç)
- Açıklama TextField (isteğe bağlı, max 200 karakter)
- Kaydet → Firestore'a yaz → liste ekranına dön
- Düzenleme modu: aynı ekran, başlık "Grubu Düzenle"
- Loading state kaydet butonunda

### Ekran 8: Grup Detayı (`lib/features/groups/screens/group_detail_screen.dart`)

- AppBar: Grup adı + Düzenle ikonu
- Üstte stat kartları: toplam sınav, toplam öğrenci (unique), son aktivite
- "Bu Grupla Sınav Oluştur" butonu
- Geçmiş sınavlar listesi:
  - Sınav adı + tarih + katılımcı sayısı + ortalama puan
  - Dokun → sınav sonuçlarına git
- Boşsa: "Henüz sınav yapılmadı"

---

## AŞAMA 5 — FLUTTER SINAV OLUŞTURMA (4 Ekran)

### Ekran 9: Sınav Listesi (`lib/features/exams/screens/exam_list_screen.dart`)

- AppBar: "Sınavlarım" + "+" FAB
- Filtre sekmeleri: Tümü / Taslak / Aktif / Tamamlandı
- Her sınav kartı:
  - Başlık + grup adı
  - Durum badge + soru sayısı + tarih
  - Dokun → sınav durumuna göre yönlendir:
    - draft → soru listesi
    - active → paylaşım ekranı
    - live → canlı kontrol
    - completed → sonuçlar
  - Uzun basma: Düzenle / Sil / Paylaş (sadece draft silinebilir)
- Boşsa EmptyState

### Ekran 10: Sınav Oluşturma — Adım 1 (`lib/features/exams/screens/exam_create_screen.dart`)

- AppBar: "Yeni Sınav" + ilerleme göstergesi "1 / 5"
- Sınav Başlığı TextField (zorunlu, max 100 karakter)
- Grup Seçimi:
  - Dropdown veya BottomSheet ile gruplar listelenir
  - Her grup: ad + son kullanım tarihi
  - "+ Yeni Grup Oluştur" kısayolu
- "Devam Et" butonu (başlık + grup seçilmeden devre dışı)
- Firestore'da draft sınav oluştur, examId al, devam et

### Ekran 11: Sınav Ayarları — Adım 2 (`lib/features/exams/screens/exam_settings_screen.dart`)

- AppBar: sınav başlığı + "2 / 5"
- **12 ayarı aşağıdaki düzende göster:**

  **Sınav Modu** (RadioListTile, seçimli):
  - Scroll modu: "Tüm sorular görünür, öğrenci serbestçe gezer"
  - Sequential modu: "Soru soru, geri dönülemez, zorunlu cevap"

  **Zamanlama:**
  - Global Timer Toggle + Slider (1–180 dakika, kapalıysa gizle)
  - Soru Başı Timer Toggle (açıksa sorulara ayrı timer atanabilir)

  **Anti-Hile:**
  - Soru Karıştırma Toggle
  - Şık Karıştırma Toggle

  **Öğrenciye Görünürlük (3 ayrı Toggle):**
  - Puanı göster
  - Doğru cevapları göster
  - Sıralamayı göster

  **Diğer:**
  - Geç Katılım İzni Toggle

  Alt kısım: "Geri" + "Devam Et"
  Her değişiklik Firestore'a anlık kaydet

### Ekran 14: Sınav Önizleme — Adım 4 (`lib/features/exams/screens/exam_preview_screen.dart`)

- AppBar: "Önizleme" + "4 / 5"
- Seçilen moda göre sınavı simüle et:
  - Scroll: tüm sorular listelenir, şıklar tıklanamaz (sadece görsel)
  - Sequential: tek soru görünümü simülasyonu (sayfalandırılmış)
- Alt kısımda özet: X soru · Y toplam puan · [mod adı]
- "Geri Dön ve Düzenle" + "Yayınla" butonları
- Yayınla → **Firestore transaction** içinde: kod üret + status 'active' yap (Küçük #1 atomiklik düzeltmesi)
- Transaction başarılıysa paylaşım ekranına geç

**Sınav Kodu Üretimi (`lib/core/utils/exam_code_generator.dart`):**
- 6 karakter: büyük harf + rakam, I/O/0/1 hariç
- Firestore transaction içinde benzersizlik kontrolü (collision varsa yeniden üret, max 10 deneme)

---

## AŞAMA 6 — FLUTTER SORU EDITÖRÜ (1 Ekran, 3 Tip)

### Ekran 12: Soru Listesi — Adım 3 (`lib/features/exams/screens/question_list_screen.dart`)

- AppBar: "Sorular" + "3 / 5" + soru sayısı
- Üstte toplam puan göstergesi (dinamik)
- ReorderableListView: drag-drop ile sıralama
- Her soru kartı:
  - Soru tipi badge (ÇSM / D-Y / KA) + soru metni (truncated) + puan
  - Sağda: düzenle ikon + sil ikon
- Boşsa: EmptyState + büyük "+" butonu
- Alt kısım: "+ Soru Ekle" BottomSheet (3 tip seç)
  - "Çoktan Seçmeli" | "Doğru / Yanlış" | "Kısa Cevap"
- Seçince → Soru Oluşturma ekranına git
- "Önizleme" butonu (Adım 4'e geç)

### Ekran 13: Soru Oluşturma (`lib/features/exams/screens/question_create_screen.dart`)

Aynı ekran 3 moda göre farklı içerik render eder.

**Ortak Alanlar (her tipte):**
- Soru Metni TextField (max 500 karakter, satır sayacı)
- Puan Atama: sayısal input, min 1 max 100, varsayılan 1
- Soru Başı Timer: Toggle + süre seçici (5–300 sn)
  - **Küçük #4 düzeltmesi:** Soru timer'ı global timerdan büyük olamaz.
    Global timer aktifse validasyon: `timerSeconds <= (globalTimerMinutes * 60)`
    Aşılırsa: "Soru süresi genel sınav süresini aşamaz" hata mesajı.
- "Önizle" butonu (modal)
- "Kaydet" butonu

**Kaydetme mimarisi (Kritik #2 düzeltmesi):**
```dart
// Soru kaydedilirken iki Firestore yazması batch halinde yapılır:
final batch = firestore.batch();

// 1. Görüntüleme verisi — öğrenci okuyabilir
batch.set(
  examRef.collection('questions').doc(questionId),
  questionModel.toMap(),  // text, options (şık metinleri), points, timer, orderIndex
);

// 2. Doğru cevaplar — SADECE öğretmen okuyabilir
batch.set(
  examRef.collection('exam_answers').doc(questionId),
  answerModel.toMap(),    // correctOptionId / correctBool / acceptedAnswers
);

await batch.commit();
```

**MCQ Modu (`type: 'mcq'`):**
- 4 şık TextField (A, B, C, D — her biri max 200 karakter)
- Her şık yanında radio button: "Doğru cevap bu"
- Doğru seçili şık yeşil çerçeveli
- En az 2 şık dolu olmadan kayıt edilemez
- Doğru cevap seçilmeden kayıt edilemez
- Kaydetme: QuestionModel (metin+şıklar) + ExamAnswerModel (correctOptionId) → batch write

**True/False Modu (`type: 'true_false'`):**
- Sadece soru metni
- "Doğru" / "Yanlış" iki büyük seçim kartı
- Biri seçilmeden kayıt edilemez
- Kaydetme: QuestionModel + ExamAnswerModel (correctBool) → batch write

**Short Answer Modu (`type: 'short_answer'`):**
- Soru metni
- "Kabul Edilen Cevaplar" bölümü:
  - İlk cevap TextField (zorunlu)
  - "+ Alternatif ekle" butonu (max 5 alternatif)
  - Her alternatif silinebilir
  - Açıklama: "Büyük/küçük harf duyarsız eşleşme"
- Kaydetme: QuestionModel + ExamAnswerModel (acceptedAnswers: []) → batch write

---

## AŞAMA 7 — FLUTTER PAYLAŞIM EKRANI (1 Ekran)

### Ekran 15: Paylaşım (`lib/features/exams/screens/exam_share_screen.dart`)

- AppBar: "Sınavı Paylaş" + "5 / 5"
- Büyük sınav kodu göstergesi:
  - Monospace font, büyük (48sp), belirgin arka plan
  - Altında "Kod geçerlilik: Sınav tamamlanana kadar"
- **4 büyük aksiyon kartı (2x2 grid):**
  1. **WhatsApp** — Yeşil ikon, "WhatsApp'ta Paylaş"
     - share_plus ile WhatsApp deep link
     - Mesaj: dil seçimine göre AZ veya TR (l10n'den)
     - TR: "📚 [Sınav Adı] başlıyor!\nKatılmak için: [link]\nKod: [kod]"
     - AZ: "📚 [Sınav Adı] başlayır!\nQoşulmaq üçün: [link]\nKod: [kod]"
  2. **QR Kod** — BottomSheet'te büyük QR göster
     - qr_flutter paketi, ekranda göster + ekran görüntüsüne kaydet butonu
  3. **Linki Kopyala** — "Kopyalandı!" SnackBar
  4. **Diğer** — share_plus sistem paylaşımı
- Alt kısım: "Canlı Kontrole Git" büyük butonu (öğrenci bekliyorsa badge)
- **Link formatı (Önemli #5 düzeltmesi):** `'$kStudentWebBaseUrl/join/${exam.code}'`
  `kStudentWebBaseUrl` sabiti `app_constants.dart`'tan gelir.

---

## AŞAMA 8 — FLUTTER CANLI KONTROL (1 Ekran)

### Ekran 16: Canlı Kontrol (`lib/features/live/screens/live_exam_screen.dart`)

Bu ekran Firebase Realtime Database ile çalışır.

**Üst Alan:**
- Sınav adı + durum (Bekleniyor / Canlı)
- Bağlantı durumu göstergesi (wifi ikon)
- Timer aktifse: geri sayım `globalTimerEndsAt - now` (MM:SS, son 5dk sarı, son 1dk kırmızı)

**Bekleme Aşaması (status: waiting):**
- "Bekleme Odasında: X öğrenci" sayacı
- Öğrenci listesi (real-time, her katılan anında eklenir):
  - Ad Soyad + katılım zamanı, liste animasyonlu
- "Sınavı Başlat" büyük butonu:
  - Sıfır öğrenci varsa devre dışı + "Öğrenci bekleniyor..." metni
  - Tıklanınca ConfirmationDialog: "X öğrenci hazır, başlatılsın mı?"
  - Onayda: `liveExamRepository.startExam(examId, globalTimerMinutes)`
    - RTDB'ye: status='active', startedAt=now, globalTimerEndsAt=now+(dk×60000), teacherId

**Aktif Aşama (status: active):**
- Üstte sayaçlar: Tamamlayan X / Y öğrenci
- Öğrenci listesi (RTDB real-time):
  - Ad Soyad + ilerleme çubuğu "X/Y soru"
  - ✅ tamamladı (yeşil) / 🔵 devam (mavi) / ⚪ başlamadı (gri)
- "Sınavı Bitir" butonu (kırmızı):
  - 0 öğrenci katılmadıysa: "Hiç öğrenci katılmadı, yine de bitir?" diyaloğu (Küçük #5)
  - X öğrenci devam ediyorsa: "X öğrenci henüz bitmedi, yine de bitir?" diyaloğu
  - **Onayda sırasıyla (Kritik #2 düzeltmesi):**
    ```dart
    // 1. RTDB'de sınav kapat
    await liveExamRepository.endExam(examId);
    // 2. Tüm session'ları puan — öğretmen auth'lu, exam_answers okuyabilir
    await scoreCalculator.calculateAllScores(examId);
    // 3. Firestore exam status → 'completed' (ScoreCalculator zaten yapıyor)
    // 4. Sonuç ekranına geç
    context.go('/exams/$examId/results');
    ```
  - Puanlama süresince: LoadingOverlay ("Sonuçlar hesaplanıyor...")
  - Hata olursa: SnackBar + retry butonu

**Otomatik Geçiş:** Global timer `globalTimerEndsAt` dolunca RTDB status → completed.
Flutter provider bu değişikliği yakalar → `scoreCalculator.calculateAllScores()` → sonuçlara yönlendir.

---

## AŞAMA 9 — FLUTTER SONUÇLAR (2 Ekran)

### Ekran 17: Sınav Sonuçları (`lib/features/results/screens/exam_results_screen.dart`)

**Üst Özet Kartı:**
- Sınav adı + tarih + grup adı
- 4 stat: Katılımcı sayısı | Ortalama puan | En yüksek | Geçme oranı

**Puan Dağılımı Grafiği:**
- Basit bar grafik (5 sütun: 0-20%, 20-40%, 40-60%, 60-80%, 80-100%)
- Flutter'da CustomPaint veya fl_chart (ekstra bağımlılık ekleme, CustomPaint kullan)

**Liderboard Listesi:**
- Sıralanmış öğrenci listesi (score DESC, duration ASC)
- İlk 3: 🥇🥈🥉 rozet
- Her satır: sıra no | ad soyad | puan / toplam | süre | yüzde
- Dokun → öğrenci detay ekranı

**Soru Analizi Bölümü:**
- Her soru: doğruluk yüzdesi + renk kodu
  - %90+ → yeşil (kolay)
  - %60-90 → sarı (orta)
  - %60 altı → kırmızı (zor/problematik)

### Ekran 18: Öğrenci Detayı (`lib/features/results/screens/student_result_screen.dart`)

- AppBar: öğrenci adı
- Özet: puan / toplam | yüzde | süre | sınıftaki sırası
- Soru soru cevap listesi:
  - Soru metni (truncated)
  - Öğrencinin cevabı: doğruysa yeşil ✓, yanlışsa kırmızı ✗ + doğru cevap
  - Boşsa: gri "-"
- MCQ yanlışlarda: öğrencinin seçtiği şık da gösterilir

---

## AŞAMA 10 — FLUTTER AYARLAR (1 Ekran)

### Ekran 19: Ayarlar (`lib/features/settings/screens/settings_screen.dart`)

- AppBar: "Ayarlar"
- Profil Bölümü:
  - Google profil fotoğrafı (CircleAvatar)
  - Ad Soyad (düzenlenebilir)
  - Okul Adı (düzenlenebilir)
  - "Kaydet" butonu
- Dil Bölümü:
  - "Uygulama Dili:" başlığı
  - "Azərbaycan dili" / "Türkçe" seçim kartları
  - Değişince anlık l10n güncelle (uygulama restart gerekmez)
- Hakkında Bölümü:
  - Uygulama adı + versiyon
- Çıkış Yap:
  - Kırmızı metin butonu, alt kısımda
  - ConfirmationDialog: "Çıkış yapmak istediğinizden emin misiniz?"
  - Onayda Firebase signOut → login ekranına yönlendir

---

## AŞAMA 11 — NEXT.JS PROJE KURULUMU

`student_web/` klasöründe:

`lib/firebase.ts` — Firebase init (singleton):
```typescript
// FIREBASE_API_KEY vb. env variables .env.local'den
```

`stores/examStore.ts` — Zustand store:
```typescript
interface ExamStore {
  exam: Exam | null;
  questions: Question[];      // Görüntüleme verisi (doğru cevap YOK)
  questionOrder: string[];    // Shuffle'dan gelen sabit sıra (Önemli #3)
  optionOrders: Record<string, string[]>; // MCQ şık sırası
  sessionId: string | null;
  studentName: string | null;
  status: 'waiting' | 'active' | 'completed';
  answers: Record<string, string | boolean | null>;
  timeLeft: number | null;    // globalTimerEndsAt - Date.now() ile hesaplanır
  // Aksiyonlar:
  setAnswer, submitExam, setStatus, restoreFromStorage
}
```

`types/index.ts` — Tüm TypeScript tipleri:
```typescript
// Question: text, options (metinler), points, timerSeconds — doğru cevap YOK
// ExamSettings: mode, globalTimerMinutes, shuffle flags, visibility flags
// Session: answers, score, percentage, rank, questionOrder, optionOrders
```

`messages/az.json` + `messages/tr.json` — Tüm string'ler

`middleware.ts` — next-intl locale tespiti

`app/layout.tsx` — Root layout, Firebase + i18n provider

`tailwind.config.ts` — Mobil-first config:
- Container max-width: 480px (mobil web için)
- Büyük dokunma hedefleri (min-h-12, p-4)

**Responsive kural:** Tüm öğrenci sayfaları hem mobil (375px) hem desktop'ta güzel görünmeli. Ancak tasarım **mobil öncelikli** — öğrencilerin %90'ı telefon kullanır.

---

## AŞAMA 12 — NEXT.JS ÖĞRENCİ KATILIM AKIŞI (3 Ekran)

### Ekran 1: Kod Giriş / Ana Sayfa (`app/page.tsx`)

**Mobil-First Layout:**
- Merkez hizalı, tam ekran yükseklik (min-h-dvh)
- Uygulama logosu/adı (büyük, üstte)
- Sınav kodu giriş alanı:
  - Büyük input (text-xl, p-4), otomatik büyük harfe çevirme
  - 6 karakter limiti, inputMode="text"
- "Sınava Katıl" butonu (tam genişlik, büyük, primary renk)
- Hata mesajı: "Geçersiz kod, lütfen tekrar deneyin"
- Loading state: spinner + buton devre dışı

**Mantık:**
```typescript
const exam = await getExamByCode(code);  // status != 'draft' olan sınavı bul
if (!exam) → "Geçersiz kod" hatası
if (exam.status === 'completed') → "Bu sınav sona erdi" hatası
if (exam.status === 'draft') → "Sınav henüz paylaşılmadı" hatası
// Geçerliyse /join/[code]'a yönlendir
```

**URL'den direkt giriş:** `/join/[code]` parametresi varsa validasyon atlanır, direkt ad girişine geç.

### Ekran 2: Ad-Soyad Girişi (`app/join/[code]/page.tsx`)

**Mobil-First Layout:**
- Üstte sınav başlığı + grup adı (Firestore'dan çek)
- "Adınızı girin" başlığı
- Ad TextField (büyük, zorunlu) + Soyad TextField (büyük, zorunlu)
- "Sınava Katıl" butonu (her ikisi doluyken aktif)

**Mantık (Kritik #1 + Önemli #3 + Küçük #2 düzeltmeleri):**
```typescript
// 1. Sınav kapalıysa veya 99 öğrenci varsa engelle (Önemli #6)
const studentCount = await getStudentCount(examId);
if (studentCount >= 99) throw new Error('CAPACITY_FULL');

// 2. Soruları çek (questions/ koleksiyonu — doğru cevap YOK)
const questions = await getExamQuestions(examId);
const questionIds = questions.map(q => q.id);

// 3. Session oluştur — shuffle hesapla ve kaydet (Önemli #3)
const { sessionId, questionOrder, optionOrders } = await createSession({
  examId,
  studentName: `${firstName} ${lastName}`,
  questionIds,
  shuffleQuestions: exam.settings.shuffleQuestions,
  shuffleOptions: exam.settings.shuffleOptions,
});
// createSession içinde:
//   - Firestore transaction: aynı isim var mı kontrol → "(2)" ekle (Küçük #2)
//   - questionOrder ve optionOrders session'a kaydedilir
//   - Tarayıcı yenilenirse bu sabit sıralar kullanılır

// 4. Kaydedilen sıraları ve sessionId'yi localStorage'a yaz
localStorage.setItem('examSessionId', sessionId);
localStorage.setItem(`questionOrder_${sessionId}`, JSON.stringify(questionOrder));
localStorage.setItem(`optionOrders_${sessionId}`, JSON.stringify(optionOrders));

// 5. RTDB'de bekleme odasına katıl
await joinWaitingRoom(examId, sessionId, displayName);

// 6. /waiting/[sessionId]'ye yönlendir
```

### Ekran 3: Bekleme Odası (`app/waiting/[sessionId]/page.tsx`)

`'use client'` — RTDB real-time subscription.

**Mantık:**
```typescript
// RTDB subscribeToExamStatus:
// status "active" → /exam/[sessionId] otomatik yönlendirme
// status "completed" → "Sınav sona erdi" mesajı
```

**Mobil-First Layout:**
- Animasyonlu bekleme göstergesi (pulse)
- "Öğretmen başlatmayı bekleyin..." büyük metin
- Sınav adı + "Bekleme odasında: X öğrenci" (RTDB real-time)
- Öğrencinin adı: "Katılan: [Ad Soyad] ✓"


---

## AŞAMA 13 — NEXT.JS SINAV EKRANLARI (2 Ekran + Bileşenler)

**Önce ortak bileşenleri oluştur:**

`components/exam/QuestionCard.tsx`:
- MCQ, True/False, Short Answer her tipini render eder
- Seçili cevap highlight (ring border)
- Dokunma hedefi büyük (min-h-14 per option)

`components/exam/MCQOptions.tsx`:
- 4 şık büyük buton
- Seçili: primary renk fill
- Seçilmemiş: outline

`components/exam/TrueFalseOptions.tsx`:
- İki büyük buton: "Doğru" ve "Yanlış"
- Yatay yerleşim

`components/exam/ShortAnswerInput.tsx`:
- Büyük textarea
- max 150 karakter

`components/exam/GlobalTimer.tsx` — (Önemli #4 düzeltmesi):
```typescript
// globalTimerEndsAt: RTDB'den gelen sabit timestamp
// Tüm öğrenciler aynı bitiş zamanını kullanır
// Geç katılan otomatik olarak daha az süre görür
// Server clock skew: RTDB /.info/serverTimeOffset ile düzelt

function getRemainingMs(globalTimerEndsAt: number, serverOffset: number): number {
  const serverNow = Date.now() + serverOffset;
  return Math.max(0, globalTimerEndsAt - serverNow);
}
// remaining 0 olunca: otomatik completeSession() çağır
```
- Üst çubuk, sabit (sticky), MM:SS format
- Son 5dk: sarı arka plan
- Son 1dk: kırmızı arka plan + titreme animasyonu
- Süre dolunca: toast "Süre doldu!" + `completeSession()`

`components/exam/QuestionTimer.tsx`:
- Soru başı timer (sadece sequential modda)
- Dairesel countdown veya bar

`components/exam/ProgressBar.tsx`:
- "X / Y soru cevaplandı"
- Renkli ilerleme çubuğu

### Ekran 4: Scroll Modu Sınav (`app/exam/[sessionId]/page.tsx` — mode: scroll)

**Mobil-First Layout:**
```
[Global Timer Bar — sticky top]
[Sınav başlığı]
[Progress Bar: X/Y]
[Soru 1 Card]
[Soru 2 Card]
...
[Soru N Card]
[Gönder Butonu — sticky bottom]
```

**Mantık (Kritik #1 + Önemli #3 düzeltmeleri):**
```typescript
// 1. Session ve soruları yükle
const session = await getSession(sessionId);
const questions = await getExamQuestions(session.examId);

// 2. Shuffle sırası — session'dan gelen SABIT sıra kullan (Önemli #3)
const orderedQuestions = session.questionOrder
  ? session.questionOrder.map(id => questions.find(q => q.id === id)!)
  : questions;  // shuffle kapalıysa orijinal sıra

// 3. MCQ şık sırası
const optionOrders = session.optionOrders ?? {};

// 4. Önceki cevapları localStorage'dan restore et
const savedAnswers = JSON.parse(localStorage.getItem(`answers_${sessionId}`) ?? '{}');

// 5. Cevap her tıklamada:
//   a. Zustand state güncelle
//   b. localStorage güncelle (yenilemeye karşı)
//   c. Firestore saveAnswer() async (retry on fail)
//   d. RTDB updateProgress(answeredCount) — debounced (her 3 cevaptan sonra)

// 6. Gönder tıklanınca:
//   - Yanıtsız soru varsa: confirm dialog
//   - Onayda: completeSession() → /results/[sessionId]

// 7. globalTimerEndsAt dolunca: auto completeSession() (no confirm)
```

### Ekran 5: Sequential Modu Sınav (`app/exam/[sessionId]/page.tsx` — mode: sequential)

**Mobil-First Layout:**
```
[Global Timer Bar — sticky top]
[Soru X / Y göstergesi]
[Soru Timer Bar — eğer açıksa]
[Mevcut Soru Card — tek, büyük]
[İlerle / Tamamla Butonu — sticky bottom]
```

**Mantık:**
```typescript
// Sadece currentIndex'teki soru görünür
// SORUŞTURMA ADIMI (ADR-005 Sequential Mode UX):
//   1. Öğrenci bir seçeneğe DOKUNUR → cevap highlight (primary border + primary-light bg)
//      → "İlerle" butonu aktifleşir (disabled → enabled)
//      → 5 saniye içinde seçim değiştirilebilir
//   2. "İlerle" butonuna TEKRAR DOKUNUR → cevap kilitlenir:
//      a. Firestore saveAnswer()
//      b. localStorage güncelle
//      c. currentIndex++
//      d. confirmAdvance = false (reset)
//   3. Son soruda: "Sınavı Tamamla" butonu → CONFIRM DIALOG:
//      "Cevaplarınız gönderilecek, geri alınamaz. [Geri Dön] [Evet, Tamamla]"
//   4. Lock-in animasyonu: seçim bounce scale(1.03) 300ms → çift dokunuşu engeller
//
// SORU TIMER (varsa):
//   - Son 5 saniye: geri sayım animasyonu (5→4→3→2→1 warning color)
//   - 0'da: cevap verildiyse → kaydet ve geç; verilmediyse → boş kaydet, otomatik currentIndex++
//   - Öğrenci geri sayım sırasında manuel "İlerle" ile geçebilir
//
// GLOBAL TIMER sıfırlanınca: otomatik completeSession()
```

---

## AŞAMA 14 — NEXT.JS SONUÇ (2 Ekran)

### Ekran 6: Sınav Tamamlandı (`app/exam/[sessionId]/page.tsx` — completed state)

- Kısa geçiş animasyonu (confetti CSS veya checkmark animation)
- "Sınav Tamamlandı! 🎉" büyük başlık
- Spinner: "Sonuçlar hesaplanıyor..."
- Arka planda completeSession() ve skor hesapla
- Otomatik /results/[sessionId]'ye yönlendir (1-2sn sonra)

### Ekran 7: Sonuçlar (`app/results/[sessionId]/page.tsx`)

**Mobil-First Layout:**
```
[Büyük skor kartı]
[Doğru/Yanlış/Boş özeti]
[Sınıf sırası — öğretmen izni varsa]
[Liderboard — öğretmen izni varsa]
[Cevap İnceleme — öğretmen izni varsa]
```

**Büyük Skor Kartı:**
- "38 / 50 puan" (büyük, bold)
- "%76" (çok büyük, renkli)
- Sınıftaki sıra: "Sınıfta 4. sıradasınız" (öğretmen izni varsa)
- Süre: "22 dakika 14 saniyede tamamlandı"

**Doğru/Yanlış Özeti:**
- 3 kutucuk yan yana: ✅ Doğru X | ❌ Yanlış Y | ⭕ Boş Z

**Liderboard (showLeaderboard = true):**
- İlk 5 öğrenci sıralı (Firestore'dan)
- Kendi sırası vurgulu

**Cevap İnceleme (showCorrectAnswers = true):**
- Her soru için:
  - Soru metni
  - Öğrencinin cevabı: ✅ doğruysa yeşil / ❌ yanlışsa kırmızı
  - Doğru cevap (yanlışsa göster)

---

## AŞAMA 15 — LOKALİZASYON

### Flutter (`.arb` dosyaları)

`lib/l10n/app_az.arb` — Azerbaycan Türkçesi:
```json
{
  "@@locale": "az",
  "appTitle": "İmtahan Tətbiqi",
  "createGroup": "Qrup yarat",
  "createExam": "İmtahan yarat",
  "shareViaWhatsapp": "WhatsApp ilə paylaş",
  "whatsappMessage": "📚 {examTitle} başlayır!\nQoşulmaq üçün: {link}\nKod: {code}",
  "startExam": "İmtahanı başlat",
  "waitingStudents": "{count} şagird gözləyir",
  "examCompleted": "İmtahan başa çatdı",
  ...
}
```

`lib/l10n/app_tr.arb` — Türkçe:
```json
{
  "@@locale": "tr",
  "appTitle": "Sınav Uygulaması",
  "createGroup": "Grup oluştur",
  ...
}
```

`pubspec.yaml`'a lokalizasyon ekle:
```yaml
flutter:
  generate: true
flutter_intl:
  arb_dir: lib/l10n
```

### Next.js

`messages/az.json` + `messages/tr.json` içinde tüm UI string'leri.
Browser dili: `az` veya `tr` otomatik algıla, desteklenmiyorsa `az` varsayılan.

---

## AŞAMA 16 — EDGE CASE'LER + HATA YÖNETİMİ (Denetim Sonrası Güncellenmiş)

### Flutter Edge Cases:

1. **Çevrimdışı durum:** `connectivity_plus` ile ağ durumu izle. Offline iken Firebase işlemleri queue'da beklesin (Firestore offline persistence açık). Scaffold'da bağlantı durumu banner'ı göster.

2. **Canlı kontrol — öğretmen bağlantı kesilmesi:** RTDB `onDisconnect()` sınav durumunu korur. Yeniden bağlanınca sync. Öğrenciler etkilenmez.

3. **Aktif sınav varken grup silme engeli:**
```dart
// Firestore'da bu gruba ait active/live sınav var mı kontrol et
// Varsa: "Bu grupta aktif sınav var, önce sınavı bitirin" hatası
```

4. **Boş sınav yayınlama engeli:**
```dart
// questionCount == 0 ise Yayınla butonu disabled + tooltip
```

5. **publishExam atomikliği (Küçük #1):**
```dart
await firestore.runTransaction((tx) async {
  final code = await _generateUniqueCode(tx);
  tx.update(examRef, {'status': 'active', 'code': code, 'updatedAt': now});
});
// Transaction hata verirse retry (max 3 kez)
```

6. **0 öğrencili sınav bitirme (Küçük #5):**
```dart
final count = await liveExamRepository.getStudentCount(examId);
if (count == 0) {
  // ConfirmationDialog: "Hiç öğrenci katılmadı, yine de bitir?"
}
// Onayda scoreCalculator.calculateAllScores(examId) — boş çalışır
```

7. **Soru başı timer validasyonu (Küçük #4):**
```dart
// Editörde kaydet butonuna basınca kontrol:
if (timerSeconds != null && globalTimerMinutes != null) {
  if (timerSeconds! > globalTimerMinutes! * 60) {
    // Hata: "Soru süresi genel sınav süresini aşamaz"
    return;
  }
}
```

8. **ScoreCalculator hata yönetimi:**
```dart
try {
  await scoreCalculator.calculateAllScores(examId);
} catch (e) {
  // LoadingOverlay kaldır
  // SnackBar: "Puanlama hatası, tekrar deneyin"
  // Retry butonu göster — sonuçlar ekranına GEÇMEyin
}
```

### Next.js Edge Cases:

9. **Sayfa yenileme — session ve shuffle korunması (Önemli #3):**
```typescript
// useEffect (layout.tsx veya her exam sayfasında):
const sessionId = localStorage.getItem('examSessionId');
if (sessionId) {
  const session = await getSession(sessionId);
  // questionOrder ve optionOrders session'dan gelir — localStorage yedek
  if (session.status === 'waiting') router.push(`/waiting/${sessionId}`);
  if (session.status === 'active') router.push(`/exam/${sessionId}`);
  if (session.status === 'completed') router.push(`/results/${sessionId}`);
}
```

10. **İnternet kesilmesi — cevap korunması:**
```typescript
// Firebase offline persistence açık:
// initializeFirestore(app, { localCache: persistentLocalCache() })
// Cevaplar hem Zustand'da hem localStorage'da tutulur
// Bağlantı gelince Firestore otomatik senkronize eder
// UI: sticky banner "Bağlantı kesildi — cevaplarınız kaydedildi"
```

11. **99 bağlantı limiti (Önemli #6):**
```typescript
// Session oluşturmadan önce (AŞAMA 12'de tanımlandı):
const count = await getStudentCount(examId);
if (count >= 99) {
  throw new Error('CAPACITY_FULL');
  // UI: "Sınav kapasitesi doldu (max 99 öğrenci)" ekranı
}
```

12. **Global timer auto-submit (Önemli #4 düzeltmesi):**
```typescript
// GlobalTimer.tsx — globalTimerEndsAt RTDB'den gelir, sabit
// Geç katılan daha az süre görür — tam süre VERİLMEZ
const serverOffset = await getServerTimeOffset(); // RTDB /.info/serverTimeOffset
useEffect(() => {
  const interval = setInterval(() => {
    const remaining = Math.max(0, globalTimerEndsAt - (Date.now() + serverOffset));
    if (remaining === 0) {
      completeSession(sessionId);  // Auto-submit
      clearInterval(interval);
    }
  }, 1000);
  return () => clearInterval(interval);
}, [globalTimerEndsAt]);
```

13. **Geç katılım (allowLateJoin mantığı):**
```typescript
// Ekran 2 (ad-soyad) sonrası, bekleme odasına girmeden:
const liveStatus = await getExamLiveStatus(examId);
if (liveStatus === 'live' && !exam.settings.allowLateJoin) {
  // "Sınav başladı, geç katılıma izin verilmiyor" ekranı
  // Geri dön butonu
}
// allowLateJoin=true ise: bekleme odası atlanır, direkt /exam/[sessionId]
```

14. **Aynı isimli öğrenci — race condition koruması (Küçük #2):**
```typescript
// Firestore transaction içinde:
await firestore.runTransaction(async (tx) => {
  const existing = await tx.get(sessionsQuery); // examId + name filter
  const count = existing.docs.filter(d => d.data().studentName.startsWith(baseName)).length;
  const displayName = count > 0 ? `${baseName} (${count + 1})` : baseName;
  tx.set(sessionRef, { ...sessionData, studentDisplayName: displayName });
});
```

15. **Sonuç ekranı — puan hesaplanmadıysa:**
```typescript
// getSessionResult() → scoreCalculatedAt null dönerse:
// "Sonuçlar öğretmen tarafından hesaplanıyor..." göster
// 3 saniyede bir polling yap (max 30 saniye)
// 30 saniye sonra hâlâ null ise: "Öğretmeninize bildirin" mesajı
```

---

## AŞAMA 17 — SON TEST + POLISH

### Flutter:
- Golden test: her ekranın ekran görüntüsü (basit)
- Widget test: login flow, group CRUD, exam creation flow
- Integration test: full flow (login → group → exam → share)
- 60+ yaş kontrolü: tüm buton ve metinler min 48dp, font min 16sp

### Next.js:
- Lighthouse mobile skoru: min 90 (performance + accessibility)
- Responsive test: 375px (iPhone SE), 390px (iPhone 14), 768px (tablet)
- Offline test: Chrome DevTools offline mode
- Timer accuracy test: server time vs client time

### Her İki Proje:
- Lokalizasyon: tüm string'ler .arb/.json'dan (hardcoded string yok)
- Error boundary: beklenmedik hatalar kullanıcıya açıkça gösterilir
- Loading state: her async işlemde spinner/skeleton

---

## GENEL KALİTE KRİTERLERİ

### Flutter:
- Tüm ekranlar dark/light tema uyumlu (ThemeData)
- Tüm metinler l10n'den
- Tüm Firebase işlemleri try-catch
- `const` widget'ları mümkün her yerde kullan
- No `print()` — logger paketi kullan
- `analysis_options.yaml` uyarı üretmemeli
- Her Riverpod provider için `@riverpod` annotation
- Her model `fromFirestore` + `toMap` + `copyWith` içermeli

### Next.js:
- Server Component varsayılan, `'use client'` sadece gerektiğinde
- TypeScript strict mode (`tsconfig.json`)
- Tüm UI string'leri `next-intl`'den
- Mobile-first CSS (Tailwind)
- Minimum touch target: 44px (Tailwind: `min-h-11`)
- Accessibility: her input için `aria-label`, renk kontrastı AA

---

## HER ADIM SONRASI ZORUNLU

```
1. docs/phase_1/logs/YYYY-MM-DD_ekran-adi.md dosyası oluştur
2. docs/phase_1/index.md içindeki checklist'i güncelle
3. Hata bulunursa docs/phase_1/bugs/ klasörüne ekle
4. Mimari değişiklik varsa docs/phase_1/decisions/ güncelle
```

---

## BAŞLANGIÇ KOMUTU

Claude Code'a şunu yaz:

```
CLAUDE.md dosyasını oku, docs/phase_1/index.md'yi oku.
Ardından CLAUDE_CODE_PROMPT.md dosyasını eksiksiz oku.
AŞAMA 0'dan başla. Her aşamayı tamamladıktan sonra durup onay iste.
Soru sormadan, CLAUDE.md'yi referans alarak ilerle.
Her tamamlanan ekran sonrası log dosyası oluştur.
```
