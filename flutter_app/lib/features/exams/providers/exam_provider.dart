import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/firebase/firebase_providers.dart';

class ExamModel {
  final String id;
  final String title;
  final String groupId;
  final String? groupName;
  final String ownerTeacherId;
  final String status;
  final String mode;
  final int questionCount;
  final Map<String, dynamic>? settings;
  final DateTime createdAt;

  ExamModel({required this.id, required this.title, required this.groupId, this.groupName, required this.ownerTeacherId, this.status = 'draft', this.mode = 'scroll', this.questionCount = 0, this.settings, required this.createdAt});

  factory ExamModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return ExamModel(
      id: doc.id,
      title: d['title'] ?? '',
      groupId: d['groupId'] ?? '',
      groupName: d['groupName'],
      ownerTeacherId: d['ownerTeacherId'] ?? '',
      status: d['status'] ?? 'draft',
      mode: d['mode'] ?? 'scroll',
      questionCount: d['questionCount'] ?? 0,
      settings: d['settings'] as Map<String, dynamic>?,
      createdAt: (d['createdAt'] as Timestamp).toDate(),
    );
  }
}

/// Sınav listesini dinle
final watchExamsProvider = StreamProvider.autoDispose<List<ExamModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return const Stream.empty();

  final firestore = ref.watch(firestoreProvider);
  return firestore
    .collection('exams')
    .where('ownerTeacherId', isEqualTo: user.uid)
    .orderBy('createdAt', descending: true)
    .snapshots()
    .map((snap) => snap.docs.map((d) => ExamModel.fromFirestore(d)).toList());
});

/// Sınav oluştur (basit)
final createExamProvider = FutureProvider.autoDispose.family<void, ({String title, String groupId, String? groupName})>((ref, params) async {
  final user = ref.read(authStateProvider).value;
  if (user == null) throw Exception('Giriş yapılmamış');

  final firestore = ref.read(firestoreProvider);
  await firestore.collection('exams').add({
    'title': params.title,
    'groupId': params.groupId,
    'groupName': params.groupName,
    'ownerTeacherId': user.uid,
    'status': 'draft',
    'mode': 'scroll',
    'questionCount': 0,
    'settings': {},
    'createdAt': FieldValue.serverTimestamp(),
  });
});

/// Sınav sil
final deleteExamProvider = FutureProvider.autoDispose.family<void, String>((ref, examId) async {
  final firestore = ref.read(firestoreProvider);
  await firestore.collection('exams').doc(examId).delete();
});
