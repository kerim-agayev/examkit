import 'dart:math';

/// ExamKit sınav kodu üretici.
/// 6 karakter, karışıklık yaratan harfler hariç (I, O, Q, 0, 1).
/// Kalan set: A B C D E F G H J K L M N P Q R S T U V W X Y Z 2 3 4 5 6 7 8 9
class ExamCodeGenerator {
  static const _charset = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static final _random = Random.secure();

  /// Yeni 6 karakterli sınav kodu üret.
  static String generate() {
    return List.generate(6, (_) => _charset[_random.nextInt(_charset.length)]).join();
  }

  /// Kod formatını doğrula.
  static bool isValid(String code) {
    if (code.length != 6) return false;
    return RegExp(r'^[A-HJ-NP-Z2-9]{6}$').hasMatch(code.toUpperCase());
  }
}
