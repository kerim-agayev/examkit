import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/create_exam_provider.dart';
import '../../../l10n/app_localizations.dart';

class ExamSettingsScreen extends ConsumerWidget {
  const ExamSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createExamStateProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(state.title.isEmpty ? l10n.examSettings : state.title),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(32), child: Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _SC(1, false), _SL(), _SC(2, true), _SL(), _SC(3, false), _SL(), _SC(4, false), _SL(), _SC(5, false),
        ]))),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('2/5 ${l10n.examSettings}', style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF475569))),
          const SizedBox(height: 12),
          _SectionCard(title: l10n.examMode, children: [
            _RadioTile(l10n.examModeScroll, l10n.examModeScrollDesc, state.mode == 'scroll', () => ref.read(createExamStateProvider.notifier).state = state.copyWith(mode: 'scroll')),
            const Divider(),
            _RadioTile(l10n.examModeSequential, l10n.examModeSequentialDesc, state.mode == 'sequential', () => ref.read(createExamStateProvider.notifier).state = state.copyWith(mode: 'sequential')),
          ]),
          const SizedBox(height: 12),
          _SectionCard(title: l10n.examTiming, children: [
            SwitchListTile(title: Text(l10n.examGlobalTimer), value: state.globalTimer, onChanged: (v) => ref.read(createExamStateProvider.notifier).state = state.copyWith(globalTimer: v)),
            if (state.globalTimer) Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: [Slider(value: state.globalTimerMinutes.toDouble(), min: 1, max: 180, divisions: 179, label: '${state.globalTimerMinutes} dk', onChanged: (v) => ref.read(createExamStateProvider.notifier).state = state.copyWith(globalTimerMinutes: v.round())), Text('${state.globalTimerMinutes} dakika', style: const TextStyle(color: Color(0xFF475569)))]),),
            const Divider(),
            SwitchListTile(title: Text(l10n.examQuestionTimer), value: state.questionTimer, onChanged: (v) => ref.read(createExamStateProvider.notifier).state = state.copyWith(questionTimer: v)),
            if (state.questionTimer) Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: [Slider(value: state.questionTimerSeconds.toDouble(), min: 10, max: 300, divisions: 29, label: '${state.questionTimerSeconds} sn', onChanged: (v) => ref.read(createExamStateProvider.notifier).state = state.copyWith(questionTimerSeconds: v.round())), Text('${state.questionTimerSeconds} saniye', style: const TextStyle(color: Color(0xFF475569)))]),),
          ]),
          const SizedBox(height: 12),
          _SectionCard(title: l10n.examAntiCheat, children: [
            SwitchListTile(title: Text(l10n.examShuffleQuestions), value: state.shuffleQuestions, onChanged: (v) => ref.read(createExamStateProvider.notifier).state = state.copyWith(shuffleQuestions: v)),
            const Divider(),
            SwitchListTile(title: Text(l10n.examShuffleOptions), value: state.shuffleOptions, onChanged: (v) => ref.read(createExamStateProvider.notifier).state = state.copyWith(shuffleOptions: v)),
          ]),
          const SizedBox(height: 12),
          _SectionCard(title: l10n.examShowStudent, children: [
            SwitchListTile(title: Text(l10n.examShowScore), value: state.showScore, onChanged: (v) => ref.read(createExamStateProvider.notifier).state = state.copyWith(showScore: v)),
            const Divider(),
            SwitchListTile(title: Text(l10n.examShowCorrect), value: state.showCorrect, onChanged: (v) => ref.read(createExamStateProvider.notifier).state = state.copyWith(showCorrect: v)),
            const Divider(),
            SwitchListTile(title: Text(l10n.examShowLeaderboard), value: state.showLeaderboard, onChanged: (v) => ref.read(createExamStateProvider.notifier).state = state.copyWith(showLeaderboard: v)),
          ]),
        ],
      ),
      bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: SizedBox(width: double.infinity, height: 56, child: ElevatedButton(onPressed: () => context.push('/exams/create/questions'), child: Text(l10n.examContinue))))),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title; final List<Widget> children;
  const _SectionCard({required this.title, required this.children});
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF475569)))), ...children])));
}

class _RadioTile extends StatelessWidget {
  final String title, subtitle; final bool selected; final VoidCallback onTap;
  const _RadioTile(this.title, this.subtitle, this.selected, this.onTap);
  @override
  Widget build(BuildContext context) => ListTile(leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: selected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8)), title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)), onTap: onTap);
}

class _SC extends StatelessWidget { final int n; final bool a; const _SC(this.n, this.a); @override Widget build(BuildContext c) => Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: a ? const Color(0xFF2563EB) : Colors.transparent, border: Border.all(color: a ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0), width: 2)), child: Center(child: Text('$n', style: TextStyle(fontSize: 13, color: a ? Colors.white : const Color(0xFF94A3B8), fontWeight: FontWeight.w600)))); }
class _SL extends StatelessWidget { @override Widget build(BuildContext c) => Container(width: 16, height: 2, color: const Color(0xFFE2E8F0)); }
