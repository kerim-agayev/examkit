import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/firebase/firebase_providers.dart';

/// LiveExamProvider — Realtime Database üzerinden canlı sınav kontrolü.
/// Öğretmen sınavı başlatır/bitirir, öğrenci durumlarını izler.

class LiveExamState {
  final String status; // waiting | active | ended
  final String teacherId;
  final int? startedAt;
  final int? globalTimerEndsAt;
  final Map<String, StudentPresence> students;

  const LiveExamState({this.status = 'waiting', this.teacherId = '', this.startedAt, this.globalTimerEndsAt, this.students = const {}});
}

class StudentPresence {
  final String name;
  final int joinedAt;
  final int progress;
  final String status; // waiting | active | completed

  const StudentPresence({required this.name, required this.joinedAt, this.progress = 0, this.status = 'waiting'});

  factory StudentPresence.fromMap(Map<dynamic, dynamic> map) {
    return StudentPresence(
      name: map['name'] ?? '',
      joinedAt: map['joinedAt'] ?? 0,
      progress: map['progress'] ?? 0,
      status: map['status'] ?? 'waiting',
    );
  }
}

/// Canlı sınav durumunu RTDB'den dinle
final watchLiveExamProvider = StreamProvider.autoDispose.family<LiveExamState, String>((ref, examId) {
  final rtdb = ref.watch(rtdbProvider);
  return rtdb.ref('live_exams/$examId').onValue.map((event) {
    if (event.snapshot.value == null) return const LiveExamState();
    final data = Map<String, dynamic>.from(event.snapshot.value as Map);
    final studentsRaw = data['students'] as Map<dynamic, dynamic>? ?? {};
    final students = <String, StudentPresence>{};
    studentsRaw.forEach((k, v) {
      students[k.toString()] = StudentPresence.fromMap(Map<String, dynamic>.from(v));
    });
    return LiveExamState(
      status: data['status'] ?? 'waiting',
      teacherId: data['teacherId'] ?? '',
      startedAt: data['startedAt'],
      globalTimerEndsAt: data['globalTimerEndsAt'],
      students: students,
    );
  });
});

/// Sınavı başlat
final startExamProvider = FutureProvider.autoDispose.family<void, ({String examId, String teacherId, int? globalTimerMinutes})>((ref, params) async {
  final rtdb = ref.watch(rtdbProvider);
  final now = DateTime.now().millisecondsSinceEpoch;
  final data = <String, dynamic>{
    'teacherId': params.teacherId,
    'status': 'active',
    'startedAt': now,
  };
  if (params.globalTimerMinutes != null) {
    data['globalTimerEndsAt'] = now + (params.globalTimerMinutes! * 60 * 1000);
  }
  await rtdb.ref('live_exams/${params.examId}').update(data);
});

/// Sınavı bitir
final endExamProvider = FutureProvider.autoDispose.family<void, String>((ref, examId) async {
  final rtdb = ref.watch(rtdbProvider);
  // Hem live_exams hem exams status güncelle
  await rtdb.ref('/').update({
    'live_exams/$examId/status': 'ended',
    'exams/$examId/status': 'completed',
  });
});

/// Öğrenci sayısı
final studentCountProvider = Provider.autoDispose.family<int, LiveExamState>((ref, state) {
  return state.students.length;
});
