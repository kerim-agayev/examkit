import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/exam_code_generator.dart';
import '../../../../core/firebase/firebase_providers.dart';

class ShareScreen extends ConsumerStatefulWidget {
  final String examId;
  const ShareScreen({super.key, required this.examId});
  @override ConsumerState<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends ConsumerState<ShareScreen> {
  late final String _code, _webLink;

  @override void initState() {
    super.initState();
    _code = ExamCodeGenerator.generate();
    _webLink = 'https://examkit-beta.vercel.app/join/$_code';
    Future.microtask(() async {
      try {
        await ref.read(rtdbProvider).ref('exams/${widget.examId}').update({'code': _code});
      } catch (e) { debugPrint('ShareScreen: $e'); }
    });
  }

  Future<void> _shareWhatsApp() async {
    final msg = '📝 *ExamKit Sınavı*\n\nSınava katılmak için:\n🔗 $_webLink\n\nKod: $_code';
    final url = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(msg)}');
    try {
      if (await canLaunchUrl(url)) { await launchUrl(url, mode: LaunchMode.externalApplication); return; }
    } catch (_) {}
    await Clipboard.setData(ClipboardData(text: msg));
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('WhatsApp yüklü değil, link ve kod panoya kopyalandı ✓')));
  }

  @override Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cardW = ((w - 48) / 6).clamp(28.0, 48.0); // responsive card width
    return Scaffold(
      appBar: AppBar(title: const Text('Sınavı Paylaş'), leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.go('/home'))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
          const Text('Sınav Kodu', style: TextStyle(fontSize: 13, color: Color(0xFF475569))),
          const SizedBox(height: 8),
          Wrap(alignment: WrapAlignment.center, spacing: 4, children: _code.split('').map((c) => Container(width: cardW, height: cardW * 1.2, margin: const EdgeInsets.symmetric(horizontal: 2), decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF2563EB))), child: Center(child: Text(c, style: TextStyle(fontSize: cardW * 0.55, fontWeight: FontWeight.w700, color: const Color(0xFF2563EB)))))).toList()),
          const SizedBox(height: 12),
          InkWell(onTap: () { Clipboard.setData(ClipboardData(text: _webLink)); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Link kopyalandı ✓'))); }, child: Text(_webLink, style: const TextStyle(fontSize: 12, color: Color(0xFF475569)))),
        ]))),
        const SizedBox(height: 12),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF86EFAC))), child: const Row(children: [Icon(Icons.info_outline, color: Color(0xFF059669), size: 18), SizedBox(width: 10), Expanded(child: Text('Öğrenciler linke tıklayarak katılabilir. Uygulama indirmeye gerek yok!', style: TextStyle(fontSize: 13, color: Color(0xFF065F46))))])),
        const SizedBox(height: 12),
        GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.3, children: [
          _Card(Icons.chat, const Color(0xFF25D366), 'WhatsApp', 'Paylaş', _shareWhatsApp),
          _Card(Icons.copy, const Color(0xFF2563EB), 'Linki Kopyala', 'Panoya', () { Clipboard.setData(ClipboardData(text: _webLink)); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kopyalandı ✓'))); }),
          _Card(Icons.pin, const Color(0xFF475569), 'Kodu Kopyala', 'Sadece kod', () { Clipboard.setData(ClipboardData(text: _code)); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kod kopyalandı ✓'))); }),
          _Card(Icons.more_horiz, const Color(0xFF7C3AED), 'Diğer', 'Tüm yollar', () { Clipboard.setData(ClipboardData(text: '$_webLink')); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Link kopyalandı ✓'))); }),
        ]),
      ])),
      bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: SizedBox(width: double.infinity, height: 56, child: ElevatedButton.icon(onPressed: () => context.push('/exams/${widget.examId}/live'), icon: const Icon(Icons.play_circle), label: const Text('Canlı Kontrole Geç →'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), foregroundColor: Colors.white))))),
    );
  }
}

class _Card extends StatelessWidget {
  final IconData icon; final Color color; final String l, s; final VoidCallback t;
  const _Card(this.icon, this.color, this.l, this.s, this.t);
  @override Widget build(BuildContext c) => Card(child: InkWell(onTap: t, borderRadius: BorderRadius.circular(14), child: Padding(padding: const EdgeInsets.all(14), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: color, size: 28), const SizedBox(height: 6), Text(l, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center), const SizedBox(height: 2), Text(s, style: const TextStyle(fontSize: 11, color: Color(0xFF475569)), textAlign: TextAlign.center)]))));
}
