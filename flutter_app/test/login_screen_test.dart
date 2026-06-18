import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:examkit/features/auth/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('LoginScreen renders Google Sign-In button', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: LoginScreen()),
      ),
    );

    expect(find.text('Hesabınıza giriş yapın'), findsOneWidget);
    expect(find.text('Google ile Giriş Yap'), findsOneWidget);
    expect(find.text('Hesap oluşturmaya gerek yok'), findsOneWidget);
  });
}
