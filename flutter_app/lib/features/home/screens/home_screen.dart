import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../groups/providers/group_provider.dart';
import '../../exams/providers/exam_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final groupsAsync = ref.watch(watchGroupsProvider);
    final examsAsync = ref.watch(watchExamsProvider);
    final theme = Theme.of(context);

    final groupCount = groupsAsync.valueOrNull?.length ?? 0;
    final examCount = examsAsync.valueOrNull?.length ?? 0;
    final recentExams = examsAsync.valueOrNull?.take(3).toList() ?? [];
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Merhaba, ${user?.displayName?.split(' ').first ?? 'Öğretmen'} 👋', style: const TextStyle(fontSize: 18)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(radius: 18, backgroundColor: theme.colorScheme.primary, child: Text(user?.displayName?[0] ?? '?', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Row
            Row(
              children: [
                _StatCard(icon: Icons.people, color: const Color(0xFF2563EB), value: '$groupCount', label: 'Grup'),
                const SizedBox(width: 8),
                _StatCard(icon: Icons.assignment, color: const Color(0xFF059669), value: '$examCount', label: 'Sınav'),
                const SizedBox(width: 8),
                _StatCard(icon: Icons.person, color: const Color(0xFFD97706), value: '—', label: 'Bugün'),
              ],
            ),
            const SizedBox(height: 16),
            // Quick Actions
            SizedBox(width: double.infinity, height: 64, child: ElevatedButton.icon(onPressed: () => context.push('/groups/create'), icon: const Icon(Icons.group_add), label: const Text('Yeni Grup Oluştur'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white))),
            const SizedBox(height: 8),
            SizedBox(width: double.infinity, height: 64, child: ElevatedButton.icon(onPressed: () => context.push('/exams/create'), icon: const Icon(Icons.add_circle), label: const Text('Yeni Sınav Oluştur'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), foregroundColor: Colors.white))),
            const SizedBox(height: 24),
            // Recent Exams
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Son Sınavlar', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                TextButton(onPressed: () => context.push('/exams'), child: const Text('Tümünü Gör')),
              ],
            ),
            if (recentExams.isEmpty)
              const Padding(padding: EdgeInsets.all(16), child: Text('Henüz sınav yok', style: TextStyle(color: Color(0xFF94A3B8))))
            else
              ...recentExams.map((e) => Padding(padding: const EdgeInsets.only(bottom: 8), child: _ExamCard(title: e.title, subtitle: e.groupName ?? '', status: e.status == 'active' ? '● Canlı' : e.status == 'draft' ? 'Taslak' : 'Tamamlandı', color: e.status == 'active' ? const Color(0xFF059669) : e.status == 'draft' ? const Color(0xFFD97706) : const Color(0xFF94A3B8)))),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (i) {
          switch (i) {
            case 0: context.go('/home');
            case 1: context.push('/groups');
            case 2: context.push('/exams');
            case 3: context.push('/settings');
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          NavigationDestination(icon: Icon(Icons.group), label: 'Gruplar'),
          NavigationDestination(icon: Icon(Icons.assignment), label: 'Sınavlar'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Ayarlar'),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  const _StatCard({required this.icon, required this.color, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
              Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF475569))),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExamCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final Color color;
  const _ExamCard({required this.title, required this.subtitle, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(backgroundColor: color.withAlpha(25), child: Icon(Icons.quiz, color: color)),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 14, color: Color(0xFF475569))),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(status, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
