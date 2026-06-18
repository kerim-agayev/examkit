import 'package:flutter/material.dart';

/// Onay dialog'u — silme, sınav tamamlama gibi kritik işlemler için.
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final bool isDanger;

  const ConfirmationDialog({super.key, required this.title, required this.message, this.confirmText = 'Evet', this.cancelText = 'İptal', required this.onConfirm, required this.onCancel, this.isDanger = false});

  static Future<bool?> show(BuildContext context, {required String title, required String message, String confirmText = 'Evet', String cancelText = 'İptal', bool isDanger = false}) {
    return showDialog<bool>(context: context, builder: (_) => ConfirmationDialog(title: title, message: message, confirmText: confirmText, cancelText: cancelText, onConfirm: () => Navigator.pop(context, true), onCancel: () => Navigator.pop(context, false), isDanger: isDanger));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      content: Text(message, style: const TextStyle(fontSize: 14, color: Color(0xFF475569))),
      actions: [
        TextButton(onPressed: onCancel, child: Text(cancelText)),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(backgroundColor: isDanger ? const Color(0xFFDC2626) : const Color(0xFF2563EB), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
