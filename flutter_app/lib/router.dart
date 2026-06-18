import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/onboarding_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/profile_setup_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/groups/screens/group_list_screen.dart';
import 'features/groups/screens/group_create_screen.dart';
import 'features/groups/screens/group_detail_screen.dart';
import 'features/exams/screens/exam_list_screen.dart';
import 'features/exams/screens/exam_create_screen.dart';
import 'features/exams/screens/exam_settings_screen.dart';
import 'features/exams/screens/share_screen.dart';
import 'features/exams/screens/live_control_screen.dart';
import 'features/results/screens/results_screen.dart';
import 'features/results/screens/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      // Auth
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/profile-setup', builder: (_, __) => const ProfileSetupScreen()),

      // Home
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),

      // Groups
      GoRoute(path: '/groups', builder: (_, __) => const GroupListScreen()),
      GoRoute(path: '/groups/create', builder: (_, __) => const GroupCreateScreen()),
      GoRoute(path: '/groups/:id', builder: (_, s) => GroupCreateScreen(groupId: s.pathParameters['id'])),
      GoRoute(path: '/groups/:id/edit', builder: (_, s) => GroupCreateScreen(groupId: s.pathParameters['id'])),

      // Exams
      GoRoute(path: '/exams', builder: (_, __) => const ExamListScreen()),
      GoRoute(path: '/exams/create', builder: (_, __) => const ExamCreateScreen()),
      GoRoute(path: '/exams/create/settings', builder: (_, __) => const ExamSettingsScreen()),
      GoRoute(path: '/exams/:id/share', builder: (_, __) => const ShareScreen()),
      GoRoute(path: '/exams/:id/live', builder: (_, __) => const LiveControlScreen()),
      GoRoute(path: '/exams/:id/results', builder: (_, __) => const ResultsScreen()),

      // Settings
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    ],
  );
});
