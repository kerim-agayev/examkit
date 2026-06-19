import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_database/firebase_database.dart';
import '../providers/create_exam_provider.dart';
import '../../../../core/firebase/firebase_providers.dart';

class QuestionListScreen extends ConsumerWidget {
  const QuestionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createExamStateProvider);
    final rtdb = ref.watch(rtdbProvider);

    final questionsStream = state.examId.isNotEmpty
        ? rtdb.ref('questions/${state.examId}').orderByChild('orderIndex').onValue
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(state.title.isEmpty ? 'Sorular' : state.title),
        actions: [StreamBuilder<DatabaseEvent>(
          stream: questionsStream,
          builder: (_, snap) {
            final data = snap.data?.snapshot.value as Map<dynamic, dynamic>? ?? {};
            final count = data.length;
            final totalPoints = data.values.fold<int>(0, (s, v) => s + ((v as Map<dynamic, dynamic>)['points'] as int? ?? 0));
            return Padding(padding: const EdgeInsets.only(right: 8), child: Chip(avatar: const Icon(Icons.stars, size: 16), label: Text('$count soru · $totalPoints puan', style: const TextStyle(fontSize: 12)), backgroundColor: const Color(0xFFDBEAFE)));
          },
        )],
        bottom: PreferredSize(preferredSize: const Size.fromHeight(32), child: Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [_SC(1,false),_SL(),_SC(2,false),_SL(),_SC(3,true),_SL(),_SC(4,false)]))),
      ),
      body: state.examId.isEmpty
          ? const Center(child: Text('Önce sınavı oluşturun'))
          : StreamBuilder<DatabaseEvent>(
              stream: questionsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return Center(child: Text('Hata: ${snapshot.error}'));
                final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>? ?? {};
                if (data.isEmpty) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.quiz, size: 48, color: Colors.grey[300]), const SizedBox(height: 12), const Text('Henüz soru eklenmedi'), const SizedBox(height: 8), ElevatedButton.icon(onPressed: () => context.push('/exams/create/questions/edit'), icon: const Icon(Icons.add), label: const Text('İlk Soruyu Ekle'))]));
                final entries = data.entries.toList();
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: entries.length,
                  itemBuilder: (_, i) {
                    final e = entries[i];
                    final m = Map<dynamic, dynamic>.from(e.value);
                    final type = m['type'] as String? ?? '';
                    final text = m['text'] as String? ?? '';
                    final points = m['points'] as int? ?? 0;
                    final color = type == 'mcq' ? const Color(0xFF2563EB) : type == 'true_false' ? const Color(0xFF059669) : const Color(0xFF7C3AED);
                    final typeLabel = type == 'mcq' ? 'ÇSM' : type == 'true_false' ? 'D/Y' : 'KA';
                    return Card(
                      key: ValueKey(e.key),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.drag_handle, color: Color(0xFF94A3B8)),
                        title: Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(8)), child: Text(typeLabel, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600))), const SizedBox(width: 8), Expanded(child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis))]),
                        subtitle: Text('$points puan', style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                        trailing: IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFDC2626)), onPressed: () async {
                          try {
                            await rtdb.ref('/').update({
                              'questions/${state.examId}/${e.key}': null,
                              'exam_answers/${state.examId}/${e.key}': null,
                              'exams/${state.examId}/questionCount': ServerValue.increment(-1),
                            });
                          } catch (err) {
                            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Silinemedi: $err'), backgroundColor: const Color(0xFFDC2626)));
                          }
                        }),
                      ),
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
        Expanded(child: SizedBox(height: 56, child: OutlinedButton(onPressed: () => context.push('/exams/create/questions/edit'), style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFF2563EB)))), child: const Text('+ Soru Ekle')))),
        const SizedBox(width: 12),
        Expanded(child: SizedBox(height: 56, child: ElevatedButton(onPressed: () => context.push('/exams/create/preview'), child: const Text('Devam Et →')))),
      ]))),
    );
  }
}

class _SC extends StatelessWidget { final int n; final bool a; const _SC(this.n, this.a); @override Widget build(BuildContext c) => Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: a ? const Color(0xFF2563EB) : Colors.transparent, border: Border.all(color: a ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0), width: 2)), child: Center(child: Text('$n', style: TextStyle(fontSize: 13, color: a ? Colors.white : const Color(0xFF94A3B8), fontWeight: FontWeight.w600)))); }
class _SL extends StatelessWidget { @override Widget build(BuildContext c) => Container(width: 20, height: 2, color: const Color(0xFFE2E8F0)); }
