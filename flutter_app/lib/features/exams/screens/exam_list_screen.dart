import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/exam_provider.dart';
import '../../../l10n/app_localizations.dart';

class ExamListScreen extends ConsumerWidget {
  const ExamListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examsAsync = ref.watch(watchExamsProvider);
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.examsTitle), bottom: TabBar(isScrollable: true, tabs: [Tab(text: l10n.homeSeeAll), Tab(text: l10n.statusDraft), Tab(text: l10n.statusActive), Tab(text: l10n.statusCompleted)])),
        body: examsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (exams) => TabBarView(
            children: [
              _ExamTab(exams: exams, onDelete: (id) => _deleteExam(ref, id, context, l10n)),
              _ExamTab(exams: exams.where((e) => e.status == 'draft').toList(), onDelete: (id) => _deleteExam(ref, id, context, l10n)),
              _ExamTab(exams: exams.where((e) => e.status == 'active' || e.status == 'published').toList(), onDelete: (id) => _deleteExam(ref, id, context, l10n)),
              _ExamTab(exams: exams.where((e) => e.status == 'completed').toList(), onDelete: (id) => _deleteExam(ref, id, context, l10n)),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () => context.push('/exams/create'), child: const Icon(Icons.add)),
      ),
    );
  }
}

void _deleteExam(WidgetRef ref, String examId, BuildContext context, AppLocalizations l10n) async {
  final confirm = await showDialog<bool>(context: context, builder: (c) => AlertDialog(title: Text(l10n.examsTitle), content: const Text('Bu sınav ve tüm soruları kalıcı olarak silinecek. Emin misiniz?'), actions: [
    TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.groupCancel)),
    TextButton(onPressed: () => Navigator.pop(c, true), style: TextButton.styleFrom(foregroundColor: const Color(0xFFDC2626)), child: Text(l10n.settingsLogout)),
  ]));
  if (confirm == true) {
    try {
      await ref.read(deleteExamProvider(examId).future);
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.settingsLogout} ✓'), backgroundColor: const Color(0xFF059669)));
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'), backgroundColor: const Color(0xFFDC2626)));
    }
  }
}

class _ExamTab extends StatelessWidget {
  final List<ExamModel> exams;
  final void Function(String examId) onDelete;
  const _ExamTab({required this.exams, required this.onDelete});

  static const _statusColors = {'draft': Color(0xFFD97706), 'published': Color(0xFF0284C7), 'active': Color(0xFF059669), 'completed': Color(0xFF94A3B8)};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = <String, String>{
      'draft': l10n.statusDraft,
      'published': l10n.statusActive,
      'active': l10n.statusLive,
      'completed': l10n.statusCompleted,
    };
    if (exams.isEmpty) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.assignment, size: 48, color: Colors.grey[300]), const SizedBox(height: 12), Text(l10n.examsEmpty)]));
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
            subtitle: Text('${e.groupName ?? "—"} · ${e.questionCount} ${l10n.homeExams.toLowerCase()}', style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(20)), child: Text(labels[e.status] ?? '', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500))),
              const SizedBox(width: 4),
              IconButton(icon: const Icon(Icons.delete_outline, size: 20, color: Color(0xFF94A3B8)), onPressed: () => onDelete(e.id)),
            ]),
            onTap: () {
              switch (e.status) {
                case 'draft': context.push('/exams/${e.id}/share'); break;
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
