/// Validasyon yardımcıları.
class Validators {
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'Bu alan zorunlu';
    if (value.trim().length < 2) return 'En az 2 karakter';
    return null;
  }

  static String? examTitle(String? value) {
    if (value == null || value.trim().isEmpty) return 'Sınav başlığı zorunlu';
    if (value.trim().length > 100) return 'En fazla 100 karakter';
    return null;
  }

  static String? examCode(String? value) {
    if (value == null || value.isEmpty) return 'Kod gerekli';
    if (value.length != 6) return '6 karakter olmalı';
    if (!RegExp(r'^[A-HJ-NP-Z2-9]{6}$').hasMatch(value.toUpperCase())) return 'Geçersiz karakter';
    return null;
  }

  static String? groupName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Grup adı zorunlu';
    if (value.trim().length > 60) return 'En fazla 60 karakter';
    return null;
  }
}
