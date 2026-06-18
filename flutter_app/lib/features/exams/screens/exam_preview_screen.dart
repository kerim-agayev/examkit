import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/create_exam_provider.dart';
import '../providers/exam_provider.dart';
import '../../../../core/utils/exam_code_generator.dart';

class ExamPreviewScreen extends ConsumerWidget {
  const ExamPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createExamStateProvider);

    Future<void> publish() async {
      try {
        // 1. Firestore'da sınav oluştur
        await ref.read(createExamProvider(
          (title: state.title, groupId: state.groupId ?? '', groupName: state.groupName),
        ).future);

        // 2. Kod üret ve paylaş sayfasına geç
        if (context.mounted) context.push('/exams/${state.groupId}/share');
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Yayınlanamadı: $e')));
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Önizleme')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(16)), child: const Row(children: [Icon(Icons.visibility, color: Color(0xFF2563EB)), SizedBox(width: 8), Expanded(child: Text('Öğrencinin göreceği görünüm', style: TextStyle(color: Color(0xFF2563EB))))])),
          const SizedBox(height: 16),
          Card(
            child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
              Text(state.title.isEmpty ? 'Sınav Başlığı' : state.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text('${state.mode == "scroll" ? "Kaydırma" : "Sıralı"} · ${state.globalTimer ? "${state.globalTimerMinutes} dk" : "Süresiz"}', style: const TextStyle(fontSize: 13, color: Color(0xFF475569)), textAlign: TextAlign.center),
            ])),
          ),
        ]),
      ),
      bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
        Expanded(child: OutlinedButton(onPressed: () => context.pop(), child: const Text('← Düzenle'))),
        const SizedBox(width: 12),
        Expanded(child: ElevatedButton(onPressed: publish, child: const Text('Yayınla →'))),
      ]))),
    );
  }
}
