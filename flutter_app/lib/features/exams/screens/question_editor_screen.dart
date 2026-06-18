import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/question_provider.dart';

class QuestionEditorScreen extends ConsumerStatefulWidget {
  const QuestionEditorScreen({super.key});

  @override
  ConsumerState<QuestionEditorScreen> createState() => _QuestionEditorScreenState();
}

class _QuestionEditorScreenState extends ConsumerState<QuestionEditorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  int _points = 3;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soru Editörü'),
        actions: [TextButton(onPressed: () async {
          try {
            await ref.read(createQuestionProvider((examId: 'mock_exam_id', text: 'Yeni Soru', type: 'mcq', options: ['A', 'B', 'C', 'D'], points: _points, orderIndex: 0, correctAnswer: 'A')).future);
            if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Soru kaydedildi')));
          } catch (e) {
            if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
          }
        }, child: const Text('Kaydet'))],
        bottom: TabBar(controller: _tabCtrl, tabs: const [Tab(text: 'ÇSM'), Tab(text: 'D/Y'), Tab(text: 'KA')]),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _McqTab(points: _points),
                _TfTab(points: _points),
                _SaTab(points: _points),
              ],
            ),
          ),
          // Points bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Text('Puan:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: _points > 1 ? () => setState(() => _points--) : null),
                Text('$_points', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary)),
                IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => setState(() => _points++)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// MCQ Tab
class _McqTab extends StatefulWidget {
  final int points;
  const _McqTab({required this.points});
  @override
  State<_McqTab> createState() => _McqTabState();
}

class _McqTabState extends State<_McqTab> {
  int _correct = 1;
  final _opts = ['', '', '', ''];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(maxLines: 4, decoration: const InputDecoration(labelText: 'Soru Metni *', hintText: 'Soruyu buraya yazın...', counterText: '0/500'), maxLength: 500),
        const SizedBox(height: 16),
        const Text('Seçenekler', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...List.generate(4, (i) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: _correct == i ? const Color(0xFF059669) : Colors.grey[200]), child: Center(child: Text(String.fromCharCode(65 + i), style: TextStyle(color: _correct == i ? Colors.white : const Color(0xFF475569), fontWeight: FontWeight.w600)))),
              const SizedBox(width: 12),
              Expanded(child: TextField(decoration: InputDecoration(hintText: 'Seçenek ${String.fromCharCode(65 + i)}...', filled: true, fillColor: _correct == i ? const Color(0xFFD1FAE5) : null))),
              Radio<int>(value: i, groupValue: _correct, onChanged: (v) => setState(() => _correct = v!)),
            ],
          ),
        )),
      ],
    );
  }
}

// True/False Tab
class _TfTab extends StatefulWidget {
  final int points;
  const _TfTab({required this.points});
  @override
  State<_TfTab> createState() => _TfTabState();
}

class _TfTabState extends State<_TfTab> {
  bool? _correct = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(maxLines: 4, decoration: const InputDecoration(labelText: 'Soru Metni *', hintText: 'Soruyu buraya yazın...'), maxLength: 500),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _correct = true),
                child: Container(height: 80, decoration: BoxDecoration(color: _correct == true ? const Color(0xFF059669) : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _correct == true ? const Color(0xFF059669) : const Color(0xFFE2E8F0))), child: const Center(child: Text('✓ Doğru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))))),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _correct = false),
                child: Container(height: 80, decoration: BoxDecoration(color: _correct == false ? const Color(0xFFDC2626) : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _correct == false ? const Color(0xFFDC2626) : const Color(0xFFE2E8F0))), child: const Center(child: Text('✗ Yanlış', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))))),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Short Answer Tab
class _SaTab extends StatelessWidget {
  final int points;
  const _SaTab({required this.points});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(maxLines: 4, decoration: const InputDecoration(labelText: 'Soru Metni *', hintText: 'Soruyu buraya yazın...'), maxLength: 500),
        const SizedBox(height: 20),
        const Text('Kabul Edilen Cevaplar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(decoration: const InputDecoration(labelText: 'Cevap 1 *', hintText: 'Doğru cevap')),
        const SizedBox(height: 8),
        TextField(decoration: const InputDecoration(labelText: 'Alternatif cevap (opsiyonel)', hintText: 'Alternatif yazım')),
        const SizedBox(height: 4),
        TextButton.icon(onPressed: () {}, icon: const Icon(Icons.add, size: 16), label: const Text('Alternatif ekle')),
        const SizedBox(height: 8),
        Row(children: [const Icon(Icons.info_outline, size: 16, color: Color(0xFF0284C7)), const SizedBox(width: 8), const Expanded(child: Text('Büyük/küçük harf fark etmez', style: TextStyle(fontSize: 13, color: Color(0xFF0284C7))))]),
      ],
    );
  }
}
