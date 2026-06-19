import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../../app.dart';class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(radius: 32, backgroundColor: const Color(0xFF2563EB), child: Text(user?.displayName?[0] ?? '?', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600))),
              title: Text(user?.displayName ?? 'Kullanıcı', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              subtitle: const Text('ExamKit Öğretmen', style: TextStyle(fontSize: 14, color: Color(0xFF475569))),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 8), child: Text('Uygulama Dili', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF475569)))),
              Consumer(builder: (_, ref, __) {
                final lang = ref.watch(appLanguageProvider);
                return Column(children: [
                  ListTile(title: const Text('🇦🇿 Azərbaycan dili'), trailing: lang == 'az' ? const Icon(Icons.check, color: Color(0xFF2563EB)) : null, onTap: () => ref.read(appLanguageProvider.notifier).state = 'az'),
                  const Divider(height: 1),
                  ListTile(title: const Text('🇹🇷 Türkçe'), trailing: lang == 'tr' ? const Icon(Icons.check, color: Color(0xFF2563EB)) : null, onTap: () => ref.read(appLanguageProvider.notifier).state = 'tr'),
                ]);
              }),
            ]),
          ),
          const SizedBox(height: 12),
          Card(child: Column(children: [ListTile(title: const Text('ExamKit v1.0.0'), leading: const Icon(Icons.info_outline)), const Divider(height: 1), ListTile(title: const Text('Hakkında'), leading: const Icon(Icons.description_outlined))])),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFFDC2626)),
              title: const Text('Çıkış Yap', style: TextStyle(color: Color(0xFFDC2626))),
              onTap: () async {
                await ref.read(signOutProvider.future);
                if (context.mounted) context.go('/login');
              },
            ),
          ),
        ],
      ),
    );
  }
}
