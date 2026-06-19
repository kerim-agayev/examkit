import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import '../providers/create_exam_provider.dart';
import '../../../../core/firebase/firebase_providers.dart';

class QuestionEditorScreen extends ConsumerStatefulWidget {
  const QuestionEditorScreen({super.key});
  @override
  ConsumerState<QuestionEditorScreen> createState() => _QuestionEditorScreenState();
}

class _QuestionEditorScreenState extends ConsumerState<QuestionEditorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  int _points = 3;
  bool _saving = false;

  final _mcqTextCtrl = TextEditingController();
  final _mcqOptCtrls = [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController()];
  int _mcqCorrect = 0;
  final _tfTextCtrl = TextEditingController();
  bool _tfCorrect = true;
  final _saTextCtrl = TextEditingController(), _saAnswerCtrl = TextEditingController(), _saAltCtrl = TextEditingController();

  @override void initState() { super.initState(); _tabCtrl = TabController(length: 3, vsync: this); }
  @override void dispose() { _tabCtrl.dispose(); _mcqTextCtrl.dispose(); _tfTextCtrl.dispose(); _saTextCtrl.dispose(); _saAnswerCtrl.dispose(); _saAltCtrl.dispose(); for (final c in _mcqOptCtrls) c.dispose(); super.dispose(); }

  Future<void> _save() async {
    final state = ref.read(createExamStateProvider);
    if (state.examId.isEmpty) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Önce sınavı oluşturun!'), backgroundColor: Color(0xFFDC2626)));
      return;
    }

    // Validasyon
    final types = ['mcq', 'true_false', 'short_answer'];
    final type = types[_tabCtrl.index];
    String? error;
    switch (type) {
      case 'mcq':
        if (_mcqTextCtrl.text.trim().isEmpty) error = 'Soru metni boş olamaz';
        else if (_mcqOptCtrls.any((c) => c.text.trim().isEmpty)) error = 'Tüm seçenekler (A, B, C, D) doldurulmalı';
        break;
      case 'true_false':
        if (_tfTextCtrl.text.trim().isEmpty) error = 'Soru metni boş olamaz';
        break;
      case 'short_answer':
        if (_saTextCtrl.text.trim().isEmpty) error = 'Soru metni boş olamaz';
        else if (_saAnswerCtrl.text.trim().isEmpty) error = 'En az bir doğru cevap girilmeli';
        break;
    }
    if (error != null) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: const Color(0xFFDC2626)));
      return;
    }

    final rtdb = ref.read(rtdbProvider);
    String text;
    switch (type) {
      case 'mcq': text = _mcqTextCtrl.text.trim(); break;
      case 'true_false': text = _tfTextCtrl.text.trim(); break;
      default: text = _saTextCtrl.text.trim();
    }

    setState(() => _saving = true);
    try {
      final qKey = rtdb.ref('questions/${state.examId}').push().key!;
      final q = <String, dynamic>{
        'text': text, 'type': type, 'points': _points, 'orderIndex': 0,
        if (type == 'mcq') 'options': _mcqOptCtrls.map((c) => c.text).toList(),
      };
      final a = <String, dynamic>{'type': type};
      if (type == 'mcq') { a['correctOptionId'] = String.fromCharCode(65 + _mcqCorrect); }
      else if (type == 'true_false') { a['correctBool'] = _tfCorrect; }
      else {
        final answers = <String>[];
        if (_saAnswerCtrl.text.trim().isNotEmpty) answers.add(_saAnswerCtrl.text.trim());
        if (_saAltCtrl.text.trim().isNotEmpty) answers.add(_saAltCtrl.text.trim());
        a['acceptedAnswers'] = answers.isEmpty ? ['cevap'] : answers;
      }

      await rtdb.ref('/').update({
        'questions/${state.examId}/$qKey': q,
        'exam_answers/${state.examId}/$qKey': a,
        'exams/${state.examId}/questionCount': ServerValue.increment(1),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Soru kaydedildi ✓'), backgroundColor: Color(0xFF059669)));
        // Tüm alanları sıfırla
        _mcqTextCtrl.clear(); for (final c in _mcqOptCtrls) c.clear(); _mcqCorrect = 0;
        _tfTextCtrl.clear(); _tfCorrect = true;
        _saTextCtrl.clear(); _saAnswerCtrl.clear(); _saAltCtrl.clear();
        _points = 3;
        setState(() {});
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e'), backgroundColor: const Color(0xFFDC2626)));
    } finally {
      _saving = false; if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Soru Editörü'), actions: [TextButton(onPressed: _saving ? null : _save, child: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Kaydet'))], bottom: TabBar(controller: _tabCtrl, tabs: const [Tab(text: 'ÇSM'), Tab(text: 'D/Y'), Tab(text: 'KA')])),
      body: Column(children: [
        Expanded(child: TabBarView(controller: _tabCtrl, children: [
          ListView(padding: const EdgeInsets.all(16), children: [
            TextField(controller: _mcqTextCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Soru Metni *', hintText: 'Soruyu buraya yazın...', counterText: '0/500'), maxLength: 500),
            const SizedBox(height: 16), const Text('Seçenekler', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), const SizedBox(height: 8),
            ...List.generate(4, (i) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
              GestureDetector(onTap: () => setState(() => _mcqCorrect = i), child: Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: _mcqCorrect == i ? const Color(0xFF059669) : Colors.grey[200]), child: Center(child: Text(String.fromCharCode(65 + i), style: TextStyle(color: _mcqCorrect == i ? Colors.white : const Color(0xFF475569), fontWeight: FontWeight.w600))))),
              const SizedBox(width: 12), Expanded(child: TextField(controller: _mcqOptCtrls[i], decoration: InputDecoration(hintText: 'Seçenek ${String.fromCharCode(65 + i)}...', filled: true, fillColor: _mcqCorrect == i ? const Color(0xFFD1FAE5) : null))),
            ]))),
          ]),
          ListView(padding: const EdgeInsets.all(16), children: [
            TextField(controller: _tfTextCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Soru Metni *', hintText: 'Soruyu buraya yazın...'), maxLength: 500),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: GestureDetector(onTap: () => setState(() => _tfCorrect = true), child: Container(height: 80, decoration: BoxDecoration(color: _tfCorrect ? const Color(0xFF059669) : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _tfCorrect ? const Color(0xFF059669) : const Color(0xFFE2E8F0))), child: const Center(child: Text('✓ Doğru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)))))),
              const SizedBox(width: 12),
              Expanded(child: GestureDetector(onTap: () => setState(() => _tfCorrect = false), child: Container(height: 80, decoration: BoxDecoration(color: !_tfCorrect ? const Color(0xFFDC2626) : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: !_tfCorrect ? const Color(0xFFDC2626) : const Color(0xFFE2E8F0))), child: const Center(child: Text('✗ Yanlış', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)))))),
            ]),
          ]),
          ListView(padding: const EdgeInsets.all(16), children: [
            TextField(controller: _saTextCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Soru Metni *', hintText: 'Soruyu buraya yazın...'), maxLength: 500),
            const SizedBox(height: 20), const Text('Kabul Edilen Cevaplar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), const SizedBox(height: 8),
            TextField(controller: _saAnswerCtrl, decoration: const InputDecoration(labelText: 'Cevap 1 *', hintText: 'Doğru cevap')),
            const SizedBox(height: 8),
            TextField(controller: _saAltCtrl, decoration: const InputDecoration(labelText: 'Alternatif cevap (opsiyonel)', hintText: 'Alternatif yazım')),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.info_outline, size: 16, color: Color(0xFF0284C7)), const SizedBox(width: 8), const Expanded(child: Text('Büyük/küçük harf fark etmez', style: TextStyle(fontSize: 13, color: Color(0xFF0284C7))))]),
          ]),
        ])),
        Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), child: Row(children: [
          const Text('Puan:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: _points > 1 ? () => setState(() => _points--) : null),
          Text('$_points', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary)),
          IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => setState(() => _points++)),
        ])),
      ]),
    );
  }
}
