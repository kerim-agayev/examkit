import 'package:flutter/material.dart';

class ExamSettingsScreen extends StatefulWidget {
  const ExamSettingsScreen({super.key});

  @override
  State<ExamSettingsScreen> createState() => _ExamSettingsScreenState();
}

class _ExamSettingsScreenState extends State<ExamSettingsScreen> {
  bool _scrollMode = true;
  bool _globalTimer = true;
  double _globalMinutes = 45;
  bool _questionTimer = false;
  bool _shuffleQuestions = false;
  bool _shuffleOptions = false;
  bool _showScore = true;
  bool _showCorrect = true;
  bool _showLeaderboard = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sınav Ayarları'),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(32), child: Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [_StepCircle(1, false), _StepLine(), _StepCircle(2, true), _StepLine(), _StepCircle(3, false), _StepLine(), _StepCircle(4, false)])),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('2/5 Sınav Ayarları', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF475569))),
          const SizedBox(height: 12),
          // Mode
          _SectionCard(title: 'Sınav Modu', children: [
            _RadioTile('Kaydırma Modu', 'Tüm sorular görünür, serbestçe gezilebilir', _scrollMode, () => setState(() => _scrollMode = true)),
            const Divider(),
            _RadioTile('Sıralı Mod', 'Soru soru, geri dönülemez', !_scrollMode, () => setState(() => _scrollMode = false)),
          ]),
          const SizedBox(height: 12),
          // Timing
          _SectionCard(title: 'Zamanlama', children: [
            SwitchListTile(title: const Text('Genel Süre Sınırı'), value: _globalTimer, onChanged: (v) => setState(() => _globalTimer = v)),
            if (_globalTimer) ...[
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: [Slider(value: _globalMinutes, min: 1, max: 180, divisions: 179, label: '${_globalMinutes.round()} dk', onChanged: (v) => setState(() => _globalMinutes = v)), Text('${_globalMinutes.round()} dakika', style: const TextStyle(color: Color(0xFF475569)))]),),
            ],
            const Divider(),
            SwitchListTile(title: const Text('Soru Başına Süre'), value: _questionTimer, onChanged: (v) => setState(() => _questionTimer = v)),
          ]),
          const SizedBox(height: 12),
          // Anti-Cheat
          _SectionCard(title: 'Anti-Hile', children: [
            SwitchListTile(title: const Text('Soru Sırasını Karıştır'), value: _shuffleQuestions, onChanged: (v) => setState(() => _shuffleQuestions = v)),
            const Divider(),
            SwitchListTile(title: const Text('Şık Sırasını Karıştır'), value: _shuffleOptions, onChanged: (v) => setState(() => _shuffleOptions = v)),
          ]),
          const SizedBox(height: 12),
          // To Student
          _SectionCard(title: 'Öğrenciye Göster', children: [
            SwitchListTile(title: const Text('Puanını göster'), value: _showScore, onChanged: (v) => setState(() => _showScore = v)),
            const Divider(),
            SwitchListTile(title: const Text('Doğru cevapları göster'), value: _showCorrect, onChanged: (v) => setState(() => _showCorrect = v)),
            const Divider(),
            SwitchListTile(title: const Text('Sıralamayı göster'), value: _showLeaderboard, onChanged: (v) => setState(() => _showLeaderboard = v)),
          ]),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(width: double.infinity, height: 56, child: ElevatedButton(onPressed: () {}, child: const Text('Devam Et →'))),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF475569)))), ...children]),
      ),
    );
  }
}

class _RadioTile extends StatelessWidget {
  final String title, subtitle;
  final bool selected;
  final VoidCallback onTap;
  const _RadioTile(this.title, this.subtitle, this.selected, this.onTap);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: selected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8)),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)),
      onTap: onTap,
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int num;
  final bool active;
  const _StepCircle(this.num, this.active);
  @override
  Widget build(BuildContext context) => Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: active ? const Color(0xFF2563EB) : Colors.transparent, border: Border.all(color: active ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0), width: 2)), child: Center(child: Text('$num', style: TextStyle(fontSize: 13, color: active ? Colors.white : const Color(0xFF94A3B8), fontWeight: FontWeight.w600))));
}

class _StepLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 20, height: 2, color: const Color(0xFFE2E8F0));
}
