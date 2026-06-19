import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/firebase/firebase_providers.dart';

class ExamModel {
  final String id, title, groupId, ownerTeacherId, status, mode;
  final String? groupName;
  final int questionCount, createdAt;
  final Map<String, dynamic>? settings;

  ExamModel({required this.id, required this.title, required this.groupId, this.groupName, required this.ownerTeacherId, this.status = 'draft', this.mode = 'scroll', this.questionCount = 0, this.settings, required this.createdAt});

  factory ExamModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return ExamModel(
      id: id,
      title: map['title'] ?? '',
      groupId: map['groupId'] ?? '',
      groupName: map['groupName'],
      ownerTeacherId: map['ownerTeacherId'] ?? '',
      status: map['status'] ?? 'draft',
      mode: map['mode'] ?? 'scroll',
      questionCount: map['questionCount'] ?? 0,
      settings: map['settings'] != null ? Map<String, dynamic>.from(map['settings']) : null,
      createdAt: map['createdAt'] ?? 0,
    );
  }
}

/// Sınav listesini dinle
final watchExamsProvider = StreamProvider.autoDispose<List<ExamModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return const Stream.empty();

  final rtdb = ref.watch(rtdbProvider);
  final controller = StreamController<List<ExamModel>>();

  void refresh(Map<dynamic, dynamic> index) async {
    final exams = <ExamModel>[];
    for (final key in index.keys) {
      final snap = await rtdb.ref('exams/$key').get();
      if (snap.exists) {
        exams.add(ExamModel.fromMap(key.toString(), snap.value as Map));
      }
    }
    exams.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    controller.add(exams);
  }

  final sub = rtdb.ref('exams_by_teacher/${user.uid}').onValue.listen((event) {
    final index = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
    refresh(index);
  });

  ref.onDispose(() { sub.cancel(); controller.close(); });
  return controller.stream;
});

final createExamProvider = FutureProvider.autoDispose.family<String, ({String title, String groupId, String? groupName})>((ref, params) async {
  final user = ref.read(authStateProvider).value;
  if (user == null) throw Exception('Giriş yapılmamış');

  final rtdb = ref.read(rtdbProvider);
  final eKey = rtdb.ref('exams').push().key!;
  final now = ServerValue.timestamp;
      await rtdb.ref('/').update({
    'exams/$eKey': {
      'title': params.title,
      'groupId': params.groupId,
      'groupName': params.groupName,
      'ownerTeacherId': user.uid,
      'status': 'draft',
      'mode': 'scroll',
      'questionCount': 0,
      'settings': {},
      'createdAt': now,
    },
    'exams_by_teacher/${user.uid}/$eKey': now,
    'groups/${params.groupId}/examCount': ServerValue.increment(1),
  });
  return eKey;
});

final deleteExamProvider = FutureProvider.autoDispose.family<void, String>((ref, examId) async {
  final rtdb = ref.read(rtdbProvider);
  final snap = await rtdb.ref('exams/$examId').get();
  if (snap.exists) {
    final data = snap.value as Map;
    final teacherId = data['ownerTeacherId'] ?? '';
    await rtdb.ref('/').update({
      'exams/$examId': null,
      'exams_by_teacher/$teacherId/$examId': null,
      'questions/$examId': null,
      'exam_answers/$examId': null,
      'sessions_by_exam/$examId': null,
    });
  }
});
