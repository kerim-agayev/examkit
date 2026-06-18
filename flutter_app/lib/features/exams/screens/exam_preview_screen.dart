import 'package:flutter/material.dart';

class ExamPreviewScreen extends StatelessWidget {
  const ExamPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Önizleme')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(16)),
              child: const Row(children: [Icon(Icons.visibility, color: Color(0xFF2563EB)), SizedBox(width: 8), Expanded(child: Text('Öğrencinin göreceği görünüm', style: TextStyle(color: Color(0xFF2563EB))))]),
            ),
            const SizedBox(height: 16),
            // Exam card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text('Biologiya Final İmtahanı', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text('Kaydırma Modu · 20 soru · 45 dk · 65 puan', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF475569)), textAlign: TextAlign.center),
                    const Divider(height: 32),
                    // Q1
                    _PreviewQuestion(num: 1, text: 'Mitoz bölünmenin temel amacı nedir?', type: 'mcq'),
                    const SizedBox(height: 20),
                    _PreviewQuestion(num: 2, text: 'DNA replikasyonu S fazasında gerçekleşir.', type: 'tf'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('← Düzenle'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('Yayınla →'))),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewQuestion extends StatelessWidget {
  final int num;
  final String text;
  final String type;
  const _PreviewQuestion({required this.num, required this.text, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Soru $num', style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        if (type == 'mcq')
          ...['Büyüme ve onarım', 'Enerji üretimi', 'Sindirim', 'Boşaltım'].map((o) => Container(
            width: double.infinity, margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(12)),
            child: Text(o, style: const TextStyle(fontSize: 15)),
          )),
        if (type == 'tf')
          Row(children: [
            Expanded(child: Container(height: 48, alignment: Alignment.center, decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(12)), child: const Text('Doğru'))),
            const SizedBox(width: 8),
            Expanded(child: Container(height: 48, alignment: Alignment.center, decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(12)), child: const Text('Yanlış'))),
          ]),
      ],
    );
  }
}
