import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/firebase/firebase_providers.dart';

/// QuestionModel — soru verisi (cevap YOK)
class QuestionModel {
  final String id;
  final String text;
  final String type; // mcq | true_false | short_answer
  final List<String>? options;
  final int points;
  final int? timerSeconds;
  final int orderIndex;

  const QuestionModel({required this.id, required this.text, required this.type, this.options, this.points = 1, this.timerSeconds, this.orderIndex = 0});

  factory QuestionModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return QuestionModel(
      id: doc.id,
      text: d['text'] ?? '',
      type: d['type'] ?? 'mcq',
      options: d['options'] != null ? List<String>.from(d['options']) : null,
      points: (d['points'] as num?)?.toInt() ?? 1,
      timerSeconds: (d['timerSeconds'] as num?)?.toInt(),
      orderIndex: (d['orderIndex'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Soruları dinle
final watchQuestionsProvider = StreamProvider.autoDispose.family<List<QuestionModel>, String>((ref, examId) {
  final db = ref.watch(firestoreProvider);
  return db
      .collection('exams/$examId/questions')
      .orderBy('orderIndex')
      .snapshots()
      .map((snap) => snap.docs.map((d) => QuestionModel.fromFirestore(d)).toList());
});

/// Soru oluştur — hem question hem exam_answer yazar
final createQuestionProvider = FutureProvider.autoDispose.family<void, ({String examId, String text, String type, List<String>? options, int points, int orderIndex, dynamic correctAnswer})>((ref, params) async {
  final db = ref.watch(firestoreProvider);
  final batch = db.batch();

  final qRef = db.collection('exams/${params.examId}/questions').doc();
  batch.set(qRef, {
    'text': params.text,
    'type': params.type,
    if (params.options != null) 'options': params.options,
    'points': params.points,
    'timerSeconds': null,
    'orderIndex': params.orderIndex,
  });

  // Doğru cevabı ayrı koleksiyona yaz
  final aRef = db.collection('exams/${params.examId}/exam_answers').doc(qRef.id);
  final answerData = <String, dynamic>{'type': params.type};
  if (params.type == 'mcq') {
    answerData['correctOptionId'] = params.correctAnswer;
  } else if (params.type == 'true_false') {
    answerData['correctBool'] = params.correctAnswer;
  } else {
    answerData['acceptedAnswers'] = [params.correctAnswer.toString().toLowerCase().trim()];
  }
  batch.set(aRef, answerData);

  // Question count güncelle
  final examRef = db.collection('exams').doc(params.examId);
  batch.update(examRef, {
    'questionCount': FieldValue.increment(1),
    'totalPoints': FieldValue.increment(params.points),
  });

  await batch.commit();
});

/// Soru sil
final deleteQuestionProvider = FutureProvider.autoDispose.family<void, ({String examId, String questionId, int points})>((ref, params) async {
  final db = ref.watch(firestoreProvider);
  final batch = db.batch();
  batch.delete(db.collection('exams/${params.examId}/questions').doc(params.questionId));
  batch.delete(db.collection('exams/${params.examId}/exam_answers').doc(params.questionId));
  batch.update(db.collection('exams').doc(params.examId), {
    'questionCount': FieldValue.increment(-1),
    'totalPoints': FieldValue.increment(-params.points),
  });
  await batch.commit();
});
