import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/exam_code_generator.dart';

class ShareScreen extends ConsumerWidget {
  const ShareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = ExamCodeGenerator.generate();
    return Scaffold(
      appBar: AppBar(title: const Text('Sınavı Paylaş'), leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)), bottom: PreferredSize(preferredSize: const Size.fromHeight(32), child: Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [_SC(1, false), _SL(), _SC(2, false), _SL(), _SC(3, false), _SL(), _SC(4, false), _SL(), _SC(5, true)])))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Code Hero
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text('Sınav Kodu', style: TextStyle(fontSize: 13, color: Color(0xFF475569))),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: code.split('').map((c) => Container(
                        width: 48, height: 56,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF2563EB))),
                        child: Center(child: Text(c, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF2563EB), letterSpacing: 2))),
                      )).toList(),
                    ),
                    const SizedBox(height: 12),
                    InkWell(onTap: () => Clipboard.setData(ClipboardData(text: 'stitch.examkit.app/join/$code')), child: Text('stitch.examkit.app/join/$code', style: TextStyle(fontSize: 13, color: Color(0xFF475569)))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Share Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.2,
              children: [
                _ShareCard(icon: Icons.share, color: const Color(0xFF25D366), label: 'WhatsApp', sub: 'Mesaj hazır, gönder!'),
                _ShareCard(icon: Icons.qr_code, color: const Color(0xFF2563EB), label: 'QR Kod', sub: 'Yansıt veya paylaş'),
                _ShareCard(icon: Icons.copy, color: const Color(0xFF475569), label: 'Linki Kopyala', sub: 'Panoya kopyala'),
                _ShareCard(icon: Icons.more_horiz, color: const Color(0xFF7C3AED), label: 'Diğer', sub: 'Telegram, Mail...'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(width: double.infinity, height: 56, child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.play_circle), label: const Text('Canlı Kontrole Geç →'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), foregroundColor: Colors.white))),
        ),
      ),
    );
  }
}

class _SC extends StatelessWidget {
  final int n; final bool a;
  const _SC(this.n, this.a);
  @override
  Widget build(BuildContext context) => Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: a ? const Color(0xFF2563EB) : Colors.transparent, border: Border.all(color: a ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0), width: 2)), child: Center(child: Text('$n', style: TextStyle(fontSize: 13, color: a ? Colors.white : const Color(0xFF94A3B8), fontWeight: FontWeight.w600))));
}

class _SL extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 16, height: 2, color: const Color(0xFFE2E8F0));
}

class _ShareCard extends StatelessWidget {
  final IconData icon; final Color color; final String label, sub;
  const _ShareCard({required this.icon, required this.color, required this.label, required this.sub});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: color, size: 32), const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(sub, style: const TextStyle(fontSize: 12, color: Color(0xFF475569)), textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }
}
