import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultsScreen extends ConsumerWidget {
  final String examId;
  const ResultsScreen({super.key, required this.examId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sınav Sonuçları'), bottom: PreferredSize(preferredSize: const Size.fromHeight(22), child: Padding(padding: const EdgeInsets.only(bottom: 8), child: Text('Biologiya Final · 8 öğrenci', style: TextStyle(fontSize: 13, color: Colors.grey[600]))))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _ResultStat('8', 'Katılımcı'), _ResultStat('%72', 'Ortalama'), _ResultStat('%94', 'En Yüksek'), _ResultStat('%75', 'Geçme'),
                  ].map((w) => Expanded(child: w)).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Leaderboard
            Text('Sıralama', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _LeaderboardRow(rank: '🥇', name: 'Aynur Məmmədova', score: '94% · 48/50', time: '18:32', color: const Color(0xFFDBEAFE)),
            _LeaderboardRow(rank: '🥈', name: 'Kamran Hüseynov', score: '88% · 44/50', time: '21:15', color: Colors.white),
            _LeaderboardRow(rank: '🥉', name: 'Leyla Əsgərova', score: '82% · 41/50', time: '19:44', color: Colors.white),
            _LeaderboardRow(rank: '4', name: 'Murad Əliyev', score: '76% · 38/50', time: '17:20', color: Colors.white),
            const SizedBox(height: 16),
            // Question analysis
            Text('Soru Analizi', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...List.generate(5, (i) => Row(children: [Text('S${i + 1}', style: const TextStyle(fontSize: 13, color: Color(0xFF475569))), const SizedBox(width: 8), Expanded(child: LinearProgressIndicator(value: [0.9, 0.85, 0.45, 0.92, 0.78][i], color: [0.9, 0.85, 0.45, 0.92, 0.78][i] > 0.7 ? const Color(0xFF059669) : const Color(0xFFDC2626))), const SizedBox(width: 8), Text('%${[90, 85, 45, 92, 78][i]}', style: const TextStyle(fontSize: 12))]).padding(const EdgeInsets.symmetric(vertical: 4))),
          ],
        ),
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String value, label;
  const _ResultStat(this.value, this.label);
  @override
  Widget build(BuildContext context) => Column(children: [Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)), Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF475569)))]);
}

class _LeaderboardRow extends StatelessWidget {
  final String rank, name, score, time;
  final Color color;
  const _LeaderboardRow({required this.rank, required this.name, required this.score, required this.time, required this.color});
  @override
  Widget build(BuildContext context) {
    return Card(color: color, margin: const EdgeInsets.only(bottom: 4), child: ListTile(leading: SizedBox(width: 32, child: Text(rank, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center)), title: Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)), subtitle: Text(score, style: const TextStyle(fontSize: 13, color: Color(0xFF475569))), trailing: Text(time, style: const TextStyle(fontSize: 13, color: Color(0xFF475569)))));
  }
}

extension _P on Widget {
  Widget padding(EdgeInsets p) => Padding(padding: p, child: this);
}
