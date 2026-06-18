import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/group_provider.dart';
import '../../exams/providers/exam_provider.dart';
import '../../exams/providers/create_exam_provider.dart';

class GroupDetailScreen extends ConsumerWidget {
  final String groupId;
  final String groupName;
  const GroupDetailScreen({super.key, required this.groupId, required this.groupName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(watchGroupsProvider);
    final examsAsync = ref.watch(watchExamsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(groupName), actions: [IconButton(icon: const Icon(Icons.edit), onPressed: () => context.push('/groups/$groupId/edit'))]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(color: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), child: Row(children: [
              _Stat('${examsAsync.valueOrNull?.where((e) => e.groupId == groupId).length ?? 0}', 'Sınav'),
              _Stat('—', 'Öğrenci'),
              _Stat('—', 'Önce'),
            ].map((w) => Expanded(child: w)).toList())),
            Padding(padding: const EdgeInsets.all(16), child: SizedBox(width: double.infinity, height: 56, child: ElevatedButton.icon(
              onPressed: () {
                ref.read(createExamStateProvider.notifier).state = CreateExamState().copyWith(groupId: groupId, groupName: groupName);
                context.push('/exams/create');
              },
              icon: const Icon(Icons.add_circle), label: const Text('Bu Grupla Sınav Oluştur'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), foregroundColor: Colors.white),
            ))),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Geçmiş Sınavlar', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)), TextButton(onPressed: () {}, child: const Text('Daha fazla'))])),
            examsAsync.when(
              loading: () => const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())),
              error: (e, _) => Text('$e'),
              data: (exams) {
                final filtered = exams.where((e) => e.groupId == groupId).toList();
                if (filtered.isEmpty) return const Padding(padding: EdgeInsets.all(16), child: Text('Henüz sınav yok'));
                return Column(children: filtered.map((e) => Card(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), child: ListTile(title: Text(e.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), subtitle: Text('${e.questionCount} soru', style: const TextStyle(fontSize: 13, color: Color(0xFF475569))), trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(20)), child: Text('${e.status}', style: const TextStyle(fontSize: 12, color: Color(0xFF2563EB), fontWeight: FontWeight.w500)))))).toList());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String v, l;
  const _Stat(this.v, this.l);
  @override
  Widget build(BuildContext context) => Column(children: [Text(v, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))), Text(l, style: const TextStyle(fontSize: 13, color: Color(0xFF475569)))]);
}
