import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupDetailScreen extends StatelessWidget {
  const GroupDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('9-A Sinifi'),
        actions: [IconButton(icon: const Icon(Icons.edit), onPressed: () => context.push('/groups/1/edit'))],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stats
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  _StatItem(value: '24', label: 'Sınav'),
                  _StatItem(value: '312', label: 'Öğrenci'),
                  _StatItem(value: '3 gün', label: 'Önce'),
                ].map((w) => Expanded(child: w)).toList(),
              ),
            ),
            // Quick action
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(width: double.infinity, height: 56, child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add_circle), label: const Text('Bu Grupla Sınav Oluştur'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), foregroundColor: Colors.white))),
            ),
            // Past exams
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Geçmiş Sınavlar', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)), TextButton(onPressed: () {}, child: const Text('Daha fazla'))]),
            ),
            _ExamResultCard(name: 'Riyaziyyat Final', date: '12 Haz 2026', students: 28, avg: '72%'),
            _ExamResultCard(name: 'Kimya Bölüm 2', date: '5 Haz 2026', students: 30, avg: '68%'),
            _ExamResultCard(name: 'Türk Dili Yazılı', date: '28 May 2026', students: 25, avg: '81%'),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, label;
  const _StatItem({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
      ],
    );
  }
}

class _ExamResultCard extends StatelessWidget {
  final String name, date;
  final int students;
  final String avg;
  const _ExamResultCard({required this.name, required this.date, required this.students, required this.avg});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        subtitle: Text('$date · $students öğrenci', style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
        trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(20)), child: Text('Ort: $avg', style: const TextStyle(fontSize: 12, color: Color(0xFF2563EB), fontWeight: FontWeight.w500))),
      ),
    );
  }
}
