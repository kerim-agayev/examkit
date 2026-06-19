import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _nameCtrl = TextEditingController();
  final _schoolCtrl = TextEditingController();
  String _lang = 'az';

  bool get _canSave => _nameCtrl.text.trim().isNotEmpty;

  void _save() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseDatabase.instance.ref('users/${user.uid}').set({
        'name': _nameCtrl.text.trim(),
        'school': _schoolCtrl.text.trim(),
        'lang': _lang,
        'updatedAt': ServerValue.timestamp,
      });
    }
    context.go('/home');
  }

  @override
  void dispose() { _nameCtrl.dispose(); _schoolCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Bilgileri'), actions: [Padding(padding: const EdgeInsets.only(right: 8), child: Chip(label: Text('Adım 1/1', style: TextStyle(color: Theme.of(context).colorScheme.primary))))]),
      body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [
        const CircleAvatar(radius: 40, backgroundColor: Color(0xFF2563EB), child: Text('K', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600))),
        const SizedBox(height: 24),
        TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Ad Soyad', hintText: 'Adınız Soyadınız'), onChanged: (_) => setState(() {})),
        const SizedBox(height: 16),
        TextField(controller: _schoolCtrl, decoration: const InputDecoration(labelText: 'Okul Adı (opsiyonel)', hintText: 'Çalıştığınız okul')),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(child: _langCard('az', '🇦🇿 Azərbaycan dili', _lang == 'az', () => setState(() => _lang = 'az'))),
          const SizedBox(width: 12),
          Expanded(child: _langCard('tr', '🇹🇷 Türkçe', _lang == 'tr', () => setState(() => _lang = 'tr'))),
        ]),
        const SizedBox(height: 32),
        SizedBox(width: double.infinity, height: 56, child: ElevatedButton(onPressed: _canSave ? _save : null, child: const Text('Tamamla ve Başla'))),
      ])),
    );
  }

  Widget _langCard(String code, String label, bool selected, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Container(height: 80, decoration: BoxDecoration(color: selected ? const Color(0xFFDBEAFE) : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: selected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0), width: selected ? 2 : 1.5)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(label.split(' ')[0], style: const TextStyle(fontSize: 22)), const SizedBox(height: 4), Text(label.split(' ').skip(1).join(' '), style: const TextStyle(fontSize: 13, color: Color(0xFF475569)))])));
  }
}
