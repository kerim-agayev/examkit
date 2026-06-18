import 'package:flutter/material.dart';

/// Standart ExamKit input alanı.
/// 56dp yükseklik, 16sp font, float label, char counter, error state.

class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final int? maxLength;
  final int? maxLines;
  final bool obscure;
  final String? errorText;
  final Widget? prefixIcon;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final TextInputType? keyboardType;

  const AppTextField({super.key, this.label, this.hint, this.controller, this.maxLength, this.maxLines = 1, this.obscure = false, this.errorText, this.prefixIcon, this.onChanged, this.autofocus = false, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      obscureText: obscure,
      autofocus: autofocus,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        errorText: errorText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        counterText: maxLength != null ? '0/$maxLength' : null,
      ),
    );
  }
}
