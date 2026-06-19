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
