import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/live_exam_provider.dart';

class LiveControlScreen extends ConsumerStatefulWidget {
  const LiveControlScreen({super.key});

  @override
  ConsumerState<LiveControlScreen> createState() => _LiveControlScreenState();
}

class _LiveControlScreenState extends ConsumerState<LiveControlScreen> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Canlı Kontrol', style: TextStyle(fontSize: 18)), Text('Biologiya Final', style: TextStyle(fontSize: 13, color: Colors.grey[600]))]),
        actions: [const Icon(Icons.wifi, color: Color(0xFF059669)), const SizedBox(width: 16)],
      ),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [Text(_started ? '⏱ Devam Ediyor' : '⏳ Sınav Başlamadı', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)), const Spacer(), const Text('Kaydırma · 20 dk', style: TextStyle(fontSize: 13, color: Color(0xFF475569)))]))),
        const SizedBox(height: 20),
        if (!_started) ...[
          const Text('8', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: Color(0xFF2563EB))),
          const Text('öğrenci hazır', style: TextStyle(fontSize: 16, color: Color(0xFF475569))),
        ] else ...[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Tamamlayan: ', style: TextStyle(fontSize: 16, color: Color(0xFF475569))), Text('5 / 8', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)))]),
          const SizedBox(height: 8),
          const LinearProgressIndicator(value: 0.62, backgroundColor: Color(0xFFE2E8F0), color: Color(0xFF059669)),
        ],
        const SizedBox(height: 20),
        Card(child: Column(children: const [
          _SR(name: 'Aynur Məmmədova', sub: '2 dk önce', done: false),
          _SR(name: 'Kamran Hüseynov', sub: '3 dk önce', done: false),
          _SR(name: 'Leyla Əsgərova', sub: '4 dk önce', done: false),
        ])),
      ])),
      bottomNavigationBar: SafeArea(
        child: Padding(padding: const EdgeInsets.all(16), child: _started
          ? SizedBox(width: double.infinity, height: 56, child: OutlinedButton(onPressed: () => setState(() => _started = false), style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFDC2626)), child: const Text('Sınavı Erken Bitir')))
          : SizedBox(width: double.infinity, height: 64, child: ElevatedButton(onPressed: () async {
              try {
                await ref.read(startExamProvider((examId: 'mock_exam_id', teacherId: 'teacher_uid', globalTimerMinutes: 20)).future);
                setState(() => _started = true);
              } catch (e) {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Başlatılamadı: $e')));
              }
            }, style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)), child: const Text('Sınavı Başlat')))),
      ),
    );
  }
}

class _SR extends StatelessWidget {
  final String name, sub;
  final bool done;
  const _SR({required this.name, required this.sub, required this.done});
  @override
  Widget build(BuildContext context) => ListTile(leading: const CircleAvatar(backgroundColor: Color(0xFFDBEAFE), child: Icon(Icons.person, color: Color(0xFF2563EB))), title: Text(name), subtitle: Text(sub), trailing: done ? const Icon(Icons.check_circle, color: Color(0xFF059669)) : Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF059669))));
}
