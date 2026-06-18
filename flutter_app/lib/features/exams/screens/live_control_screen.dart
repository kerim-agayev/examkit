import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/live_exam_provider.dart';

class LiveControlScreen extends StatefulWidget {
  const LiveControlScreen({super.key});

  @override
  State<LiveControlScreen> createState() => _LiveControlScreenState();
}

class _LiveControlScreenState extends State<LiveControlScreen> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Canlı Kontrol', style: TextStyle(fontSize: 18)), Text('Biologiya Final', style: TextStyle(fontSize: 13, color: Colors.grey[600]))]),
        actions: [const Icon(Icons.wifi, color: Color(0xFF059669)), const SizedBox(width: 16)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Info bar
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(_started ? '⏱ Devam Ediyor' : '⏳ Sınav Başlamadı', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    const Spacer(),
                    const Text('Kaydırma · 20 dk', style: TextStyle(fontSize: 13, color: Color(0xFF475569))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Counter
            if (!_started) ...[
              Text('8', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary)),
              const Text('öğrenci hazır', style: TextStyle(fontSize: 16, color: Color(0xFF475569))),
            ] else ...[
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('Tamamlayan: ', style: TextStyle(fontSize: 16, color: Color(0xFF475569))),
                Text('5 / 8', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary)),
              ]),
              const SizedBox(height: 8),
              const LinearProgressIndicator(value: 0.62, backgroundColor: Color(0xFFE2E8F0), color: Color(0xFF059669)),
            ],
            const SizedBox(height: 20),
            // Student list
            Card(
              child: Column(
                children: [
                  _StudentRow(name: 'Aynur Məmmədova', sub: '2 dk önce katıldı', status: _started ? StudentStatus.done : StudentStatus.waiting),
                  const Divider(height: 1),
                  _StudentRow(name: 'Kamran Hüseynov', sub: '3 dk önce katıldı', status: _started ? StudentStatus.progress : StudentStatus.waiting),
                  const Divider(height: 1),
                  _StudentRow(name: 'Leyla Əsgərova', sub: '4 dk önce katıldı', status: _started ? StudentStatus.done : StudentStatus.waiting),
                  const Divider(height: 1),
                  _StudentRow(name: 'Murad Əliyev', sub: '5 dk önce katıldı', status: _started ? StudentStatus.progress : StudentStatus.waiting),
                  const Divider(height: 1),
                  _StudentRow(name: 'Nigar Həsənova', sub: '6 dk önce katıldı', status: _started ? StudentStatus.done : StudentStatus.waiting),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _started
              ? SizedBox(width: double.infinity, height: 56, child: OutlinedButton(onPressed: () => setState(() => _started = false), style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFDC2626), side: const BorderSide(color: Color(0xFFDC2626))), child: const Text('Sınavı Erken Bitir')))
              : SizedBox(width: double.infinity, height: 64, child: ElevatedButton(onPressed: () => setState(() => _started = true), style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)), child: const Text('Sınavı Başlat'))),
        ),
      ),
    );
  }
}

enum StudentStatus { waiting, progress, done }

class _StudentRow extends StatelessWidget {
  final String name, sub;
  final StudentStatus status;
  const _StudentRow({required this.name, required this.sub, required this.status});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: const Color(0xFFDBEAFE), child: Text(name[0], style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600))),
      title: Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
      trailing: status == StudentStatus.done ? const Icon(Icons.check_circle, color: Color(0xFF059669))
          : status == StudentStatus.progress ? const SizedBox(width: 24, child: LinearProgressIndicator(value: 0.75, color: Color(0xFF2563EB)))
          : Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF059669))),
    );
  }
}
