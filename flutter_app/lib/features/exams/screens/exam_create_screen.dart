import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/create_exam_provider.dart';

class ExamCreateScreen extends ConsumerStatefulWidget {
  const ExamCreateScreen({super.key});

  @override
  ConsumerState<ExamCreateScreen> createState() => _ExamCreateScreenState();
}

class _ExamCreateScreenState extends ConsumerState<ExamCreateScreen> {
  final _titleCtrl = TextEditingController();
  String? _selectedGroup;

  bool get _canNext => _titleCtrl.text.trim().isNotEmpty && _selectedGroup != null;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createExamStateProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(state.title.isEmpty ? 'Yeni Sınav' : state.title),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(32), child: Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _StepCircle(1, true), _StepLine(), _StepCircle(2, false), _StepLine(), _StepCircle(3, false), _StepLine(), _StepCircle(4, false), _StepLine(), _StepCircle(5, false),
        ]))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('1/5 Temel Bilgiler', style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF475569))),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration(labelText: 'Sınav Başlığı *', hintText: 'örn: Riyaziyyat Fənn İmtahanı', counterText: '0/100'),
                      maxLength: 100,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        await showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                          builder: (_) => SizedBox(height: 300, child: ListView(
                            children: ['9-A Sinifi', '10-B Matematik', '11-A Fizik', '12-C Kimya'].map((g) => ListTile(
                              title: Text(g),
                              trailing: _selectedGroup == g ? const Icon(Icons.check, color: Color(0xFF2563EB)) : null,
                              onTap: () { setState(() => _selectedGroup = g); Navigator.pop(context); },
                            )).toList(),
                          )),
                        );
                      },
                      child: Container(
                        height: 64, padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                        child: Row(children: [
                          const Icon(Icons.group, color: Color(0xFF2563EB)), const SizedBox(width: 12),
                          Expanded(child: Text(_selectedGroup ?? 'Grup seçin', style: TextStyle(fontSize: 16, color: _selectedGroup != null ? const Color(0xFF0F172A) : const Color(0xFF94A3B8)))),
                          const Icon(Icons.chevron_right),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(alignment: Alignment.centerLeft, child: TextButton.icon(onPressed: () => context.push('/groups/create'), icon: const Icon(Icons.add, size: 16), label: const Text('Yeni Grup Oluştur'))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity, height: 56,
            child: ElevatedButton(
              onPressed: _canNext
                ? () {
                    ref.read(createExamStateProvider.notifier).state = state.copyWith(
                      title: _titleCtrl.text.trim(),
                      groupId: _selectedGroup,
                      groupName: _selectedGroup,
                    );
                    context.push('/exams/create/settings');
                  }
                : null,
              child: const Text('Devam Et →'),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int num; final bool active;
  const _StepCircle(this.num, this.active);
  @override
  Widget build(BuildContext context) => Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: active ? const Color(0xFF2563EB) : Colors.transparent, border: Border.all(color: active ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0), width: 2)), child: Center(child: Text('$num', style: TextStyle(fontSize: 13, color: active ? Colors.white : const Color(0xFF94A3B8), fontWeight: FontWeight.w600))));
}

class _StepLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 16, height: 2, color: const Color(0xFFE2E8F0));
}
