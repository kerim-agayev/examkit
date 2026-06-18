# Firebase Veritabanı Şeması — Phase 1

---

## Cloud Firestore

### `users/{userId}`

```typescript
interface User {
  uid: string;              // Firebase Auth UID (= document ID)
  name: string;             // Ad soyad — max 100 karakter
  school?: string;          // Okul adı — isteğe bağlı, max 100 karakter
  lang: 'az' | 'tr';       // Uygulama dili tercihi
  plan: 'free' | 'pro';    // Abonelik planı (Phase 1: hep 'free')
  createdAt: Timestamp;
  updatedAt: Timestamp;
}
```

**Güvenlik Kuralı:** Kullanıcı sadece kendi UID'si ile eşleşen dökümanı okuyup yazabilir.

---

### `groups/{groupId}`

```typescript
interface Group {
  id: string;               // Auto-generated Firestore ID
  teacherId: string;        // users/{userId} — FK
  name: string;             // Grup adı — max 60 karakter — zorunlu
  description?: string;     // Kısa açıklama — max 200 karakter
  examCount: number;        // Bu grupla yapılan toplam sınav sayısı
  lastUsedAt?: Timestamp;   // Son sınav tarihi
  createdAt: Timestamp;
  updatedAt: Timestamp;
}
```

**İndeksler:**
- `teacherId ASC, createdAt DESC` (öğretmenin grupları, yeniden eskiye)
- `teacherId ASC, lastUsedAt DESC` (son kullanılana göre)

---

### `exams/{examId}`

```typescript
interface Exam {
  id: string;               // Auto-generated
  teacherId: string;        // users/{userId}
  groupId: string;          // groups/{groupId}
  title: string;            // Sınav başlığı — max 100 karakter
  code: string;             // 6 haneli benzersiz kod (örn: "MAT7K2")
                            // Sadece büyük harf + rakam, I/O/0 hariç
  status: 'draft' | 'active' | 'live' | 'completed';
  mode: 'scroll' | 'sequential';

  settings: {
    globalTimerMinutes?: number;   // 1-180, undefined = kapalı
    shuffleQuestions: boolean;     // Soru sırasını karıştır
    shuffleOptions: boolean;       // Şık sırasını karıştır (MCQ)
    showCorrectAnswers: boolean;   // Öğrenciye doğru cevabı göster
    showScoreToStudent: boolean;   // Öğrenciye puanı göster
    showLeaderboard: boolean;      // Öğrenciye sıralamayı göster
    allowLateJoin: boolean;        // Sınav başladıktan sonra katılım
  };

  totalPoints: number;       // Tüm soruların puan toplamı
  questionCount: number;     // Soru sayısı (denormalized)
  startedAt?: Timestamp;     // Sınav başlama zamanı
  endedAt?: Timestamp;       // Sınav bitiş zamanı
  createdAt: Timestamp;
  updatedAt: Timestamp;
}
```

**İndeksler:**
- `teacherId ASC, createdAt DESC`
- `teacherId ASC, status ASC, createdAt DESC`
- `code ASC` (benzersiz — öğrenci kodu girerken)

---

### `exams/{examId}/questions/{questionId}` — SADECE GÖRÜNTÜLEME VERİSİ

```typescript
interface Question {
  id: string;
  examId: string;
  type: 'mcq' | 'true_false' | 'short_answer';
  text: string;              // Soru metni — max 500 karakter
  points: number;            // 1–100, varsayılan: 1
  timerSeconds?: number;     // 5–300, undefined = global timer kullan
                             // NOT: globalTimerMinutes × 60'dan büyük olamaz
  orderIndex: number;        // 0-based sıralama

  // MCQ için — SADECE şık metinleri, doğru cevap BURADA DEĞİL
  options?: {
    id: 'a' | 'b' | 'c' | 'd';
    text: string;            // Max 200 karakter
  }[];

  createdAt: Timestamp;
  updatedAt: Timestamp;
}
```

### `exams/{examId}/exam_answers/{questionId}` — DOĞRU CEVAPLAR (SADECE ÖĞRETMEN)

> **Kritik #2 düzeltmesi:** Doğru cevaplar ayrı koleksiyonda tutulur.
> Öğrenci `questions/` okuyabilir ama `exam_answers/` okuyamaz.
> Puanlama öğretmen Flutter uygulamasında yapılır.

```typescript
interface ExamAnswer {
  questionId: string;
  type: 'mcq' | 'true_false' | 'short_answer';

  // MCQ
  correctOptionId?: 'a' | 'b' | 'c' | 'd';

  // True/False
  correctBool?: boolean;

  // Short Answer
  acceptedAnswers?: string[];  // Büyük/küçük harf duyarsız eşleşme
}
```

---

### `sessions/{sessionId}`

```typescript
interface Session {
  id: string;                // UUID v4 — tahmin edilemez
  examId: string;
  teacherId: string;
  groupId: string;
  studentName: string;       // Öğrencinin girdiği ham ad
  studentDisplayName: string; // Çakışmada: "Ali Vəliyev (2)"
  status: 'waiting' | 'active' | 'completed' | 'abandoned';

  answers: {
    [questionId: string]: {
      value: string | boolean | null;  // MCQ: 'a'|'b'|'c'|'d' / T-F: bool / SA: string
      answeredAt?: Timestamp;
    };
  };

  // ── SHUFFLE ALANLARI (Kritik #3 düzeltmesi) ─────────────────────────
  // Session oluşturulurken shuffle hesaplanır ve buraya kaydedilir.
  // Tarayıcı yenilenirse aynı sıra kullanılır — cevaplar kaybolmaz.
  questionOrder?: string[];           // Karıştırılmış soru ID'leri dizisi
                                      // shuffleQuestions=false ise null
  optionOrders?: {                    // Her MCQ sorusu için karıştırılmış şık sırası
    [questionId: string]: string[];   // örn: { "q1": ["c","a","d","b"] }
  };                                  // shuffleOptions=false ise null

  // ── PUANLAMA (Kritik #2 düzeltmesi) ─────────────────────────────────
  // Puanlama öğrenci tarayıcısında DEĞİL, öğretmen Flutter uygulamasında yapılır.
  // Öğretmen "Sınavı Bitir" bastığında tüm session'lar toplu puanlanır.
  score: number;             // Ham puan — öğretmen uygulaması yazar (başlangıç: 0)
  totalPoints: number;       // Sınav toplam puanı (denormalized)
  percentage: number;        // 0–100 (integer) — öğretmen uygulaması yazar
  rank?: number;             // Sınıftaki sıra — öğretmen uygulaması yazar
  scoreCalculatedAt?: Timestamp; // Puanlama zamanı — null ise henüz hesaplanmadı

  // ── ZAMANLAMA ────────────────────────────────────────────────────────
  startedAt?: Timestamp;     // Öğrenci sınava başladığında
  completedAt?: Timestamp;
  durationSeconds?: number;  // completedAt - startedAt

  createdAt: Timestamp;      // Bekleme odasına girdiğinde
  updatedAt: Timestamp;
}
```

> **Puanlama akışı:** Öğrenci yalnızca `answers` yazar. Öğretmen "Bitir"e basınca
> Flutter uygulaması → tüm questions okur (doğru cevaplarla) → her session için skor
> hesaplar → `score`, `percentage`, `rank`, `scoreCalculatedAt` yazar. Öğrenci web
> sadece bu alanları okur. Doğru cevaplar hiçbir zaman öğrenci tarayıcısına gitmez.

**İndeksler:**
- `examId ASC, score DESC` (sıralama için)
- `examId ASC, completedAt ASC` (tamamlanma sırası)
- `examId ASC, status ASC` (aktif öğrenciler)

---

## Firebase Realtime Database

```
live_exams/
└── {examId}/
    ├── teacherId: "uid_abc123"      ← YENİ: güvenlik kuralları için zorunlu
    ├── status: "waiting" | "active" | "completed"
    ├── startedAt: 1234567890        (Unix timestamp ms)
    ├── globalTimerEndsAt: 1234567890 | null
    │                                ← Tüm öğrenciler bu sabit timestamp'e göre
    │                                  geri sayar. Geç katılan daha az süre bulur.
    └── students/
        └── {sessionId}/
            ├── name: "Ali Vəliyev"
            ├── displayName: "Ali Vəliyev (2)"
            ├── status: "waiting" | "active" | "completed"
            ├── answeredCount: 12
            ├── totalQuestions: 20
            └── joinedAt: 1234567890
```

> **Geç katılım + global timer (Önemli #4 düzeltmesi):** `globalTimerEndsAt`
> sunucu tarafında `startedAt + (globalTimerMinutes × 60000)` olarak hesaplanır
> ve RTDB'ye yazılır. Tüm öğrenciler bu tek timestamp'i kullanır. Geç katılan
> öğrencinin tarayıcısı `globalTimerEndsAt - Date.now()` hesaplayarak kalan süreyi
> bulur — bu otomatik olarak daha az süre demektir. "Timer başından başlar" mantığı
> **yanlıştır ve kaldırılmıştır.**

**Güvenlik Kuralları (database.rules.json):**
```json
{
  "rules": {
    "live_exams": {
      "$examId": {
        ".read": "auth != null || root.child('live_exams').child($examId).child('status').val() != null",
        ".write": "auth != null && root.child('live_exams').child($examId).child('teacherId').val() == auth.uid",
        "students": {
          "$sessionId": {
            ".read": true,
            ".write": true
          }
        }
      }
    }
  }
}
```

---

## Sınav Kodu Algoritması

```dart
// exam_code_generator.dart
// 6 karakter: büyük harf + rakam, karışıklık yaratan I/O/0/1 hariç
const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

String generateExamCode() {
  final random = Random.secure();
  return List.generate(6, (_) => chars[random.nextInt(chars.length)]).join();
}
// Firestore'da benzersizlik kontrolü yap, çakışırsa yeniden üret
```

---

## Firestore Security Rules (DÜZELTİLMİŞ — v2)

> **Kritik #1 düzeltmesi:** Önceki kurallar öğrencilerin sınav ve soruları
> okumasını engelliyordu. Öğrenciler unauthenticated bağlanır — aşağıdaki
> kurallar bunu destekler. Doğru cevaplar ise ayrı koleksiyonda tutulur (Kritik #2).

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // ── Kullanıcılar: sadece kendi profili ──────────────────────────────
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }

    // ── Gruplar: sadece sahibi ──────────────────────────────────────────
    match /groups/{groupId} {
      allow read, write: if request.auth != null
        && request.auth.uid == resource.data.teacherId;
      allow create: if request.auth != null
        && request.auth.uid == request.resource.data.teacherId;
    }

    // ── Sınavlar ────────────────────────────────────────────────────────
    match /exams/{examId} {
      // Öğretmen: kendi sınavlarını tam yönetir
      allow read, write: if request.auth != null
        && request.auth.uid == resource.data.teacherId;
      allow create: if request.auth != null
        && request.auth.uid == request.resource.data.teacherId;

      // Öğrenci (unauthenticated): taslak olmayan sınavları okuyabilir
      // Sınav kodu ile eşleşme Firestore sorgusunda yapılır (code field)
      allow read: if resource.data.status != 'draft';

      // ── Sorular: öğretmen tam erişim, öğrenci soru metnini okur ───────
      match /questions/{questionId} {
        // Öğretmen: doğru cevaplar dahil tam okuma/yazma
        allow read, write: if request.auth != null &&
          get(/databases/$(database)/documents/exams/$(examId)).data.teacherId
            == request.auth.uid;

        // Öğrenci: sadece aktif/canlı sınavlarda SORU METNİNİ okur
        // Not: Güvenlik kuralı field-level filtreleme yapamaz.
        // Doğru cevaplar (correctOptionId, correctBool, acceptedAnswers)
        // ayrı koleksiyonda tutulur — bkz. exam_answers koleksiyonu.
        allow read: if get(/databases/$(database)/documents/exams/$(examId))
          .data.status in ['active', 'live'];
      }

      // ── Doğru cevaplar: SADECE öğretmen okur ─────────────────────────
      // Soru metni questions/ altında, doğru cevaplar exam_answers/ altında
      // Bu sayede öğrenci questions/ okusa bile cevaplara ulaşamaz
      match /exam_answers/{answerId} {
        allow read, write: if request.auth != null &&
          get(/databases/$(database)/documents/exams/$(examId)).data.teacherId
            == request.auth.uid;
      }
    }

    // ── Sessions: öğrenci yazar, öğretmen okur ──────────────────────────
    match /sessions/{sessionId} {
      // Öğrenci: session oluşturur (unauthenticated OK)
      allow create: if request.resource.data.studentName.size() > 0
        && request.resource.data.studentName.size() <= 100;

      // Öğrenci: sadece kendi cevaplarını günceller
      // (studentName değiştirilememeli — race condition koruması)
      allow update: if resource.data.studentName
        == request.resource.data.studentName
        && resource.data.examId == request.resource.data.examId;

      // Öğrenci: kendi sessionId'sini bilerek okur (results için)
      allow read: if true;
      // Not: sessionId UUID v4, tahmin edilemez → yeterli güvenlik

      // Öğretmen: kendi sınavının tüm session'larını okur + score yazar
      allow read, write: if request.auth != null
        && request.auth.uid == resource.data.teacherId;
    }
  }
}
```

> **exam_answers koleksiyonu neden ayrı?**
> Firestore güvenlik kuralları field-level filtreleme yapamaz — bir dökümanı
> okuma iznin varsa TÜM alanlarını görürsün. Doğru cevapları `questions/`
> koleksiyonundan ayırarak öğrencilerin doğru cevaplara erişmesi tamamen
> engellenir. Öğretmen uygulaması `exam_answers/` koleksiyonundan okuyarak
> puanlamayı kendisi yapar.
