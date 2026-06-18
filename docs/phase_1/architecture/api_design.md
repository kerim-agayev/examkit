# API & Servis Katmanı Tasarımı

---

## Flutter — Servis Metodları

### `AuthService`
```dart
Future<UserCredential> signInWithGoogle()
Future<void> signOut()
Stream<User?> get authStateChanges
Future<void> updateProfile({ String? name, String? school, String? lang })
```

### `GroupRepository`
```dart
Stream<List<GroupModel>> watchGroups(String teacherId)
Future<GroupModel> createGroup({ required String name, String? description })
Future<void> updateGroup(String groupId, { String? name, String? description })
Future<void> deleteGroup(String groupId)          // Aktif sınav yoksa
Future<GroupModel> getGroup(String groupId)
Future<void> incrementExamCount(String groupId)   // Sınav başlatılınca
```

### `ExamRepository`
```dart
Stream<List<ExamModel>> watchExams(String teacherId)
Future<ExamModel> createExam({ required String title, required String groupId })
Future<void> updateExamSettings(String examId, ExamSettingsModel settings)

// Küçük düzeltme #1 — Firestore transaction: kod üretimi + status değişimi atomik
Future<void> publishExam(String examId)
// İç mantık:
// await firestore.runTransaction((tx) async {
//   String code = await _generateUniqueCode(tx);
//   tx.update(examRef, { 'status': 'active', 'code': code, 'updatedAt': now });
// });

Future<void> deleteExam(String examId)            // Sadece draft
Future<String> _generateUniqueCode(Transaction tx) // Private, transaction içinde
Future<ExamModel> getExamByCode(String code)      // Öğrenci katılımı — status != draft

// Doğru cevapları ayrı koleksiyona yaz (Kritik #2)
Future<void> saveExamAnswer(String examId, String questionId, ExamAnswerModel answer)
Future<Map<String, ExamAnswerModel>> getExamAnswers(String examId) // Sadece öğretmen
```

### `QuestionRepository`
```dart
Stream<List<QuestionModel>> watchQuestions(String examId)
// NOT: QuestionModel artık correctOptionId/correctBool/acceptedAnswers içermiyor
// Bunlar ExamAnswerModel olarak ayrı kaydedilir

Future<QuestionModel> createQuestion(String examId, QuestionModel q,
  ExamAnswerModel answer)  // İkisi birlikte kaydedilir (batch write)
Future<void> updateQuestion(String examId, String questionId,
  QuestionModel q, ExamAnswerModel answer)
Future<void> deleteQuestion(String examId, String questionId)
Future<void> reorderQuestions(String examId, List<String> orderedIds)
Future<QuestionModel> duplicateQuestion(String examId, String questionId)
```

### `LiveExamRepository` (Realtime DB)
```dart
Stream<LiveExamState> watchLiveExam(String examId)

// Sınav başlatma — globalTimerEndsAt hesapla ve yaz (Önemli #4 düzeltmesi)
Future<void> startExam(String examId, int? globalTimerMinutes) {
  // startedAt = DateTime.now().millisecondsSinceEpoch
  // globalTimerEndsAt = globalTimerMinutes != null
  //   ? startedAt + (globalTimerMinutes * 60 * 1000)
  //   : null
  // RTDB'ye teacherId, status:'active', startedAt, globalTimerEndsAt yaz
}

// Sınav bitirme — RTDB güncelle + Flutter puanlama tetikler (Kritik #2)
Future<void> endExam(String examId)
// Ardından: ScoreCalculator.calculateAllScores(examId) çağrılır

Future<void> studentJoined(String examId, String sessionId, String name)
Future<void> updateStudentProgress(String examId, String sessionId, int answeredCount)
Future<void> studentCompleted(String examId, String sessionId)

// Bağlantı kontrolü — Küçük düzeltme #6 (0 öğrenci)
Future<int> getStudentCount(String examId)
```

### `SessionRepository`
```dart
// Session oluşturma — shuffle hesapla ve kaydet (Önemli #3 düzeltmesi)
Future<SessionModel> createSession({
  required String examId,
  required String studentName,
  required List<String> questionIds,      // Shuffle için gerekli
  required bool shuffleQuestions,
  required bool shuffleOptions,
  required List<String> optionIds,        // MCQ şık ID'leri
})
// İç mantık:
// 1. Aynı isim var mı? Transaction ile kontrol (Küçük düzeltme #2 race condition)
// 2. shuffleQuestions → List.from(questionIds)..shuffle() → questionOrder
// 3. shuffleOptions → her soru için ayrı karıştırma → optionOrders
// 4. Session'ı questionOrder ve optionOrders ile Firestore'a yaz

Future<void> saveAnswer(String sessionId, String questionId, dynamic value)
Future<void> completeSession(String sessionId)
// NOT: Puanlama BURADA YAPILMIYOR — Flutter öğretmen uygulaması yapacak

Stream<List<SessionModel>> watchSessions(String examId)
Future<SessionModel> getSession(String sessionId)
```

### `ScoreCalculator` — YENİ SINIF (Kritik #2 düzeltmesi)

```dart
// lib/features/results/services/score_calculator.dart
// Öğretmen uygulamasında çalışır — öğrenci web'i puanlama yapmaz

class ScoreCalculator {
  final FirebaseFirestore _db;

  // Sınav bitince tüm session'ları puan
  Future<void> calculateAllScores(String examId) async {
    // 1. Tüm questions + exam_answers al (öğretmen auth'lu → okuyabilir)
    final answers = await _db
      .collection('exams/$examId/exam_answers').get();
    final answerMap = { for (var doc in answers.docs):
      doc.id: ExamAnswerModel.fromFirestore(doc) };

    // 2. Tüm completed/active sessions al
    final sessions = await _db
      .collection('sessions')
      .where('examId', isEqualTo: examId)
      .get();

    // 3. Her session için puan hesapla
    final batch = _db.batch();
    final scores = <String, int>{};

    for (final sessionDoc in sessions.docs) {
      final session = SessionModel.fromFirestore(sessionDoc);
      int score = 0;

      for (final entry in session.answers.entries) {
        final qId = entry.key;
        final answer = answerMap[qId];
        final questions = await _db
          .collection('exams/$examId/questions').doc(qId).get();
        final points = questions.data()?['points'] as int? ?? 1;

        if (answer != null && _isCorrect(answer, entry.value.value)) {
          score += points;
        }
      }

      final totalPoints = await _getTotalPoints(examId);
      final percentage = totalPoints > 0
        ? ((score / totalPoints) * 100).round() : 0;

      scores[sessionDoc.id] = score;
      batch.update(sessionDoc.reference, {
        'score': score,
        'percentage': percentage,
        'scoreCalculatedAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();

    // 4. Sıralamayı hesapla (score DESC, duration ASC)
    await _calculateRanks(examId, sessions.docs, scores);

    // 5. Firestore'da exam status → completed
    await _db.collection('exams').doc(examId).update({
      'status': 'completed',
      'endedAt': FieldValue.serverTimestamp(),
    });
  }

  bool _isCorrect(ExamAnswerModel answer, dynamic studentValue) {
    switch (answer.type) {
      case 'mcq': return studentValue == answer.correctOptionId;
      case 'true_false': return studentValue == answer.correctBool;
      case 'short_answer':
        final sv = studentValue?.toString().toLowerCase().trim() ?? '';
        return answer.acceptedAnswers?.any(
          (a) => a.toLowerCase().trim() == sv
        ) ?? false;
    }
    return false;
  }
}
```

### `ResultsRepository`
```dart
Future<ExamSummary> getExamSummary(String examId)
Future<List<SessionModel>> getSessionsRanked(String examId)
// NOT: Ranklar ScoreCalculator tarafından hesaplanıp yazılmış olur
// Bu metod sadece okuma yapar
```

---

## ScoreCalculator Recovery — YENİ (ADR-006)

```dart
// flutter_app/lib/features/exams/providers/recovery_provider.dart
// Açılışta otomatik tarama: hesaplanmamış sınavları bul ve skorla

@riverpod
Stream<List<StaleExam>> watchUnscoredExams(WatchUnscoredExamsRef ref, String teacherId) {
  final db = ref.watch(firestoreProvider);
  return db
    .collection('exams')
    .where('ownerTeacherId', isEqualTo: teacherId)
    .where('status', isEqualTo: 'completed')
    // scoreCalculatedAt null olan + 30 sn'den eski buffer
    .snapshots()
    .map((snap) => snap.docs
      .where((doc) => doc.data()['scoreCalculatedAt'] == null)
      .where((doc) {
        final ended = doc.data()['endedAt'] as Timestamp?;
        if (ended == null) return false;
        return Timestamp.now().millisecondsSinceEpoch - ended.millisecondsSinceEpoch > 30000;
      })
      .map((doc) => StaleExam.fromFirestore(doc))
      .toList());
}

// Manual retrigger — ExamResultsScreen'de buton
Future<void> recalculateScores(String examId) async {
  final calculator = ScoreCalculator(firestore);
  await calculator.calculateAllScores(examId);
}
```

---

## Next.js — Client Fonksiyonları

### `lib/firestore.ts`
```typescript
// Öğrenci web — puanlama YAPILMAZ (Kritik #2 düzeltmesi)
export async function getExamByCode(code: string): Promise<Exam | null>
// → questions/ ve exam_answers/ AYRI — öğrenci sadece questions/ okur

export async function getExamQuestions(examId: string): Promise<Question[]>
// → Question tipi: text, options, points, timerSeconds, orderIndex
// → correctOptionId / correctBool / acceptedAnswers YOKTUR bu tipte

export async function createSession(params: {
  examId: string;
  studentName: string;
  questionIds: string[];    // Shuffle hesabı için
  shuffleQuestions: boolean;
  shuffleOptions: boolean;
}): Promise<{ sessionId: string; questionOrder: string[]; optionOrders: Record<string,string[]> }>
// → Shuffle hesaplanır ve session'a kaydedilir (Önemli #3 düzeltmesi)
// → Aynı isim transaction ile kontrol edilir (Küçük #2 düzeltmesi)

export async function saveAnswer(
  sessionId: string,
  questionId: string,
  value: string | boolean
): Promise<void>
// → Firestore'a yaz (offline persistence açık, bağlantı yoksa kuyrukta bekler)

export async function completeSession(sessionId: string): Promise<void>
// → status: 'completed', completedAt: serverTimestamp yaz
// → SKOR HESAPLAMAZ — öğretmen Flutter uygulaması hesaplayacak

export async function getSessionResult(sessionId: string): Promise<SessionResult>
// → score, percentage, rank okur (öğretmen yazmış olmalı)
// → scoreCalculatedAt null ise: "Sonuçlar hesaplanıyor..." göster

export async function getLeaderboard(examId: string): Promise<LeaderboardEntry[]>
```

### `lib/realtime.ts`
```typescript
export function subscribeToExamStatus(
  examId: string,
  cb: (status: string) => void
): Unsubscribe

export function subscribeToStudents(
  examId: string,
  cb: (students: StudentMap) => void
): Unsubscribe

export async function joinWaitingRoom(
  examId: string,
  sessionId: string,
  name: string
): Promise<void>

export async function updateProgress(
  examId: string,
  sessionId: string,
  count: number
): Promise<void>

export async function markCompleted(
  examId: string,
  sessionId: string
): Promise<void>

// Global timer hesabı (Önemli #4 düzeltmesi)
export function getRemainingMs(globalTimerEndsAt: number): number {
  // return Math.max(0, globalTimerEndsAt - Date.now())
  // → Tüm öğrenciler aynı bitiş zamanını kullanır
  // → Geç katılan otomatik olarak daha az süre bulur
  // → Server clock skew: RTDB /.info/serverTimeOffset ile düzelt
}
```

---

## Öğrenci Sınav Akışı — Tam Sequence

```
1. Öğrenci link'e tıklar veya kod girer
   → getExamByCode(code) → Firestore

2. Ad-soyad girer
   → createSession(examId, studentName) → Firestore
   → joinWaitingRoom(examId, sessionId, name) → RTDB
   → sessionId localStorage'e kaydedilir (yenileme için)

3. Bekleme odası
   → subscribeToExamStatus(examId) → RTDB Stream
   → status "active" olunca otomatik exam sayfasına geç

4. Sınav sürerken (her cevap)
   → saveAnswer(sessionId, questionId, value) → Firestore
   → updateProgress(examId, sessionId, count) → RTDB

5. Timer dolduğunda veya öğrenci "Tamamla"ya bastığında
   → completeSession(sessionId, allAnswers) → Firestore
   → markCompleted(examId, sessionId) → RTDB

6. Sonuç ekranı
   → getSessionResult(sessionId) → Firestore
   → getLeaderboard(examId) → Firestore (öğretmen izni varsa)
```

---

## Hata Yönetimi

Her servis çağrısı:
```typescript
// Next.js
try {
  const result = await getExamByCode(code);
  if (!result) throw new Error('EXAM_NOT_FOUND');
  return result;
} catch (error) {
  if (error instanceof FirebaseError) {
    // Firebase özel hataları
    logger.error('Firebase error:', error.code, error.message);
  }
  throw error; // UI katmanı yakalar
}
```

```dart
// Flutter
Future<ExamModel> getExamByCode(String code) async {
  try {
    final query = await _firestore
      .collection('exams')
      .where('code', isEqualTo: code)
      .where('status', isNotEqualTo: 'draft')
      .limit(1)
      .get();
    if (query.docs.isEmpty) throw ExamNotFoundException(code);
    return ExamModel.fromFirestore(query.docs.first);
  } on FirebaseException catch (e) {
    throw FirebaseServiceException(e.code, e.message);
  }
}
```
