import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_database/firebase_database.dart';
import '../providers/group_provider.dart';
import '../../exams/providers/create_exam_provider.dart';
import '../../../../core/firebase/firebase_providers.dart';

class GroupDetailScreen extends ConsumerWidget {
  final String groupId, groupName;
  const GroupDetailScreen({super.key, required this.groupId, required this.groupName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rtdb = ref.watch(rtdbProvider);
    final examsStream = rtdb.ref('exams').orderByChild('groupId').equalTo(groupId).onValue;

    return Scaffold(
      appBar: AppBar(title: Text(groupName), actions: [IconButton(icon: const Icon(Icons.edit), onPressed: () => context.push('/groups/$groupId/edit'))]),
      body: StreamBuilder<DatabaseEvent>(
        stream: examsStream,
        builder: (context, snapshot) {
          final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>? ?? {};
          final exams = data.entries.toList();
          final examCount = exams.length;
          final draftCount = exams.where((e) => (e.value as Map<dynamic, dynamic>)['status'] == 'draft').length;
          final publishedCount = exams.where((e) => (e.value as Map<dynamic, dynamic>)['status'] == 'published').length;

          return SingleChildScrollView(child: Column(children: [
            Container(color: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), child: Row(children: [_S('$examCount', 'Sınav'), _S('$draftCount', 'Taslak'), _S('$publishedCount', 'Yayında')].map((w) => Expanded(child: w)).toList())),
            Padding(padding: const EdgeInsets.all(16), child: SizedBox(width: double.infinity, height: 56, child: ElevatedButton.icon(onPressed: () { ref.read(createExamStateProvider.notifier).state = CreateExamState().copyWith(groupId: groupId, groupName: groupName); context.push('/exams/create'); }, icon: const Icon(Icons.add_circle), label: const Text('Bu Grupla Sınav Oluştur'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), foregroundColor: Colors.white)))),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Sınavlar', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)), Text('$examCount sınav', style: const TextStyle(fontSize: 13, color: Color(0xFF475569)))])),
            if (exams.isEmpty) const Padding(padding: EdgeInsets.all(16), child: Text('Henüz sınav yok', style: TextStyle(color: Color(0xFF94A3B8))))
            else ...exams.map((e) {
              final m = Map<dynamic, dynamic>.from(e.value);
              final title = m['title'] ?? '', qc = m['questionCount'] ?? 0, status = m['status'] ?? 'draft';
              final st = status == 'published' ? 'Yayında' : status == 'active' ? '● Canlı' : 'Taslak';
              final sc = status == 'published' ? const Color(0xFF2563EB) : status == 'active' ? const Color(0xFF059669) : const Color(0xFFD97706);
              return Card(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), child: ListTile(title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), subtitle: Text('$qc soru', style: const TextStyle(fontSize: 13, color: Color(0xFF475569))), trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: sc.withAlpha(25), borderRadius: BorderRadius.circular(20)), child: Text(st, style: TextStyle(fontSize: 12, color: sc, fontWeight: FontWeight.w500))), onTap: status == 'published' || status == 'active' ? () => context.push('/exams/${e.key}/results') : () => context.push('/exams/${e.key}/share')));
            }),
          ]));
        },
      ),
    );
  }
}

class _S extends StatelessWidget { final String v, l; const _S(this.v, this.l); @override Widget build(BuildContext c) => Column(children: [Text(v, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)), Text(l, style: const TextStyle(fontSize: 13, color: Color(0xFF475569)))]); }
