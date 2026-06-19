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
              _ExamTab(exams: exams, onDelete: (id) => _deleteExam(ref, id, context)),
              _ExamTab(exams: exams.where((e) => e.status == 'draft').toList(), onDelete: (id) => _deleteExam(ref, id, context)),
              _ExamTab(exams: exams.where((e) => e.status == 'active' || e.status == 'published').toList(), onDelete: (id) => _deleteExam(ref, id, context)),
              _ExamTab(exams: exams.where((e) => e.status == 'completed').toList(), onDelete: (id) => _deleteExam(ref, id, context)),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () => context.push('/exams/create'), child: const Icon(Icons.add)),
      ),
    );
  }
}

void _deleteExam(WidgetRef ref, String examId, BuildContext context) async {
  final confirm = await showDialog<bool>(context: context, builder: (c) => AlertDialog(title: const Text('Sınavı Sil'), content: const Text('Bu sınav ve tüm soruları kalıcı olarak silinecek. Emin misiniz?'), actions: [
    TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('İptal')),
    TextButton(onPressed: () => Navigator.pop(c, true), style: TextButton.styleFrom(foregroundColor: const Color(0xFFDC2626)), child: const Text('Sil')),
  ]));
  if (confirm == true) {
    try {
      await ref.read(deleteExamProvider(examId).future);
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sınav silindi ✓'), backgroundColor: Color(0xFF059669)));
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Silinemedi: $e'), backgroundColor: const Color(0xFFDC2626)));
    }
  }
}

class _ExamTab extends StatelessWidget {
  final List<ExamModel> exams;
  final void Function(String examId) onDelete;
  const _ExamTab({required this.exams, required this.onDelete});

  static const _statusColors = {'draft': Color(0xFFD97706), 'published': Color(0xFF0284C7), 'active': Color(0xFF059669), 'completed': Color(0xFF94A3B8)};
  static const _statusLabels = {'draft': 'Taslak', 'published': 'Yayında', 'active': '● Canlı', 'completed': 'Tamamlandı'};

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
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(20)), child: Text(_statusLabels[e.status] ?? '', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500))),
              const SizedBox(width: 4),
              IconButton(icon: const Icon(Icons.delete_outline, size: 20, color: Color(0xFF94A3B8)), onPressed: () => onDelete(e.id)),
            ]),
            onTap: () {
              switch (e.status) {
                case 'draft': context.push('/exams/${e.id}/share'); break; // draft → edit/continue
                case 'published': context.push('/exams/${e.id}/live'); break;
                case 'active': context.push('/exams/${e.id}/live'); break;
                case 'completed': context.push('/exams/${e.id}/results'); break;
                default: context.push('/exams/${e.id}/results');
              }
            },
          ),
        );
      },
    );
  }
}
