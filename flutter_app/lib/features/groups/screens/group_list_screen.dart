import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupListScreen extends StatelessWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gruplarım'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => context.push('/groups/create')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search
          TextField(
            decoration: InputDecoration(
              hintText: 'Grup ara...',
              prefixIcon: const Icon(Icons.search),
              filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            ),
          ),
          const SizedBox(height: 12),
          _GroupTile(name: '9-A Sinifi', count: 8, lastActive: '2 gün önce', onTap: () => context.push('/groups/1')),
          const SizedBox(height: 8),
          _GroupTile(name: '10-B Matematik', count: 12, lastActive: '5 gün önce', activeCount: 3, onTap: () => context.push('/groups/2')),
          const SizedBox(height: 8),
          _GroupTile(name: '11-A Fizik', count: 5, lastActive: '1 hafta önce', onTap: () => context.push('/groups/3')),
          const SizedBox(height: 8),
          _GroupTile(name: '12-C Kimya', count: 15, lastActive: 'Dün', onTap: () => context.push('/groups/4')),
        ],
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  final String name;
  final int count;
  final String lastActive;
  final int? activeCount;
  final VoidCallback onTap;
  const _GroupTile({required this.name, required this.count, required this.lastActive, this.activeCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(backgroundColor: const Color(0xFFDBEAFE), child: const Icon(Icons.group, color: Color(0xFF2563EB))),
        title: Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        subtitle: Text('$count sınav · Son: $lastActive', style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (activeCount != null) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(20)), child: Text('$activeCount Aktif', style: const TextStyle(fontSize: 11, color: Color(0xFFDC2626), fontWeight: FontWeight.w500))),
            const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}
