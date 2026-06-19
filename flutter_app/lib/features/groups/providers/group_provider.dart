import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/firebase/firebase_providers.dart';
import '../../auth/providers/auth_provider.dart';

class GroupModel {
  final String id, name, teacherId;
  final String? description;
  final int examCount, createdAt;

  GroupModel({required this.id, required this.name, required this.teacherId, this.description, this.examCount = 0, required this.createdAt});

  factory GroupModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return GroupModel(
      id: id,
      name: map['name'] ?? '',
      teacherId: map['teacherId'] ?? '',
      description: map['description'],
      examCount: map['examCount'] ?? 0,
      createdAt: map['createdAt'] ?? 0,
    );
  }
}

/// Grup listesini dinle — groups_by_teacher/{uid} index
final watchGroupsProvider = StreamProvider.autoDispose<List<GroupModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return const Stream.empty();

  final rtdb = ref.watch(rtdbProvider);
  final controller = StreamController<List<GroupModel>>();

  void refresh(Map<dynamic, dynamic> index) async {
    final groups = <GroupModel>[];
    for (final key in index.keys) {
      final snap = await rtdb.ref('groups/$key').get();
      if (snap.exists) {
        groups.add(GroupModel.fromMap(key.toString(), snap.value as Map));
      }
    }
    groups.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    controller.add(groups);
  }

  final sub = rtdb.ref('groups_by_teacher/${user.uid}').onValue.listen((event) {
    final index = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
    refresh(index);
  });

  ref.onDispose(() { sub.cancel(); controller.close(); });
  return controller.stream;
});

/// Grup oluştur — groups/ + groups_by_teacher/ atomik
final createGroupProvider = FutureProvider.autoDispose.family<void, ({String name, String? description})>((ref, params) async {
  final user = ref.read(authStateProvider).value;
  if (user == null) throw Exception('Giriş yapılmamış');

  final rtdb = ref.read(rtdbProvider);
  final gKey = rtdb.ref('groups').push().key!;
  final now = ServerValue.timestamp;
  await rtdb.ref('/').update({
    'groups/$gKey': {
      'name': params.name,
      'teacherId': user.uid,
      'description': params.description,
      'examCount': 0,
      'createdAt': now,
    },
    'groups_by_teacher/${user.uid}/$gKey': now,
  });
});

final deleteGroupProvider = FutureProvider.autoDispose.family<void, String>((ref, groupId) async {
  final rtdb = ref.read(rtdbProvider);
  final snap = await rtdb.ref('groups/$groupId').get();
  if (snap.exists) {
    final data = snap.value as Map;
    final teacherId = data['teacherId'] ?? '';
    await rtdb.ref('/').update({
      'groups/$groupId': null,
      'groups_by_teacher/$teacherId/$groupId': null,
    });
  }
});
