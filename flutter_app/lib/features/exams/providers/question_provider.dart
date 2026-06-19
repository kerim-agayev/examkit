import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/firebase/firebase_providers.dart';

class QuestionModel {
  final String id, text, type;
  final List<String>? options;
  final int points, orderIndex;

  const QuestionModel({required this.id, required this.text, required this.type, this.options, this.points = 1, this.orderIndex = 0});

  factory QuestionModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return QuestionModel(
      id: id, text: map['text'] ?? '', type: map['type'] ?? 'mcq',
      options: map['options'] != null ? List<String>.from(map['options']) : null,
      points: map['points'] ?? 1, orderIndex: map['orderIndex'] ?? 0,
    );
  }
}

final watchQuestionsProvider = StreamProvider.family<List<QuestionModel>, String>((ref, examId) {
  final rtdb = ref.watch(rtdbProvider);
  final controller = StreamController<List<QuestionModel>>.broadcast();

  void refresh(DatabaseEvent event) {
    final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
    final list = data.entries
        .map((e) => QuestionModel.fromMap(e.key.toString(), Map<dynamic, dynamic>.from(e.value)))
        .toList();
    list.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    controller.add(list);
  }

  final ref_ = rtdb.ref('questions/$examId');
  final sub = ref_.onValue.listen(refresh);
  ref.onDispose(() { sub.cancel(); controller.close(); });

  // initial fetch
  ref_.get().then((snap) {
    if (snap.exists) {
      final data = snap.value as Map<dynamic, dynamic>? ?? {};
      final list = data.entries
          .map((e) => QuestionModel.fromMap(e.key.toString(), Map<dynamic, dynamic>.from(e.value)))
          .toList();
      list.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
      controller.add(list);
    } else {
      controller.add([]);
    }
  });

  return controller.stream;
});

final createQuestionProvider = FutureProvider.autoDispose.family<void, ({String examId, String text, String type, List<String>? options, int points, int orderIndex, dynamic correctAnswer})>((ref, params) async {
  final rtdb = ref.read(rtdbProvider);
  final qKey = rtdb.ref('questions/${params.examId}').push().key!;
  final q = <String, dynamic>{
    'text': params.text, 'type': params.type, 'points': params.points, 'orderIndex': params.orderIndex,
    if (params.options != null) 'options': params.options,
  };
  final a = <String, dynamic>{'type': params.type};
  if (params.type == 'mcq') { a['correctOptionId'] = params.correctAnswer; }
  else if (params.type == 'true_false') { a['correctBool'] = params.correctAnswer; }
  else { a['acceptedAnswers'] = [params.correctAnswer.toString().toLowerCase().trim()]; }
  await rtdb.ref('/').update({
    'questions/${params.examId}/$qKey': q,
    'exam_answers/${params.examId}/$qKey': a,
    'exams/${params.examId}/questionCount': ServerValue.increment(1),
  });
});

final deleteQuestionProvider = FutureProvider.autoDispose.family<void, ({String examId, String questionId, int points})>((ref, params) async {
  final rtdb = ref.read(rtdbProvider);
  await rtdb.ref('/').update({
    'questions/${params.examId}/${params.questionId}': null,
    'exam_answers/${params.examId}/${params.questionId}': null,
    'exams/${params.examId}/questionCount': ServerValue.increment(-1),
  });
});
