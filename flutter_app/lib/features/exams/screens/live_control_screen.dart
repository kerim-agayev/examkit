import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/live_exam_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../results/services/score_calculator.dart';
import '../../../../core/firebase/firebase_providers.dart';

class LiveControlScreen extends ConsumerWidget {
  final String examId;
  const LiveControlScreen({super.key, required this.examId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveAsync = ref.watch(watchLiveExamProvider(examId));
    final user = ref.watch(authStateProvider).value;

    return liveAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Hata: $e'))),
      data: (live) {
        final started = live.status == 'active';
        final students = live.students.values.toList();
        final completedCount = students.where((s) => s.status == 'completed').length;

        return Scaffold(
          appBar: AppBar(title: const Text('Canlı Kontrol'), actions: [const Icon(Icons.wifi, color: Color(0xFF059669)), const SizedBox(width: 16)]),
          body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
            Card(child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
              Text(started ? '⏱ Devam Ediyor' : '⏳ Başlamadı', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              const Spacer(),
              Text('${students.length} öğrenci', style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
            ]))),
            const SizedBox(height: 20),
            if (!started) ...[
              Text('${students.length}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: Color(0xFF2563EB))),
              const Text('öğrenci hazır', style: TextStyle(fontSize: 16, color: Color(0xFF475569))),
            ] else ...[
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Tamamlayan: ', style: TextStyle(fontSize: 16)), Text('$completedCount / ${students.length}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)))]),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: students.isEmpty ? 0 : completedCount / students.length, backgroundColor: const Color(0xFFE2E8F0), color: const Color(0xFF059669)),
            ],
            const SizedBox(height: 20),
            if (students.isNotEmpty)
              Card(child: Column(children: students.map((s) => ListTile(
                leading: CircleAvatar(backgroundColor: s.status == 'completed' ? const Color(0xFFD1FAE5) : const Color(0xFFDBEAFE), child: Icon(s.status == 'completed' ? Icons.check_circle : Icons.person, color: s.status == 'completed' ? const Color(0xFF059669) : const Color(0xFF2563EB))),
                title: Text(s.name), subtitle: Text(s.status == 'completed' ? 'Tamamladı' : s.status == 'active' ? 'Sınavda' : 'Bekliyor'),
                trailing: Text('${s.progress} soru', style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
              )).toList()))
            else
              const Padding(padding: EdgeInsets.all(24), child: Text('Henüz katılan öğrenci yok', style: TextStyle(color: Color(0xFF94A3B8)))),
          ])),
          bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: started
            ? SizedBox(width: double.infinity, height: 56, child: OutlinedButton(onPressed: () async {
                try {
                  await ref.read(endExamProvider(examId).future);
                  // Puanlamayı tetikle
                  ref.read(scoreCalculatorProvider).calculateAllScores(examId);
                  if (context.mounted) context.push('/exams/$examId/results');
                } catch (e) {
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
                }
              }, style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFDC2626)), child: const Text('Sınavı Bitir ve Sonuçları Gör')))
            : SizedBox(width: double.infinity, height: 64, child: ElevatedButton(onPressed: () async {
                try {
                  // Exam settings'ten timer süresini al
                  int? timerMinutes;
                  try {
                    final examSnap = await ref.read(rtdbProvider).ref('exams/$examId/settings').get();
                    if (examSnap.exists) {
                      final settings = Map<String, dynamic>.from(examSnap.value as Map);
                      timerMinutes = settings['globalTimerMinutes'] as int?;
                    }
                  } catch (_) {}
                  await ref.read(startExamProvider((examId: examId, teacherId: user?.uid ?? '', globalTimerMinutes: timerMinutes)).future);
                } catch (e) {
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Başlatılamadı: $e')));
                }
              }, style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)), child: const Text('Sınavı Başlat')))),
          ),
        );
      },
    );
  }
}
