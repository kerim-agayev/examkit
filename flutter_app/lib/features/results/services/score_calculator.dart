import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/firebase/firebase_providers.dart';

/// ScoreCalculator — Sınav puanlama motoru.
/// Sadece öğretmen Flutter uygulamasında çalışır (ADR-006).
/// Öğrenci web'i ASLA puanlama yapmaz — doğru cevaplar istemciye inmez.

class ScoreCalculator {
  final FirebaseFirestore _db;

  ScoreCalculator(this._db);

  /// Tüm session'ları puanla ve sırala.
  /// İdempotent — aynı sınav için birden fazla kez çağrılabilir.
  Future<void> calculateAllScores(String examId) async {
    // 1. Doğru cevapları al (exam_answers — sadece öğretmen okuyabilir)
    final answersSnap = await _db.collection('exams/$examId/exam_answers').get();
    final answerMap = <String, _AnswerData>{};
    for (final doc in answersSnap.docs) {
      final d = doc.data();
      answerMap[doc.id] = _AnswerData(
        type: d['type'] ?? 'mcq',
        correctOptionId: d['correctOptionId'],
        correctBool: d['correctBool'],
        acceptedAnswers: List<String>.from(d['acceptedAnswers'] ?? []),
      );
    }

    // 2. Soruları al (puan değerleri için)
    final questionsSnap = await _db.collection('exams/$examId/questions').get();
    final questionPoints = <String, int>{};
    int totalPoints = 0;
    for (final doc in questionsSnap.docs) {
      final pts = (doc.data()['points'] as num?)?.toInt() ?? 1;
      questionPoints[doc.id] = pts;
      totalPoints += pts;
    }

    // 3. Tüm session'ları al
    final sessionsSnap = await _db
        .collection('sessions')
        .where('examId', isEqualTo: examId)
        .get();

    // 4. Her session için puan hesapla
    final batch = _db.batch();
    final scores = <String, int>{};

    for (final doc in sessionsSnap.docs) {
      final data = doc.data();
      final answers = data['answers'] as Map<String, dynamic>? ?? {};
      int score = 0;

      for (final entry in answers.entries) {
        final qId = entry.key;
        final studentValue = (entry.value as Map<String, dynamic>?)?['value'];
        final correct = answerMap[qId];
        final points = questionPoints[qId] ?? 1;

        if (correct != null && _isCorrect(correct, studentValue)) {
          score += points;
        }
      }

      final percentage = totalPoints > 0 ? ((score / totalPoints) * 100).round() : 0;
      scores[doc.id] = score;

      batch.update(doc.reference, {
        'score': score,
        'totalPoints': totalPoints,
        'percentage': percentage,
        'scoreCalculatedAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();

    // 5. Sıralamayı hesapla (score DESC, duration ASC — tie-break)
    await _calculateRanks(examId, sessionsSnap.docs, scores);

    // 6. Exam status → completed
    await _db.collection('exams').doc(examId).update({
      'status': 'completed',
      'endedAt': FieldValue.serverTimestamp(),
    });
  }

  bool _isCorrect(_AnswerData answer, dynamic studentValue) {
    if (studentValue == null) return false;
    switch (answer.type) {
      case 'mcq':
        return studentValue.toString() == answer.correctOptionId;
      case 'true_false':
        return studentValue == answer.correctBool;
      case 'short_answer':
        final sv = studentValue.toString().toLowerCase().trim();
        return answer.acceptedAnswers.any((a) => a.toLowerCase().trim() == sv);
    }
    return false;
  }

  Future<void> _calculateRanks(String examId, List<DocumentSnapshot> sessions, Map<String, int> scores) async {
    // score DESC, completedAt ASC (daha hızlı = daha iyi)
    final sorted = sessions.toList()
      ..sort((a, b) {
        final sA = scores[a.id] ?? 0;
        final sB = scores[b.id] ?? 0;
        if (sA != sB) return sB.compareTo(sA);
        final tA = (a.data() as Map<String, dynamic>)['completedAt'] as Timestamp?;
        final tB = (b.data() as Map<String, dynamic>)['completedAt'] as Timestamp?;
        if (tA == null && tB == null) return 0;
        if (tA == null) return 1;
        if (tB == null) return -1;
        return tA.compareTo(tB);
      });

    final batch = _db.batch();
    for (int i = 0; i < sorted.length; i++) {
      batch.update(sorted[i].reference, {'rank': i + 1});
    }
    await batch.commit();
  }
}

class _AnswerData {
  final String type;
  final String? correctOptionId;
  final bool? correctBool;
  final List<String> acceptedAnswers;
  const _AnswerData({required this.type, this.correctOptionId, this.correctBool, this.acceptedAnswers = const []});
}

/// Provider
final scoreCalculatorProvider = Provider<ScoreCalculator>((ref) {
  return ScoreCalculator(ref.watch(firestoreProvider));
});

/// Sınavı puanla (FutureProvider — UI'dan tetiklenir)
final calculateScoresProvider = FutureProvider.autoDispose.family<void, String>((ref, examId) async {
  final calculator = ref.watch(scoreCalculatorProvider);
  await calculator.calculateAllScores(examId);
});

/// Hesaplanmamış sınavları tara (ADR-006 recovery)
final watchUnscoredExamsProvider = StreamProvider.autoDispose<List<String>>((ref) {
  final db = ref.watch(firestoreProvider);
  return db
      .collection('exams')
      .where('status', isEqualTo: 'completed')
      .snapshots()
      .map((snap) => snap.docs
          .where((doc) => doc.data()['scoreCalculatedAt'] == null)
          .map((doc) => doc.id)
          .toList());
});
