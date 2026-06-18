import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authAsync = ref.watch(signInWithGoogleProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.edit_document, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 12),
                Text('ExamKit', style: theme.textTheme.headlineLarge),
                const SizedBox(height: 48),
                Text('Hesabınıza giriş yapın', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Google hesabınızla devam edin', style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF475569))),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity, height: 56,
                  child: OutlinedButton.icon(
                    onPressed: authAsync.isLoading ? null : () async {
                      ref.invalidate(signInWithGoogleProvider);
                      try {
                        await ref.read(signInWithGoogleProvider.future);
                        if (context.mounted) context.go('/profile-setup');
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Giriş yapılamadı')));
                        }
                      }
                    },
                    icon: authAsync.isLoading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.login),
                    label: const Text('Google ile Giriş Yap', style: TextStyle(fontSize: 16)),
                    style: OutlinedButton.styleFrom(backgroundColor: Colors.white, side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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
