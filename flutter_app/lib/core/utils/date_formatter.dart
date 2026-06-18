import 'package:intl/intl.dart';

/// Tarih formatlama yardımcıları (TR/AZ).
class DateFormatter {
  static String relative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Şimdi';
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk önce';
    if (diff.inHours < 24) return '${diff.inHours} saat önce';
    if (diff.inDays < 7) return '${diff.inDays} gün önce';
    return DateFormat('dd MMM yyyy', 'tr').format(date);
  }

  static String short(DateTime date) {
    return DateFormat('dd.MM.yyyy', 'tr').format(date);
  }

  static String duration(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
