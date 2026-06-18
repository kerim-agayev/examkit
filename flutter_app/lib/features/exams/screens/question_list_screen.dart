import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuestionListScreen extends StatefulWidget {
  const QuestionListScreen({super.key});

  @override
  State<QuestionListScreen> createState() => _QuestionListScreenState();
}

class _QuestionListScreenState extends State<QuestionListScreen> {
  final _questions = [
    _QData('ÇSM', 'Mitoz bölünmenin əsas mərhələ...', 3, const Color(0xFF2563EB)),
    _QData('D/Y', 'DNA replikasiyası S fazasında...', 1, const Color(0xFF059669)),
    _QData('KA', 'Fotosintezin əsas məhsulu...', 2, const Color(0xFF7C3AED)),
    _QData('ÇSM', 'Hücre zarı modeli hansıdır?', 3, const Color(0xFF2563EB)),
    _QData('D/Y', 'Ribozomlar zülal sintezindən...', 1, const Color(0xFF059669)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sorular'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(
              avatar: const Icon(Icons.stars, size: 16),
              label: Text('Toplam: ${_questions.fold<int>(0, (s, q) => s + q.points)} puan', style: const TextStyle(fontSize: 12)),
              backgroundColor: const Color(0xFFDBEAFE),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(32),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _StepCircle(1, false), _StepLine(), _StepCircle(2, false), _StepLine(), _StepCircle(3, true), _StepLine(), _StepCircle(4, false),
            ]),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('3/5 Sorular', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF475569))),
          ),
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _questions.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = _questions.removeAt(oldIndex);
                  _questions.insert(newIndex, item);
                });
              },
              itemBuilder: (_, i) => Card(
                key: ValueKey('q$i'),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.drag_handle, color: Color(0xFF94A3B8)),
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: _questions[i].color.withAlpha(25), borderRadius: BorderRadius.circular(8)),
                        child: Text(_questions[i].type, style: TextStyle(fontSize: 11, color: _questions[i].color, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_questions[i].text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  subtitle: Text('${_questions[i].points} puan', style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit, size: 18), onPressed: () => context.push('/exams/create/questions/edit')),
                      IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFDC2626)), onPressed: () {}),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity, height: 56,
                  child: OutlinedButton(
                    onPressed: () => context.push('/exams/create/questions/edit'),
                    style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFF2563EB)))),
                    child: const Text('+ Soru Ekle'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  width: double.infinity, height: 56,
                  child: ElevatedButton(onPressed: () => context.push('/exams/create/preview'), child: const Text('Devam Et →')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QData {
  final String type, text;
  final int points;
  final Color color;
  const _QData(this.type, this.text, this.points, this.color);
}

class _StepCircle extends StatelessWidget {
  final int num;
  final bool active;
  const _StepCircle(this.num, this.active);
  @override
  Widget build(BuildContext context) => Container(
    width: 28, height: 28,
    decoration: BoxDecoration(shape: BoxShape.circle, color: active ? const Color(0xFF2563EB) : Colors.transparent, border: Border.all(color: active ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0), width: 2)),
    child: Center(child: Text('$num', style: TextStyle(fontSize: 13, color: active ? Colors.white : const Color(0xFF94A3B8), fontWeight: FontWeight.w600))),
  );
}

class _StepLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 20, height: 2, color: const Color(0xFFE2E8F0));
}
