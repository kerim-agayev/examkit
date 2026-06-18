import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/exam_provider.dart';

class ExamListScreen extends ConsumerWidget {
  const ExamListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examsAsync = ref.watch(watchExamsProvider);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(title: const Text('Sınavlarım'), bottom: const TabBar(isScrollable: true, tabs: [Tab(text: 'Tümü'), Tab(text: 'Taslak'), Tab(text: 'Aktif'), Tab(text: 'Tamamlandı')])),
        body: examsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (exams) => TabBarView(
            children: [
              _ExamTab(exams: exams),
              _ExamTab(exams: exams.where((e) => e.status == 'draft').toList()),
              _ExamTab(exams: exams.where((e) => e.status == 'active' || e.status == 'live').toList()),
              _ExamTab(exams: exams.where((e) => e.status == 'completed').toList()),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () => context.push('/exams/create'), child: const Icon(Icons.add)),
      ),
    );
  }
}

class _ExamTab extends StatelessWidget {
  final List<ExamModel> exams;
  const _ExamTab({required this.exams});

  static const _statusColors = {'draft': Color(0xFFD97706), 'active': Color(0xFF0284C7), 'live': Color(0xFF059669), 'completed': Color(0xFF94A3B8)};
  static const _statusLabels = {'draft': 'Taslak', 'active': 'Aktif', 'live': '● Canlı', 'completed': 'Tamamlandı'};

  @override
  Widget build(BuildContext context) {
    if (exams.isEmpty) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.assignment, size: 48, color: Colors.grey[300]), const SizedBox(height: 12), const Text('Henüz sınav yok')]));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exams.length,
      itemBuilder: (_, i) {
        final e = exams[i];
        final color = _statusColors[e.status] ?? const Color(0xFF94A3B8);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(e.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            subtitle: Text('${e.groupName ?? "—"} · ${e.questionCount} soru', style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
            trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(20)), child: Text(_statusLabels[e.status] ?? '', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500))),
            onTap: () {},
          ),
        );
      },
    );
  }
}
