import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sınav oluşturma akışında tüm adımlar arası paylaşılan state.
class CreateExamState {
  final String examId; // Firestore'da oluşturulduktan sonra doldurulur
  final String title;
  final String? groupId;
  final String? groupName;
  final String mode;
  final bool globalTimer;
  final int globalTimerMinutes;
  final bool questionTimer;
  final int questionTimerSeconds;
  final bool shuffleQuestions;
  final bool shuffleOptions;
  final bool showScore;
  final bool showCorrect;
  final bool showLeaderboard;

  const CreateExamState({
    this.examId = '',
    this.title = '',
    this.groupId,
    this.groupName,
    this.mode = 'scroll',
    this.globalTimer = true,
    this.globalTimerMinutes = 45,
    this.questionTimer = false,
    this.questionTimerSeconds = 60,
    this.shuffleQuestions = false,
    this.shuffleOptions = false,
    this.showScore = true,
    this.showCorrect = true,
    this.showLeaderboard = true,
  });

  CreateExamState copyWith({
    String? examId,
    String? title,
    String? groupId,
    String? groupName,
    String? mode,
    bool? globalTimer,
    int? globalTimerMinutes,
    bool? questionTimer,
    int? questionTimerSeconds,
    bool? shuffleQuestions,
    bool? shuffleOptions,
    bool? showScore,
    bool? showCorrect,
    bool? showLeaderboard,
  }) {
    return CreateExamState(
      examId: examId ?? this.examId,
      title: title ?? this.title,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      mode: mode ?? this.mode,
      globalTimer: globalTimer ?? this.globalTimer,
      globalTimerMinutes: globalTimerMinutes ?? this.globalTimerMinutes,
      questionTimer: questionTimer ?? this.questionTimer,
      questionTimerSeconds: questionTimerSeconds ?? this.questionTimerSeconds,
      shuffleQuestions: shuffleQuestions ?? this.shuffleQuestions,
      shuffleOptions: shuffleOptions ?? this.shuffleOptions,
      showScore: showScore ?? this.showScore,
      showCorrect: showCorrect ?? this.showCorrect,
      showLeaderboard: showLeaderboard ?? this.showLeaderboard,
    );
  }
}

final createExamStateProvider = StateProvider<CreateExamState>((ref) {
  return const CreateExamState();
});
