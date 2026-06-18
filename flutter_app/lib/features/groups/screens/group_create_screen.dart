import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/group_provider.dart';
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
  bool get _canSave => _nameCtrl.text.trim().isNotEmpty;
  bool get _isEdit => widget.groupId != null;
  bool _saving = false;

  Future<void> _save() async {
    if (!_canSave || _saving) return;
    setState(() => _saving = true);
    try {
      // Direkt Firestore'a yaz (FutureProvider yerine, daha güvenilir)
      final firestore = ref.read(firestoreProvider);
      final user = ref.read(authStateProvider).value;
      await firestore.collection('groups').add({
        'name': _nameCtrl.text.trim(),
        'teacherId': user?.uid ?? '',
        'description': _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        'examCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kaydedilemedi: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Grubu Düzenle' : 'Yeni Grup'), leading: TextButton(onPressed: () => context.pop(), child: const Text('İptal')), actions: [TextButton(onPressed: _canSave ? _save : null, child: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text('Kaydet', style: TextStyle(color: _canSave ? Theme.of(context).colorScheme.primary : const Color(0xFF94A3B8))))]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Grup Adı *', hintText: 'Örn: 9-A Sinifi', counterText: '0/60'), maxLength: 60, onChanged: (_) => setState(() {})),
              const SizedBox(height: 16),
              TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Açıklama (opsiyonel)', hintText: 'İsteğe bağlı...'), maxLines: 3),
              const SizedBox(height: 12),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.info_outline, size: 16, color: Color(0xFF0284C7)), const SizedBox(width: 8), Expanded(child: Text('Öğrenciler gruba önceden eklenmez — sınava katılırken otomatik eklenir', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF0284C7))))]),
            ]),
          ),
        ),
      ),
    );
  }
}
