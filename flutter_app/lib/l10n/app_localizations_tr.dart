// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'ExamKit';

  @override
  String get splashLoading => 'Hazırlanıyor...';

  @override
  String get onboardingSkip => 'Atla';

  @override
  String get onboardingNext => 'Devam Et';

  @override
  String get onboardingStart => 'Başla';

  @override
  String get onboardingTitle1 => 'Sınav Oluştur, Paylaş';

  @override
  String get onboardingSub1 =>
      'Dakikalar içinde sınav hazırla, öğrencilerinle paylaş.';

  @override
  String get onboardingTitle2 => 'WhatsApp ile Tek Tuşta Paylaş';

  @override
  String get onboardingSub2 =>
      'Oluşturduğun sınavı tek dokunuşla WhatsApp grubuna gönder.';

  @override
  String get onboardingTitle3 => 'Anlık Sonuçları Gör';

  @override
  String get onboardingSub3 => 'Öğrenciler tamamladıkça sonuçları canlı izle.';

  @override
  String get loginTitle => 'Hesabınıza giriş yapın';

  @override
  String get loginSubtitle => 'Google hesabınızla devam edin';

  @override
  String get loginGoogle => 'Google ile Giriş Yap';

  @override
  String get loginNoAccount => 'Hesap oluşturmaya gerek yok';

  @override
  String get profileTitle => 'Profil Bilgileri';

  @override
  String get profileName => 'Ad Soyad';

  @override
  String get profileSchool => 'Okul Adı (isteğe bağlı)';

  @override
  String get profileComplete => 'Tamamla ve Başla';

  @override
  String homeGreeting(Object name) {
    return 'Merhaba, $name 👋';
  }

  @override
  String get homeGroups => 'Grup';

  @override
  String get homeExams => 'Sınav';

  @override
  String get homeToday => 'Bugün';

  @override
  String get homeNewGroup => 'Yeni Grup Oluştur';

  @override
  String get homeNewExam => 'Yeni Sınav Oluştur';

  @override
  String get homeRecentExams => 'Son Sınavlar';

  @override
  String get homeSeeAll => 'Tümünü Gör';

  @override
  String get groupsTitle => 'Gruplarım';

  @override
  String get groupsSearch => 'Grup ara...';

  @override
  String get groupsEmpty => 'Henüz grup yok';

  @override
  String get groupsCreateFirst => 'İlk Grubunu Oluştur';

  @override
  String get groupNew => 'Yeni Grup';

  @override
  String get groupEdit => 'Grubu Düzenle';

  @override
  String get groupName => 'Grup Adı *';

  @override
  String get groupDescription => 'Açıklama (isteğe bağlı)';

  @override
  String get groupSave => 'Kaydet';

  @override
  String get groupCancel => 'İptal';

  @override
  String get groupStudentInfo =>
      'Öğrenciler gruba önceden eklenmez — sınava katılırken otomatik eklenir';

  @override
  String groupExamCount(Object count) {
    return '$count sınav';
  }

  @override
  String get groupCreateExam => 'Bu Grupla Sınav Oluştur';

  @override
  String get groupPastExams => 'Geçmiş Sınavlar';

  @override
  String get examsTitle => 'Sınavlarım';

  @override
  String get examsEmpty => 'Henüz sınav yok';

  @override
  String get examNew => 'Yeni Sınav';

  @override
  String get examTitle => 'Sınav Başlığı *';

  @override
  String get examTitleHint => 'örn: Riyaziyyat Fənn İmtahanı';

  @override
  String get examSelectGroup => 'Grup seçin';

  @override
  String get examContinue => 'Devam Et →';

  @override
  String get examSettings => 'Sınav Ayarları';

  @override
  String get examMode => 'Sınav Modu';

  @override
  String get examModeScroll => 'Kaydırma Modu';

  @override
  String get examModeScrollDesc => 'Tüm sorular görünür, serbestçe gezilebilir';

  @override
  String get examModeSequential => 'Sıralı Mod';

  @override
  String get examModeSequentialDesc => 'Soru soru, geri dönülemez';

  @override
  String get examTiming => 'Zamanlama';

  @override
  String get examGlobalTimer => 'Genel Süre Sınırı';

  @override
  String get examQuestionTimer => 'Soru Başına Süre';

  @override
  String get examAntiCheat => 'Anti-Hile';

  @override
  String get examShuffleQuestions => 'Soru Sırasını Karıştır';

  @override
  String get examShuffleOptions => 'Şık Sırasını Karıştır';

  @override
  String get examShowStudent => 'Öğrenciye Göster';

  @override
  String get examShowScore => 'Puanını göster';

  @override
  String get examShowCorrect => 'Doğru cevapları göster';

  @override
  String get examShowLeaderboard => 'Sıralamayı göster';

  @override
  String get questionsTitle => 'Sorular';

  @override
  String questionsTotalPoints(Object points) {
    return 'Toplam: $points puan';
  }

  @override
  String get questionsAdd => '+ Soru Ekle';

  @override
  String get questionEditor => 'Soru Editörü';

  @override
  String get questionSave => 'Kaydet';

  @override
  String get questionText => 'Soru Metni *';

  @override
  String get questionMcq => 'Çoktan Seçmeli Soru';

  @override
  String get questionTf => 'Doğru / Yanlış';

  @override
  String get questionSa => 'Kısa Cevap';

  @override
  String get questionPoints => 'Puan';

  @override
  String questionCorrect(Object answer) {
    return 'Doğru cevap: $answer';
  }

  @override
  String get previewTitle => 'Önizleme';

  @override
  String get previewBanner => 'Öğrencinin göreceği görünüm';

  @override
  String get previewEdit => '← Düzenle';

  @override
  String get previewPublish => 'Yayınla →';

  @override
  String get shareTitle => 'Sınavı Paylaş';

  @override
  String get shareCode => 'Sınav Kodu';

  @override
  String get shareWhatsApp => 'WhatsApp';

  @override
  String get shareWhatsAppSub => 'Mesaj hazır, gönder!';

  @override
  String get shareQr => 'QR Kod';

  @override
  String get shareQrSub => 'Yansıt veya paylaş';

  @override
  String get shareCopy => 'Linki Kopyala';

  @override
  String get shareCopySub => 'Panoya kopyala';

  @override
  String get shareOther => 'Diğer Uygulamalar';

  @override
  String get shareOtherSub => 'Telegram, Mail...';

  @override
  String get shareGoLive => 'Canlı Kontrole Geç →';

  @override
  String get liveTitle => 'Canlı Kontrol';

  @override
  String get liveWaiting => 'Sınav Başlamadı';

  @override
  String get liveActive => 'Devam Ediyor';

  @override
  String liveStudentsReady(Object count) {
    return '$count öğrenci hazır';
  }

  @override
  String liveCompleted(Object done, Object total) {
    return 'Tamamlayan: $done / $total';
  }

  @override
  String get liveStart => 'Sınavı Başlat';

  @override
  String get liveStartSub => 'Başlatınca tüm öğrencilere aynı anda açılır';

  @override
  String get liveEndEarly => 'Sınavı Erken Bitir';

  @override
  String get resultsTitle => 'Sınav Sonuçları';

  @override
  String resultsParticipants(Object count) {
    return '$count öğrenci';
  }

  @override
  String get resultsAverage => 'Ortalama';

  @override
  String get resultsHighest => 'En Yüksek';

  @override
  String get resultsPassRate => 'Geçme';

  @override
  String get resultsRanking => 'Sıralama';

  @override
  String get resultsAnalysis => 'Soru Analizi';

  @override
  String get studentDetailTitle => 'Öğrenci Detayı';

  @override
  String studentDetailRank(Object rank) {
    return '$rank. Sırada';
  }

  @override
  String studentDetailScore(Object score, Object total) {
    return '$score / $total puan';
  }

  @override
  String get studentDetailCorrect => 'Doğru';

  @override
  String get studentDetailWrong => 'Yanlış';

  @override
  String get studentDetailEmpty => 'Boş';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsLanguage => 'Uygulama Dili';

  @override
  String get settingsVersion => 'ExamKit v1.0.0';

  @override
  String get settingsAbout => 'Hakkında';

  @override
  String get settingsLogout => 'Çıkış Yap';

  @override
  String get statusDraft => 'Taslak';

  @override
  String get statusActive => 'Aktif';

  @override
  String get statusLive => '● Canlı';

  @override
  String get statusCompleted => 'Tamamlandı';
}
