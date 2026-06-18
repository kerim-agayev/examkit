import 'package:flutter/material.dart';

/// Standart ExamKit butonları.
/// Tüm butonlar min 56dp yükseklik, 48dp touch target.

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool loading;
  final double? width;

  const AppButton({super.key, required this.label, this.onPressed, this.variant = AppButtonVariant.primary, this.icon, this.loading = false, this.width});

  const AppButton.primary({Key? key, required String label, VoidCallback? onPressed, IconData? icon, bool loading = false}) : this(key: key, label: label, onPressed: onPressed, variant: AppButtonVariant.primary, icon: icon, loading: loading);
  const AppButton.secondary({Key? key, required String label, VoidCallback? onPressed, IconData? icon}) : this(key: key, label: label, onPressed: onPressed, variant: AppButtonVariant.secondary, icon: icon);
  const AppButton.danger({Key? key, required String label, VoidCallback? onPressed}) : this(key: key, label: label, onPressed: onPressed, variant: AppButtonVariant.danger);

  @override
  Widget build(BuildContext context) {
    final style = _style();
    Widget child = loading
        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
        : icon != null
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 20), const SizedBox(width: 8), Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))])
            : Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600));

    return SizedBox(
      width: width ?? double.infinity,
      height: 56,
      child: variant == AppButtonVariant.text
          ? TextButton(onPressed: loading ? null : onPressed, child: child)
          : ElevatedButton(
              onPressed: loading ? null : onPressed,
              style: style,
              child: child,
            ),
    );
  }

  ButtonStyle _style() {
    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)));
      case AppButtonVariant.secondary:
        return ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF2563EB), side: const BorderSide(color: Color(0xFF2563EB)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)));
      case AppButtonVariant.danger:
        return ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)));
      case AppButtonVariant.text:
        return ElevatedButton.styleFrom();
    }
  }
}

enum AppButtonVariant { primary, secondary, danger, text }
