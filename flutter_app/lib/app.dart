import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';
import 'core/theme/theme.dart';

class ExamKitApp extends ConsumerWidget {
  const ExamKitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'ExamKit',
      theme: examKitTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
