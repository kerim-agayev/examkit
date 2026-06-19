# Flutter Mobil Uygulama (Öğretmen)

## Teknoloji
- Flutter 3.41 / Dart 3.11
- Firebase Auth (Google Sign-In)
- Firebase RTDB (Realtime Database)
- Riverpod (state management)
- go_router (navigation)
- Material Design 3 + Google Fonts Inter

## Dosya Yapısı

```
flutter_app/lib/
├── main.dart                    # Firebase init
├── app.dart                     # MaterialApp.router
├── router.dart                  # GoRouter (23 routes)
├── core/
│   ├── firebase/
│   │   └── firebase_providers.dart  # rtdbProvider, firebaseAuthProvider
│   ├── theme/theme.dart
│   └── constants/app_constants.dart
├── features/
│   ├── auth/
│   │   ├── providers/auth_provider.dart    # authStateProvider, Google Sign-In
│   │   └── screens/ (splash, onboarding, login, profile_setup)
│   ├── home/
│   │   └── screens/home_screen.dart        # Ana sayfa (gruplar, sınavlar, bottom nav)
│   ├── groups/
│   │   ├── providers/group_provider.dart   # watchGroups, createGroup (RTDB)
│   │   └── screens/ (list, create, detail)
│   ├── exams/
│   │   ├── providers/
│   │   │   ├── exam_provider.dart          # watchExams, createExam (RTDB)
│   │   │   ├── question_provider.dart      # watchQuestions, createQuestion (RTDB)
│   │   │   ├── create_exam_provider.dart   # StateProvider<CreateExamState>
│   │   │   └── live_exam_provider.dart     # watchLiveExam, startExam, endExam (RTDB)
│   │   └── screens/ (list, create, settings, question_list, question_editor,
│   │                  preview, share, live_control)
│   └── results/
│       ├── services/score_calculator.dart  # ScoreCalculator (RTDB)
│       └── screens/ (results, student_detail, settings)
```

## Provider'lar (RTDB Stream)

| Provider | Kaynak | Amaç |
|---|---|---|
| `rtdbProvider` | `FirebaseDatabase.instance` | Tüm RTDB erişimi |
| `authStateProvider` | `FirebaseAuth.instance.authStateChanges()` | Auth durumu |
| `watchGroupsProvider` | `groups_by_teacher/{uid}` | Grup listesi |
| `watchExamsProvider` | `exams_by_teacher/{uid}` | Sınav listesi |
| `watchQuestionsProvider` | `questions/{examId}` | Soru listesi |
| `watchLiveExamProvider` | `live_exams/{examId}` | Canlı sınav durumu |
| `createExamStateProvider` | StateProvider | 5 adımlı sınav oluşturma state'i |

## RTDB Pattern'i

```dart
// Stream: Broadcast StreamController pattern
final watchGroupsProvider = StreamProvider<List<GroupModel>>((ref) {
  final rtdb = ref.watch(rtdbProvider);
  final controller = StreamController<List<GroupModel>>.broadcast();
  final sub = rtdb.ref('groups_by_teacher/${uid}').onValue.listen((e) {
    // veriyi işle, controller.add()
  });
  ref.onDispose(() { sub.cancel(); controller.close(); });
  return controller.stream;
});

// Write: Multi-path update
await rtdb.ref('/').update({
  'exams/$eKey': {...data},
  'exams_by_teacher/$uid/$eKey': now,
  'groups/$groupId/examCount': ServerValue.increment(1),
});
```
