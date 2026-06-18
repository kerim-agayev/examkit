import 'package:flutter/material.dart';

class StudentResultDetailScreen extends StatelessWidget {
  const StudentResultDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aynur Məmmədova')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Medal
            Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(20)), child: const Text('🥇 1. Sırada', style: TextStyle(fontWeight: FontWeight.w600))),
            const SizedBox(height: 12),
            // Score
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text('48 / 50 puan', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    const Text('%96', style: TextStyle(fontSize: 24, color: Color(0xFF059669), fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    const Text('18 dk 32 sn · 1. Sıra / 8 öğrenci', style: TextStyle(fontSize: 14, color: Color(0xFF475569))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Summary
            Row(children: [
              _SummaryChip('46 ✓', const Color(0xFF059669)),
              _SummaryChip('3 ✗', const Color(0xFFDC2626)),
              _SummaryChip('1 –', const Color(0xFF94A3B8)),
            ].map((w) => Expanded(child: w)).toList()),
            const SizedBox(height: 16),
            // Questions
            _QuestionResult(q: '1', text: 'Mitoz bölünmenin...', status: _QStatus.correct, points: '+3'),
            _QuestionResult(q: '2', text: 'DNA replikasyonu...', status: _QStatus.correct, points: '+1'),
            _QuestionResult(q: '7', text: 'Fotosentezin ürünü...', status: _QStatus.wrong, detail: 'Seçilen: B  Doğru: D', points: '0'),
            _QuestionResult(q: '15', text: 'Hücre zarı modeli...', status: _QStatus.empty, points: '0'),
          ],
        ),
      ),
    );
  }
}

enum _QStatus { correct, wrong, empty }

class _SummaryChip extends StatelessWidget {
  final String text;
  final Color color;
  const _SummaryChip(this.text, this.color);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(12), child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color))),
    );
  }
}

class _QuestionResult extends StatelessWidget {
  final String q, text, points;
  final _QStatus status;
  final String? detail;
  const _QuestionResult({required this.q, required this.text, required this.status, required this.points, this.detail});

  @override
  Widget build(BuildContext context) {
    final icon = status == _QStatus.correct ? Icons.check_circle : status == _QStatus.wrong ? Icons.cancel : Icons.radio_button_off;
    final color = status == _QStatus.correct ? const Color(0xFF059669) : status == _QStatus.wrong ? const Color(0xFFDC2626) : const Color(0xFF94A3B8);
    final label = status == _QStatus.correct ? 'Doğru' : status == _QStatus.wrong ? 'Yanlış' : 'Boş';

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('S$q: $text', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(label, style: TextStyle(fontSize: 12, color: color)),
                  if (detail != null) Text(detail!, style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
                ],
              ),
            ),
            Text(points, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
