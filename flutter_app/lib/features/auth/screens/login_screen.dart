import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.edit_document, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 12),
                Text('ExamKit', style: theme.textTheme.headlineLarge),
                const SizedBox(height: 48),
                Text('Hesabınıza giriş yapın', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Google hesabınızla devam edin', style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF475569))),
                const SizedBox(height: 32),
                // Google Sign-In
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Firebase Google Sign-In
                      context.go('/profile-setup');
                    },
                    icon: Image.asset('assets/google_g.png', width: 24, height: 24, errorBuilder: (_, __, ___) => const Icon(Icons.login)),
                    label: const Text('Google ile Giriş Yap', style: TextStyle(fontSize: 16)),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                Text('Hesap oluşturmaya gerek yok', style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF94A3B8))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
