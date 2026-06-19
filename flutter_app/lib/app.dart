import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'router.dart';
import 'core/theme/theme.dart';
import 'l10n/app_localizations.dart';

/// Uygulama dil provider'ı — settings_screen ve app.dart tarafından kullanılır
final appLanguageProvider = StateProvider<String>((ref) => 'az');

class ExamKitApp extends ConsumerWidget {
  const ExamKitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final lang = ref.watch(appLanguageProvider);
    return MaterialApp.router(
      title: 'ExamKit',
      theme: examKitTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('az'), Locale('tr')],
      locale: Locale(lang),
    );
  }
}
