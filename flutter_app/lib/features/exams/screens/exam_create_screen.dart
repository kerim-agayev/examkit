import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_database/firebase_database.dart';
import '../providers/create_exam_provider.dart';
import '../../groups/providers/group_provider.dart';
import '../../../../core/firebase/firebase_providers.dart';
import '../../auth/providers/auth_provider.dart';

class ExamCreateScreen extends ConsumerStatefulWidget {
  const ExamCreateScreen({super.key});
  @override
  ConsumerState<ExamCreateScreen> createState() => _ExamCreateScreenState();
}

class _ExamCreateScreenState extends ConsumerState<ExamCreateScreen> {
  final _titleCtrl = TextEditingController();
  String? _selectedGroup, _selectedGroupName;
  bool _creating = false;

  bool get _canNext => _titleCtrl.text.trim().isNotEmpty && _selectedGroup != null && !_creating;

  Future<void> _createAndNext() async {
    if (!_canNext) return;

    final rtdb = ref.read(rtdbProvider);
    final user = ref.read(authStateProvider).value;
    final state = ref.read(createExamStateProvider);

    setState(() => _creating = true);
    try {
      final eKey = rtdb.ref('exams').push().key!;
      final now = ServerValue.timestamp;
      await rtdb.ref('/').update({
        'exams/$eKey': {
          'title': _titleCtrl.text.trim(),
          'groupId': _selectedGroup ?? '',
          'groupName': _selectedGroupName ?? _selectedGroup ?? '',
          'ownerTeacherId': user?.uid ?? '',
          'status': 'draft',
          'mode': state.mode,
          'questionCount': 0,
          'settings': {},
          'createdAt': now,
        },
        'exams_by_teacher/${user?.uid ?? ''}/$eKey': now,
        'groups/${_selectedGroup ?? ''}/examCount': ServerValue.increment(1),
      });

      ref.read(createExamStateProvider.notifier).state = state.copyWith(
        title: _titleCtrl.text.trim(),
        groupId: _selectedGroup,
        groupName: _selectedGroupName ?? _selectedGroup ?? '',
        examId: eKey,
      );

      if (context.mounted) context.push('/exams/create/settings');
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e'), backgroundColor: const Color(0xFFDC2626)));
    } finally {
      _creating = false;
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() { _titleCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createExamStateProvider);
    final groupsAsync = ref.watch(watchGroupsProvider);

    if (state.groupId != null && _selectedGroup == null) {
      _selectedGroup = state.groupId;
      _selectedGroupName = state.groupName;
      _titleCtrl.text = state.title;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Sınav'), bottom: PreferredSize(preferredSize: const Size.fromHeight(32), child: Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [_SC(1,true),_SL(),_SC(2,false),_SL(),_SC(3,false),_SL(),_SC(4,false),_SL(),_SC(5,false)])))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
        Text('1/5 Temel Bilgiler', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF475569))),
        const SizedBox(height: 16),
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
          TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Sınav Başlığı *', hintText: 'örn: Riyaziyyat Fənn İmtahanı'), maxLength: 100, onChanged: (_) => setState(() {})),
          const SizedBox(height: 20),
          InkWell(onTap: () async {
            final groups = groupsAsync.valueOrNull ?? [];
            if (!context.mounted) return;
            await showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (_) => SizedBox(height: 300, child: groups.isEmpty ? const Center(child: Text('Henüz grup yok')) : ListView(children: groups.map((g) => ListTile(title: Text(g.name), trailing: _selectedGroup == g.id ? const Icon(Icons.check, color: Color(0xFF2563EB)) : null, onTap: () { setState(() { _selectedGroup = g.id; _selectedGroupName = g.name; }); Navigator.pop(context); })).toList())));
          }, child: Container(height: 64, padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))), child: Row(children: [const Icon(Icons.group, color: Color(0xFF2563EB)), const SizedBox(width: 12), Expanded(child: Text(_selectedGroupName ?? _selectedGroup ?? 'Grup seçin', style: TextStyle(fontSize: 16, color: _selectedGroup != null ? const Color(0xFF0F172A) : const Color(0xFF94A3B8)))), const Icon(Icons.chevron_right)]))),
          const SizedBox(height: 8),
          Align(alignment: Alignment.centerLeft, child: TextButton.icon(onPressed: () => context.push('/groups/create'), icon: const Icon(Icons.add, size: 16), label: const Text('Yeni Grup Oluştur'))),
        ]))),
      ])),
      bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: SizedBox(width: double.infinity, height: 56, child: ElevatedButton(onPressed: _canNext ? _createAndNext : null, child: _creating ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Devam Et →'))))),
    );
  }
}

class _SC extends StatelessWidget { final int n; final bool a; const _SC(this.n, this.a); @override Widget build(BuildContext c) => Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: a ? const Color(0xFF2563EB) : Colors.transparent, border: Border.all(color: a ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0), width: 2)), child: Center(child: Text('$n', style: TextStyle(fontSize: 13, color: a ? Colors.white : const Color(0xFF94A3B8), fontWeight: FontWeight.w600)))); }
class _SL extends StatelessWidget { @override Widget build(BuildContext c) => Container(width: 16, height: 2, color: const Color(0xFFE2E8F0)); }
