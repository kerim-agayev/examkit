# Kritik Teknik Kararlar (ADR)

## ADR-001: Firestore → RTDB Geçişi

**Tarih:** 19 Haziran 2026
**Karar:** Tüm veri katmanı Firestore'dan Firebase Realtime Database'e taşındı.

### Neden?

Firestore gRPC endpoint'i projede çalışmadı. Logcat'te sürekli şu hata alındı:
```
Firestore: [WriteStream] Stream closed: NOT_FOUND
The database (default) does not exist for project examkit-5e691.
Please visit datastore/setup to add a Cloud Firestore database.
```

### Denenen Çözümler (hepsi başarısız)

1. Billing enable + disable
2. Farklı bölgeler (eur3, europe-west1, us-central1)
3. Standard vs Enterprise edition
4. Test mode vs Production mode rules
5. Firebase Console, CLI, Google Cloud Console üzerinden veritabanı oluşturma
6. Google Cloud Datastore setup sayfasından provision
7. REST API, gRPC, Admin SDK hepsi aynı hatayı verdi

### Neden RTDB?

- WebSocket tabanlı — gRPC bağlantı sorunlarından etkilenmez
- Aynı Firebase projesinde sorunsuz çalıştı
- Gerçek zamanlı senkronizasyon için ideal (canlı sınavlar)
- Küçük veri hacmi için yeterli (1GB limit)
- Push ID'ler doğal zaman sıralaması sağlar

### Ödünler

| Kayıp | Çözüm |
|---|---|
| Compound queries (where + orderBy) | Index node'lar (exams_by_teacher, sessions_by_exam) |
| Inequality queries (!=) | Client-side filtreleme veya ayrı node (exam_codes) |
| Subcollections | Flat tree (questions/{examId}/{qid}) |
| Firestore Timestamp | Unix timestamp (ms) |

---

## ADR-002: Öğrenci Auth'suz Erişim

**Karar:** Öğrenciler Google hesabı olmadan, sadece isimle katılır.

**Neden:** Öğrencilerin uygulama indirmesini veya Google hesabı açmasını gerektirmemek için. RTDB kuralları buna göre yapılandırıldı — `exams`, `questions`, `sessions`, `leaderboards` herkese açık okumaya izin verir.

**Güvenlik:** `exam_answers` (doğru cevaplar) sadece `auth != null` ile korunur.

---

## ADR-003: Multi-path Update (Batch yerine)

**Karar:** Firestore `batch()` yerine RTDB `ref('/').update({...})` kullanıldı (multi-path atomic update).

**Neden:** RTDB'de batch API yok. Multi-path update aynı atomicity'i sağlar.

---

## ADR-004: Index Node Stratejisi

**Karar:** `where` tipi sorgular için ayrı index node'lar kullanıldı.

Örnek: Öğretmenin sınavlarını listelemek için `exams_by_teacher/{uid}/{examId}` node'u. RTDB'de compound query olmadığı için bu pattern zorunlu.

---

## ADR-005: Web Sayfaları Direkt RTDB Import

**Karar:** Her Next.js sayfası RTDB'yi `@/lib/firebase` üzerinden initialize eder (`getRtdb()`).

**Neden:** `getDatabase()` direkt çağrılırsa Firebase app'i initialize edilmez. Tüm sayfalar ve `realtime.ts` bu pattern'i kullanır.
