import 'package:flutter/material.dart';

/// Boş durum gösterimi — icon + başlık + mesaj + opsiyonel buton.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  const EmptyState({super.key, required this.icon, required this.title, this.subtitle, this.buttonLabel, this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 56, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)), textAlign: TextAlign.center),
          if (subtitle != null) ...[const SizedBox(height: 8), Text(subtitle!, style: const TextStyle(fontSize: 14, color: Color(0xFF475569)), textAlign: TextAlign.center)],
          if (buttonLabel != null) ...[const SizedBox(height: 20), ElevatedButton(onPressed: onButtonPressed, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(buttonLabel!))],
        ]),
      ),
    );
  }
}
