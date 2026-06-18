# ADR-006: Puanlama Güvenilirliği — Öğretmen Cihazı Bağımlılığı ve Kurtarma

**Tarih:** Haziran 2026  
**Durum:** accepted  
**İlgili:** ADR-001 (Spark tier), ADR-005 (sınav modları), `architecture/api_design.md`, `docs/phase_1/secrets_management.md`

## Bağlam

`ScoreCalculator` (bkz. `api_design.md` §ScoreCalculator) **sadece öğretmen Flutter
uygulamasında** çalışır. Bu, ADR-001'in **Firebase Spark (ücretsiz tier)** kararıyla
doğrudan bağlantılıdır:

- Firebase Cloud Functions, Spark planında anlamlı HTTPS/Callable kullanımı için
  pratikte uygun değildir (quota dar, outbound dahil çoğu özellik kısıtlı).
- Bu yüzden puanlama sunucu yerine istemciye (öğretmen cihazı) taşınmak zorunda kalır.

**Risk (tek nokta):** Öğretmen cihazı çevrimdışıyse, bataryası bittiyse, app crash
olduysa veya `endExam` ile `calculateAllScores` arası koparsa → **hiçbir öğrenci
sonuç alamaz**. `sessions.scoreCalculatedAt` null kalır, öğrenci web sonsuza dek
"Sonuçlar hesaplanıyor..." görür.

Bu ADR, bu tradeoff'u resmi olarak kabul eder ve bir kurtarma mekanizması tanımlar.
**Spark'ta kalıp güvenilirliği artırma** yaklaşımı benimsenir; Cloud Functions'a
geçiş Phase 2'ye ertelenir (bkz. §Alternatifler).

## Karar

Üç katmanlı kurtarma (recovery) stratejisi:

### 1. Açılışta Otomatik Tarama (Auto-Recover)
Öğretmen uygulaması her launch'ta (auth sonrası, `ProviderScope` init):
```dart
// flutter_app/lib/features/exams/providers/recovery_provider.dart
StreamProvider<List<StaleExam>> watchUnscoredExams(String teacherId) {
  // Firestore query:
  //   exams/{examId}: ownerTeacherId == teacherId
  //                AND status == 'completed'
  //                AND scoreCalculatedAt == null
  //                AND endedAt < now - 30 saniye (race condition buffer)
  // Eşleşme varsa: UI "X sınavın sonucu hesaplanmamış" banner'ı göster
  //   ve arka planda ScoreCalculator.calculateAllScores(examId) tetikle
}
```
> 30 saniye buffer: `endExam`'in henüz puanlama yazma aşamasında olduğu sınavları
> yanlışlıkla yeniden puanlamamak için.

### 2. Manuel "Yeniden Hesapla" Butonu (Explicit Trigger)
Sınav Sonuçları ekranında (`ExamResultsScreen`) öğretmene:
- Eğer `scoreCalculatedAt == null` → "Sonuçları Hesapla" primary butonu
- Eğer `scoreCalculatedAt != null` → "Yeniden Hesapla" ikincil (overflow) butonu
  (tüm session'lar idempotent yeniden puanlanır; `scoreCalculatedAt` overwrite edilir)

### 3. Öğrenci Web Tarafında Net Bekleme Durumu
Öğrenci sonuç ekranı (`/results/[sessionId]`) `scoreCalculatedAt == null` ise:
```
[Sonuçlar hesaplanıyor...]
↻ Otomatik yeniden denenecek
ℹ️ Öğretmeninizin cihazının açık olması bekleniyor.
   (Genelde birkaç saniye sürer.)
```
- Polling: her 5 sn'de bir `getSessionResult(sessionId)` retry (exponential değil,
  sabit — çünkü öğretmen açtığı an yazacak).
- Maksimum 10 dk sonra: "Öğretmeninizle iletişime geçin" mesajı + destek e-postası.

## İdempotency (Yeniden Hesaplama Güvenliği)

`ScoreCalculator.calculateAllScores` **idempotent** olmalıdır (tekrar çağrılsa aynı
sonucu yazar, çift puan eklemez). Mevcut implementasyon zaten bunu sağlar:
- `score` her seferinde `0`'dan başlar (toplam değil fark yazılmaz)
- `batch.update(...)` sadece son değeri yazar
- `_calculateRanks` her çağrıda tüm session'ları sıralar

> Test zorunluluğu: aynı sınav için arka arkaya 3 kez `calculateAllScores` çağrısı
> aynı `score`/`percentage`/`rank` değerlerini üretmeli. (Bkz. testing_strategy.md)

## Sonuçlar

- ✅ Öğretmen cihazı bağımlılığı **azaltılır** (çift cihaz, app reinstall, phone
  reboot — hepsi otomatik kurtarır)
- ✅ Spark planında kalınır, ek maliyet yok
- ✅ Öğrenci net bekleme durumu görür, karanlık UI yok
- ⚠️ **Hala tam çözüm değil:** Öğretmen hiç açmazsa/cihazını kaybederse sonuçlar
  hesaplanmaz. Bu senaryo için §Alternatifler'deki Blaze yükseltme gerekir.
- ⚠️ Recovery provider'ı her açılışta bir Firestore query yapar → Spark quota'ya
  ek yük. Tek seferlik ve ucuz (limit 10, indexed); MVP ölçeğinde sorun değil.

## Alternatifler

### A. Firebase Cloud Functions + Blaze Plan (Phase 2'ye ertelendi)
- ✅ Gerçek sunucu tarafı puanlama, cihaz bağımsız
- ✅ `onUpdate(exams/{examId}, status == 'completed')` trigger ile otomatik
- ❌ Blaze plan gerektirir (ödeme bilgisi + minimum ücret riski) → ADR-001 ihlal
- ❌ Blaze Functions quotası küçük, soğuk start gecikmesi
- **Karar:** Ertelendi. ADR-001'e "Sınav hacmi eşikleri" notu eklendi (bkz.
  ADR-001 §Sonuçlar güncellemesi).

### B. Cloudflare Workers + Firebase Admin SDK
- ✅ Ücretsiz tier cömert (100K istek/gün), soğuk start yok
- ❌ Webhook modeli: Cloudflare'den Firestore'a yazmak Firebase Admin SDK ister
  → ek bağımlılık, ek secret yönetimi
- ❌ Spark Firestore'a dışarıdan yazma kısıtlı (Admin SDK yine de çalışır ama
  eklenti karmaşıklığı yüksek)
- **Karar:** Phase 2 değerlendirmesi için not edildi.

### C. Tamamen Öğrenci Tarafında Puanlama
- ❌ **REDDEDİLDİ.** Doğru cevaplar (`exam_answers/`) öğrenciye iner → güvenlik
  ihlali. Mevcut tasarımın temel güvenlik prensibi (cevap ayrımı) bozulur.

## İzlenecek Metrikler (Phase 1 Implementation Sırasında)

Aşağıdaki Firestore counter'ları runtime'da loglanmalı (analytics event olarak):
- `endExam` çağrısı → `calculateAllScores` bitişi arası ms (latency)
- `scoreCalculatedAt == null` kalma süresi (kurtarma gecikmesi)
- Recovery provider'ın kaç sınavı otomatik puanladığı (auto-recover hit rate)

Bu metrikler Phase 2'de Cloud Functions geçişi için gerekçelendirme sağlar.

## Tarihçe

| Tarih | Değişiklik |
|-------|------------|
| 2026-06-18 | İlk oluşturma (Risk çözüm planı — puanlama tek nokta riski) |
