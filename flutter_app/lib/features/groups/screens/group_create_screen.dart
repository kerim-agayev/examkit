import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../core/firebase/firebase_providers.dart';
import '../../auth/providers/auth_provider.dart';

class GroupCreateScreen extends ConsumerStatefulWidget {
  final String? groupId;
  const GroupCreateScreen({super.key, this.groupId});

  @override
  ConsumerState<GroupCreateScreen> createState() => _GroupCreateScreenState();
}

class _GroupCreateScreenState extends ConsumerState<GroupCreateScreen> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _saving = false;

  bool get _canSave => _nameCtrl.text.trim().isNotEmpty && !_saving;
  bool get _isEdit => widget.groupId != null;

  Future<void> _save() async {
    if (!_canSave) return;

    final rtdb = ref.read(rtdbProvider);
    final user = ref.read(authStateProvider).value;
    final uid = user?.uid;
    if (uid == null || uid.isEmpty) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Giriş yapılmamış'), backgroundColor: Color(0xFFDC2626)));
      return;
    }

    setState(() => _saving = true);
    try {
      final gKey = rtdb.ref('groups').push().key!;
      final now = ServerValue.timestamp;
      await rtdb.ref('/').update({
        'groups/$gKey': {
          'name': _nameCtrl.text.trim(),
          'teacherId': uid,
          'description': _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
          'examCount': 0,
          'createdAt': now,
        },
        'groups_by_teacher/$uid/$gKey': now,
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Grup kaydedildi ✓'), backgroundColor: Color(0xFF059669)));
        context.pop();
      }
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e'), backgroundColor: const Color(0xFFDC2626)));
    } finally {
      _saving = false;
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() { _nameCtrl.dispose(); _descCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Grubu Düzenle' : 'Yeni Grup'), leading: TextButton(onPressed: () => context.pop(), child: const Text('İptal')), actions: [TextButton(onPressed: _canSave ? _save : null, child: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text('Kaydet', style: TextStyle(color: _canSave ? Theme.of(context).colorScheme.primary : const Color(0xFF94A3B8))))]),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Grup Adı *', hintText: 'Örn: 9-A Sinifi'), maxLength: 60, onChanged: (_) => setState(() {})),
        const SizedBox(height: 16),
        TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Açıklama (opsiyonel)', hintText: 'İsteğe bağlı...'), maxLines: 3),
        const SizedBox(height: 12),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.info_outline, size: 16, color: Color(0xFF0284C7)), const SizedBox(width: 8), Expanded(child: Text('Öğrenciler gruba önceden eklenmez — sınava katılırken otomatik eklenir', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF0284C7))))]),
      ])))),
    );
  }
}
