import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExamListScreen extends StatelessWidget {
  const ExamListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(title: const Text('Sınavlarım'), bottom: const TabBar(isScrollable: true, tabs: [Tab(text: 'Tümü'), Tab(text: 'Taslak'), Tab(text: 'Aktif'), Tab(text: 'Tamamlandı')])),
        body: TabBarView(
          children: [
            _ExamListTab(filter: null),
            _ExamListTab(filter: 'Taslak'),
            _ExamListTab(filter: 'Aktif'),
            _ExamListTab(filter: 'Tamamlandı'),
          ],
        ),
        floatingActionButton: FloatingActionButton(onPressed: () => context.push('/exams/create'), child: const Icon(Icons.add)),
      ),
    );
  }
}

class _ExamListTab extends StatelessWidget {
  final String? filter;
  const _ExamListTab({required this.filter});

  static const _allExams = [
    ('Biologiya Final', '11-A', '15 soru', 'Aktif', Color(0xFF0284C7)),
    ('Fizika Bölüm 3', '10-B', '8 soru', 'Taslak', Color(0xFFD97706)),
    ('Tarix Yazılı', '9-A', '20 soru', 'Tamamlandı', Color(0xFF94A3B8)),
    ('Kimya Final', '12-C', '12 soru', 'Aktif', Color(0xFF0284C7)),
  ];

  @override
  Widget build(BuildContext context) {
    final exams = filter == null ? _allExams : _allExams.where((e) => e.$4 == filter).toList();
    if (exams.isEmpty) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.assignment, size: 48, color: Colors.grey[300]), const SizedBox(height: 12), Text('Henüz sınav yok', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF94A3B8)))],));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exams.length,
      itemBuilder: (_, i) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          title: Text(exams[i].$1, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          subtitle: Text('${exams[i].$2} · ${exams[i].$3}', style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
          trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: exams[i].$5.withAlpha(25), borderRadius: BorderRadius.circular(20)), child: Text(exams[i].$4, style: TextStyle(fontSize: 12, color: exams[i].$5, fontWeight: FontWeight.w500))),
          onTap: () {},
        ),
      ),
    );
  }
}
