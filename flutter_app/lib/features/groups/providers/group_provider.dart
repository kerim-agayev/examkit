import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/firebase/firebase_providers.dart';
import '../../auth/providers/auth_provider.dart';

/// Grup model (Firestore'dan)
class GroupModel {
  final String id;
  final String name;
  final String teacherId;
  final String? description;
  final int examCount;
  final DateTime createdAt;

  GroupModel({required this.id, required this.name, required this.teacherId, this.description, this.examCount = 0, required this.createdAt});

  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return GroupModel(
      id: doc.id,
      name: d['name'] ?? '',
      teacherId: d['teacherId'] ?? '',
      description: d['description'],
      examCount: d['examCount'] ?? 0,
      createdAt: d['createdAt'] != null ? (d['createdAt'] as Timestamp).toDate() : DateTime.now(),
    );
  }
}

/// Grup listesini dinle
final watchGroupsProvider = StreamProvider.autoDispose<List<GroupModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return const Stream.empty();

  final firestore = ref.watch(firestoreProvider);
  return firestore
    .collection('groups')
    .where('teacherId', isEqualTo: user.uid)
    .orderBy('createdAt', descending: true)
    .snapshots()
    .map((snap) => snap.docs.map((d) => GroupModel.fromFirestore(d)).toList());
});

/// Grup oluştur
final createGroupProvider = FutureProvider.autoDispose.family<void, ({String name, String? description})>((ref, params) async {
  final user = ref.read(authStateProvider).value;
  if (user == null) throw Exception('Giriş yapılmamış');

  final firestore = ref.read(firestoreProvider);
  await firestore.collection('groups').add({
    'name': params.name,
    'teacherId': user.uid,
    'description': params.description,
    'examCount': 0,
    'createdAt': FieldValue.serverTimestamp(),
  });
});

// Güncelle ve sil için placeholder
final deleteGroupProvider = FutureProvider.autoDispose.family<void, String>((ref, groupId) async {
  final firestore = ref.read(firestoreProvider);
  await firestore.collection('groups').doc(groupId).delete();
});
