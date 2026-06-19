import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/group_provider.dart';
import '../../../../core/firebase/firebase_providers.dart';

class GroupListScreen extends ConsumerWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(watchGroupsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gruplarım'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () => context.push('/groups/create'))],
      ),
      body: groupsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.error_outline, size: 48, color: Color(0xFFDC2626)), const SizedBox(height: 8), Text('$e', textAlign: TextAlign.center)],)),
        data: (groups) {
          if (groups.isEmpty) {
            return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.group, size: 48, color: Colors.grey[300]), const SizedBox(height: 12), const Text('Henüz grup yok'), const SizedBox(height: 8), ElevatedButton(onPressed: () => context.push('/groups/create'), child: const Text('İlk Grubu Oluştur'))]));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groups.length,
            itemBuilder: (_, i) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: Color(0xFFDBEAFE), child: Icon(Icons.group, color: Color(0xFF2563EB))),
                title: Text(groups[i].name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                subtitle: Text('${groups[i].examCount} sınav', style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
                trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                onTap: () => context.push('/groups/${groups[i].id}'),
              ),
            ),
          );
        },
      ),
    );
  }
}
