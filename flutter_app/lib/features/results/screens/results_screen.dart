import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../core/firebase/firebase_providers.dart';

class ResultsScreen extends ConsumerWidget {
  final String examId;
  const ResultsScreen({super.key, required this.examId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rtdb = ref.watch(rtdbProvider);
    final leaderboardStream = rtdb.ref('leaderboards/$examId').onValue;

    return StreamBuilder<DatabaseEvent>(
      stream: leaderboardStream,
      builder: (context, snapshot) {
        final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>? ?? {};
        final entries = data.entries.toList()
          ..sort((a, b) => ((a.value as Map)['rank'] as int?)?.compareTo(((b.value as Map)['rank'] as int?) ?? 0) ?? 0);

        final count = entries.length;
        final avgPct = entries.isEmpty ? 0 : (entries.fold<int>(0, (s, e) => s + (((e.value as Map)['percentage'] as int?) ?? 0)) / entries.length).round();
        final maxPct = entries.isEmpty ? 0 : entries.map((e) => ((e.value as Map)['percentage'] as int?) ?? 0).reduce((a, b) => a > b ? a : b);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Sınav Sonuçları'),
            bottom: PreferredSize(preferredSize: const Size.fromHeight(22), child: Padding(padding: const EdgeInsets.only(bottom: 8), child: Text('$count öğrenci', style: TextStyle(fontSize: 13, color: Colors.grey[600])))),
          ),
          body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Card(child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
              _S('$count', 'Katılımcı'), _S('%$avgPct', 'Ortalama'), _S('%$maxPct', 'En Yüksek'),
            ].map((w) => Expanded(child: w)).toList()))),
            const SizedBox(height: 16),
            Text('Sıralama', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            if (entries.isEmpty)
              const Padding(padding: EdgeInsets.all(24), child: Text('Henüz sonuç yok', style: TextStyle(color: Color(0xFF94A3B8))))
            else
              ...entries.map((e) {
                final m = Map<dynamic, dynamic>.from(e.value);
                final rank = m['rank'] ?? 0;
                final name = m['studentName'] ?? '?';
                final score = m['score'] ?? 0;
                final pct = m['percentage'] ?? 0;
                final emoji = rank == 1 ? '🥇' : rank == 2 ? '🥈' : rank == 3 ? '🥉' : '$rank';
                final bg = rank <= 3 ? const Color(0xFFDBEAFE) : Colors.white;
                return Card(color: bg, margin: const EdgeInsets.only(bottom: 4), child: ListTile(
                  leading: SizedBox(width: 32, child: Text(emoji, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center)),
                  title: Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  subtitle: Text('$score puan · %$pct', style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
                ));
              }),
          ])),
        );
      },
    );
  }
}

class _S extends StatelessWidget { final String v, l; const _S(this.v, this.l); @override Widget build(BuildContext c) => Column(children: [Text(v, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)), Text(l, style: const TextStyle(fontSize: 12, color: Color(0xFF475569)))]); }
