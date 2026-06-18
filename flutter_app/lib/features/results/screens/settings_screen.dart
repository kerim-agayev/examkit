import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const CircleAvatar(radius: 32, backgroundColor: Color(0xFF2563EB), child: Text('K', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600))),
              title: const Text('Kerim Agayev', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              subtitle: const Text('Bakü Fen Lisesi', style: TextStyle(fontSize: 14, color: Color(0xFF475569))),
              trailing: TextButton(onPressed: () {}, child: const Text('Düzenle')),
            ),
          ),
          const SizedBox(height: 12),
          // Language
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 8), child: Text('Uygulama Dili', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF475569)))),
                ListTile(title: const Text('🇦🇿 Azərbaycan dili'), trailing: const Icon(Icons.check, color: Color(0xFF2563EB)), onTap: () {}),
                const Divider(height: 1),
                ListTile(title: const Text('🇹🇷 Türkçe'), onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // About
          Card(
            child: Column(
              children: [
                ListTile(title: const Text('ExamKit v1.0.0'), leading: const Icon(Icons.info_outline), onTap: () {}),
                const Divider(height: 1),
                ListTile(title: const Text('Hakkında'), leading: const Icon(Icons.description_outlined), onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Logout
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFFDC2626)),
              title: const Text('Çıkış Yap', style: TextStyle(color: Color(0xFFDC2626))),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
