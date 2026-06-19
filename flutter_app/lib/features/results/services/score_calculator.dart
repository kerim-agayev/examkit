import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/firebase/firebase_providers.dart';

class ScoreCalculator {
  final FirebaseDatabase _db;
  ScoreCalculator(this._db);

  Future<void> calculateAllScores(String examId) async {
    final answersSnap = await _db.ref('exam_answers/$examId').get();
    final answerMap = <String, _AD>{};
    if (answersSnap.exists) {
      final answers = answersSnap.value as Map<dynamic, dynamic>;
      for (final e in answers.entries) {
        final d = Map<dynamic, dynamic>.from(e.value);
        answerMap[e.key.toString()] = _AD(
          type: d['type'] ?? 'mcq',
          correctOptionId: d['correctOptionId'],
          correctBool: d['correctBool'],
          acceptedAnswers: List<String>.from(d['acceptedAnswers'] ?? []),
        );
      }
    }

    final questionsSnap = await _db.ref('questions/$examId').get();
    final questionPoints = <String, int>{};
    int totalPoints = 0;
    if (questionsSnap.exists) {
      final questions = questionsSnap.value as Map<dynamic, dynamic>;
      for (final e in questions.entries) {
        final pts = (Map<dynamic, dynamic>.from(e.value)['points'] as int?) ?? 1;
        questionPoints[e.key.toString()] = pts;
        totalPoints += pts;
      }
    }

    final sessionsSnap = await _db.ref('sessions_by_exam/$examId').get();
    if (!sessionsSnap.exists) return;
    final sessionIds = (sessionsSnap.value as Map<dynamic, dynamic>).keys.toList();

    final updates = <String, dynamic>{};
    final scores = <String, int>{};

    for (final sid in sessionIds) {
      final sSnap = await _db.ref('sessions/$sid').get();
      if (!sSnap.exists) continue;
      final d = Map<dynamic, dynamic>.from(sSnap.value as Map);
      final answers = d['answers'] as Map<dynamic, dynamic>? ?? {};
      int score = 0;

      for (final a in answers.entries) {
        final qId = a.key.toString();
        final val = Map<dynamic, dynamic>.from(a.value)['value'];
        final correct = answerMap[qId];
        if (correct != null && _isCorrect(correct, val)) {
          score += questionPoints[qId] ?? 1;
        }
      }

      final pct = totalPoints > 0 ? ((score / totalPoints) * 100).round() : 0;
      scores[sid.toString()] = score;
      updates['sessions/$sid/score'] = score;
      updates['sessions/$sid/totalPoints'] = totalPoints;
      updates['sessions/$sid/percentage'] = pct;
      updates['sessions/$sid/scoreCalculatedAt'] = ServerValue.timestamp;
    }

    if (updates.isNotEmpty) await _db.ref('/').update(updates);

    await _calculateRanks(examId, sessionIds.cast<String>(), scores, totalPoints);
    await _db.ref('exams/$examId').update({
      'status': 'completed',
      'endedAt': ServerValue.timestamp,
    });
  }

  bool _isCorrect(_AD answer, dynamic studentValue) {
    if (studentValue == null) return false;
    switch (answer.type) {
      case 'mcq': return studentValue.toString() == answer.correctOptionId;
      case 'true_false': return studentValue == answer.correctBool;
      case 'short_answer':
        final sv = studentValue.toString().toLowerCase().trim();
        return answer.acceptedAnswers.any((a) => a.toLowerCase().trim() == sv);
    }
    return false;
  }

  Future<void> _calculateRanks(String examId, List<String> sids, Map<String, int> scores, int totalPoints) async {
    final sessions = <_RankData>[];
    for (final sid in sids) {
      final sSnap = await _db.ref('sessions/$sid').get();
      if (!sSnap.exists) continue;
      final d = Map<dynamic, dynamic>.from(sSnap.value as Map);
      sessions.add(_RankData(
        sid: sid,
        score: scores[sid] ?? 0,
        completedAt: d['completedAt'] ?? 0,
        studentName: d['studentName'] ?? '?',
        percentage: totalPoints > 0 ? ((scores[sid] ?? 0) / totalPoints * 100).round() : 0,
      ));
    }
    sessions.sort((a, b) {
      if (a.score != b.score) return b.score.compareTo(a.score);
      return (a.completedAt as int).compareTo(b.completedAt as int);
    });

    final updates = <String, dynamic>{};
    for (int i = 0; i < sessions.length; i++) {
      final r = sessions[i];
      updates['sessions/${r.sid}/rank'] = i + 1;
      updates['leaderboards/$examId/${r.sid}'] = {
        'rank': i + 1,
        'studentName': r.studentName,
        'score': r.score,
        'percentage': r.percentage,
      };
    }
    if (updates.isNotEmpty) await _db.ref('/').update(updates);
  }
}

class _AD {
  final String type;
  final String? correctOptionId;
  final bool? correctBool;
  final List<String> acceptedAnswers;
  const _AD({required this.type, this.correctOptionId, this.correctBool, this.acceptedAnswers = const []});
}

class _RankData {
  final String sid, studentName;
  final int score, percentage;
  final dynamic completedAt;
  const _RankData({required this.sid, required this.score, required this.completedAt, required this.studentName, required this.percentage});
}

final scoreCalculatorProvider = Provider<ScoreCalculator>((ref) => ScoreCalculator(ref.watch(rtdbProvider)));

final calculateScoresProvider = FutureProvider.autoDispose.family<void, String>((ref, examId) async {
  await ref.watch(scoreCalculatorProvider).calculateAllScores(examId);
});

final watchUnscoredExamsProvider = StreamProvider.autoDispose<List<String>>((ref) {
  final rtdb = ref.watch(rtdbProvider);
  return rtdb.ref('exams').orderByChild('status').equalTo('completed').onValue.map((event) {
    final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
    return data.keys.cast<String>().toList();
  });
});
