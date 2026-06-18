import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'router.dart';
import 'core/theme/theme.dart';
// l10n: flutter gen-l10n çalıştırıldıktan sonra aktif olur
// import 'package:examkit/l10n/app_localizations.dart';

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
      localizationsDelegates: const [
        // AppLocalizations.delegate, // flutter gen-l10n sonrası aktif
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('az'), Locale('tr')],
      locale: const Locale('az'),
    );
  }
}
