# Flutter Uygulama Mimarisi

**Framework:** Flutter 3.44.0  
**State:** Riverpod 3.0  
**Navigation:** go_router 14  
**Mimari:** Feature-first klasör yapısı

---

## Mimari Katmanlar

```
Ekran (Screen)
    ↓ izler
Provider (Riverpod)
    ↓ çağırır
Repository
    ↓ kullanır
Service (Firestore / RTDB / Auth)
    ↓
Firebase
```

---

## Feature Klasör Yapısı (Standart)

Her feature aynı yapıyı takip eder:

```
features/{feature_name}/
├── data/
│   └── {feature}_repository.dart    # Firebase işlemleri
├── models/
│   └── {feature}_model.dart         # Veri modeli + fromFirestore/toMap
├── providers/
│   └── {feature}_provider.dart      # Riverpod providers
└── screens/
    └── {feature}_screen.dart        # UI
```

---

## Provider Tipleri (Riverpod 3.0)

```dart
// Stream provider — Firestore/RTDB real-time dinleme
@riverpod
Stream<List<GroupModel>> groupList(GroupListRef ref) {
  return ref.watch(groupRepositoryProvider).watchGroups(
    ref.watch(authProvider).value!.uid
  );
}

// Future provider — tek seferlik veri çekme
@riverpod
Future<ExamModel> examDetail(ExamDetailRef ref, String examId) {
  return ref.watch(examRepositoryProvider).getExam(examId);
}

// Notifier — karmaşık state yönetimi
@riverpod
class ExamCreation extends _$ExamCreation {
  @override
  ExamCreationState build() => ExamCreationState.initial();

  void setTitle(String title) => state = state.copyWith(title: title);
  void setMode(ExamMode mode) => state = state.copyWith(mode: mode);
  Future<void> publish() async { ... }
}
```

---

## go_router Yapısı

```dart
// router.dart
final router = GoRouter(
  redirect: (context, state) {
    final isLoggedIn = ref.read(authProvider).value != null;
    if (!isLoggedIn) return '/login';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    ShellRoute(
      builder: (_, __, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/groups', builder: (_, __) => const GroupListScreen()),
        GoRoute(path: '/groups/new', builder: (_, __) => const GroupCreateScreen()),
        GoRoute(path: '/groups/:id', builder: (_, state) =>
          GroupDetailScreen(groupId: state.pathParameters['id']!)),
        GoRoute(path: '/exams', builder: (_, __) => const ExamListScreen()),
        GoRoute(path: '/exams/new', builder: (_, __) => const ExamCreateScreen()),
        GoRoute(path: '/exams/:id/settings', builder: (_, state) =>
          ExamSettingsScreen(examId: state.pathParameters['id']!)),
        GoRoute(path: '/exams/:id/questions', builder: (_, state) =>
          QuestionListScreen(examId: state.pathParameters['id']!)),
        GoRoute(path: '/exams/:id/preview', builder: (_, state) =>
          ExamPreviewScreen(examId: state.pathParameters['id']!)),
        GoRoute(path: '/exams/:id/share', builder: (_, state) =>
          ExamShareScreen(examId: state.pathParameters['id']!)),
        GoRoute(path: '/exams/:id/live', builder: (_, state) =>
          LiveExamScreen(examId: state.pathParameters['id']!)),
        GoRoute(path: '/exams/:id/results', builder: (_, state) =>
          ExamResultsScreen(examId: state.pathParameters['id']!)),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      ],
    ),
  ],
);
```

---

## Model Standardı

```dart
// Tüm modeller bu yapıyı takip eder
class ExamModel {
  final String id;
  final String title;
  // ... diğer alanlar

  const ExamModel({required this.id, required this.title, ...});

  // Firestore'dan okuma
  factory ExamModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExamModel(
      id: doc.id,
      title: data['title'] as String,
      // ...
    );
  }

  // Firestore'a yazma
  Map<String, dynamic> toMap() => {
    'title': title,
    // ... (id yazılmaz — document ID olarak saklanır)
  };

  // Değişiklik için
  ExamModel copyWith({String? title, ...}) =>
    ExamModel(id: id, title: title ?? this.title, ...);
}
```

---

## Lokalizasyon

```dart
// main.dart
MaterialApp.router(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: const [Locale('az'), Locale('tr')],
  locale: ref.watch(appLocaleProvider),
);

// Kullanım
context.l10n.createGroup        // "Qrup yarat" veya "Grup oluştur"
context.l10n.examCode(code)     // Parametreli string
```
