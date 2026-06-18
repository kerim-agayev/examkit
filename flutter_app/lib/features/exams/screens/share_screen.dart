import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/exam_code_generator.dart';
import '../../../../core/firebase/firebase_providers.dart';

class ShareScreen extends ConsumerWidget {
  final String examId;
  const ShareScreen({super.key, required this.examId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = ExamCodeGenerator.generate();
    final link = 'stitch.examkit.app/join/$code';

    // Firestore'a code + status yaz
    Future.microtask(() async {
      try {
        final db = ref.read(firestoreProvider);
        await db.collection('exams').doc(examId).update({
          'code': code,
          'status': 'active',
        });
      } catch (_) {}
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Sınavı Paylaş'), leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.go('/home'))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
        Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
          const Text('Sınav Kodu', style: TextStyle(fontSize: 13, color: Color(0xFF475569))),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: code.split('').map((c) => Container(width: 48, height: 56, margin: const EdgeInsets.symmetric(horizontal: 4), decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF2563EB))), child: Center(child: Text(c, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)))))).toList()),
          const SizedBox(height: 12),
          InkWell(onTap: () { Clipboard.setData(ClipboardData(text: link)); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Link kopyalandı'))); }, child: Text(link, style: const TextStyle(fontSize: 13, color: Color(0xFF475569)))),
        ]))),
        const SizedBox(height: 16),
        GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.2, children: [
          _SC(icon: Icons.share, color: const Color(0xFF25D366), label: 'WhatsApp', sub: 'Gruba gönder', onTap: () => Clipboard.setData(ClipboardData(text: '📝 Sınav Kodu: $code\n🔗 $link'))),
          _SC(icon: Icons.qr_code, color: const Color(0xFF2563EB), label: 'QR Kod', sub: 'Yansıt', onTap: () {}),
          _SC(icon: Icons.copy, color: const Color(0xFF475569), label: 'Linki Kopyala', sub: 'Panoya', onTap: () { Clipboard.setData(ClipboardData(text: link)); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kopyalandı'))); }),
          _SC(icon: Icons.more_horiz, color: const Color(0xFF7C3AED), label: 'Diğer', sub: 'Paylaş...', onTap: () {}),
        ]),
      ])),
      bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: SizedBox(width: double.infinity, height: 56, child: ElevatedButton.icon(onPressed: () => context.push('/exams/$examId/live'), icon: const Icon(Icons.play_circle), label: const Text('Canlı Kontrole Geç →'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), foregroundColor: Colors.white))))),
    );
  }
}

class _SC extends StatelessWidget {
  final IconData icon; final Color color; final String label, sub; final VoidCallback onTap;
  const _SC({required this.icon, required this.color, required this.label, required this.sub, required this.onTap});
  @override
  Widget build(BuildContext context) => Card(child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: Padding(padding: const EdgeInsets.all(16), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: color, size: 32), const SizedBox(height: 8), Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)), textAlign: TextAlign.center), const SizedBox(height: 4), Text(sub, style: const TextStyle(fontSize: 12, color: Color(0xFF475569)), textAlign: TextAlign.center)]))));
}
