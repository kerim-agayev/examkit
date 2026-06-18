import 'package:flutter/material.dart';
import '../../shared/widgets/confirmation_dialog.dart';

/// Edge case yardımcıları.
class EdgeCaseHelpers {
  /// 0 öğrenci kontrolü
  static Future<bool> confirmZeroStudents(BuildContext context) async {
    return await ConfirmationDialog.show(context, title: 'Öğrenci Yok', message: 'Bekleme odasında hiç öğrenci yok. Sınavı başlatmak istediğinize emin misiniz?', confirmText: 'Yine de Başlat') ?? false;
  }

  /// Boş sınav hatası
  static void showEmptyExamError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('En az 1 soru eklemelisiniz'), backgroundColor: Color(0xFFDC2626)));
  }

  /// Timer expired handler
  static Future<void> handleTimerExpired(BuildContext context, VoidCallback onComplete) async {
    await ConfirmationDialog.show(context, title: 'Süre Doldu', message: 'Sınav süresi doldu. Cevaplarınız otomatik gönderilecek.', confirmText: 'Tamam');
    onComplete();
  }
}
