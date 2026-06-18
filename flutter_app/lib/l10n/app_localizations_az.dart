// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Azerbaijani (`az`).
class AppLocalizationsAz extends AppLocalizations {
  AppLocalizationsAz([String locale = 'az']) : super(locale);

  @override
  String get appName => 'ExamKit';

  @override
  String get splashLoading => 'Hazırlanır...';

  @override
  String get onboardingSkip => 'Keç';

  @override
  String get onboardingNext => 'Davam Et';

  @override
  String get onboardingStart => 'Başla';

  @override
  String get onboardingTitle1 => 'İmtahan Yarat, Paylaş';

  @override
  String get onboardingSub1 =>
      'Dəqiqələr içində imtahan hazırla, tələbələrinlə paylaş.';

  @override
  String get onboardingTitle2 => 'WhatsApp ilə Bir Toxunuşla Paylaş';

  @override
  String get onboardingSub2 =>
      'Yaratdığın imtahanı bir toxunuşla WhatsApp qrupuna göndər.';

  @override
  String get onboardingTitle3 => 'Anlıq Nəticələri Gör';

  @override
  String get onboardingSub3 => 'Tələbələr tamamladıqca nəticələri canlı izlə.';

  @override
  String get loginTitle => 'Hesabınıza daxil olun';

  @override
  String get loginSubtitle => 'Google hesabınızla davam edin';

  @override
  String get loginGoogle => 'Google ilə Daxil Ol';

  @override
  String get loginNoAccount => 'Hesab yaratmağa ehtiyac yoxdur';

  @override
  String get profileTitle => 'Profil Məlumatları';

  @override
  String get profileName => 'Ad Soyad';

  @override
  String get profileSchool => 'Məktəb Adı (istəyə bağlı)';

  @override
  String get profileComplete => 'Tamamla və Başla';

  @override
  String homeGreeting(Object name) {
    return 'Salam, $name 👋';
  }

  @override
  String get homeGroups => 'Qrup';

  @override
  String get homeExams => 'İmtahan';

  @override
  String get homeToday => 'Bugün';

  @override
  String get homeNewGroup => 'Yeni Qrup Yarat';

  @override
  String get homeNewExam => 'Yeni İmtahan Yarat';

  @override
  String get homeRecentExams => 'Son İmtahanlar';

  @override
  String get homeSeeAll => 'Hamısını Gör';

  @override
  String get groupsTitle => 'Qruplarım';

  @override
  String get groupsSearch => 'Qrup axtar...';

  @override
  String get groupsEmpty => 'Hələ qrup yoxdur';

  @override
  String get groupsCreateFirst => 'İlk Qrupunu Yarat';

  @override
  String get groupNew => 'Yeni Qrup';

  @override
  String get groupEdit => 'Qrupu Düzəlt';

  @override
  String get groupName => 'Qrup Adı *';

  @override
  String get groupDescription => 'Açıqlama (istəyə bağlı)';

  @override
  String get groupSave => 'Yadda Saxla';

  @override
  String get groupCancel => 'İmtina';

  @override
  String get groupStudentInfo =>
      'Tələbələr qrupa əvvəlcədən əlavə edilmir — imtahana qatılarkən avtomatik əlavə olunur';

  @override
  String groupExamCount(Object count) {
    return '$count imtahan';
  }

  @override
  String get groupCreateExam => 'Bu Qrupla İmtahan Yarat';

  @override
  String get groupPastExams => 'Keçmiş İmtahanlar';

  @override
  String get examsTitle => 'İmtahanlarım';

  @override
  String get examsEmpty => 'Hələ imtahan yoxdur';

  @override
  String get examNew => 'Yeni İmtahan';

  @override
  String get examTitle => 'İmtahan Başlığı *';

  @override
  String get examTitleHint => 'məs: Riyaziyyat Fənn İmtahanı';

  @override
  String get examSelectGroup => 'Qrup seçin';

  @override
  String get examContinue => 'Davam Et →';

  @override
  String get examSettings => 'İmtahan Tənzimləmələri';

  @override
  String get examMode => 'İmtahan Modu';

  @override
  String get examModeScroll => 'Sürüşdürmə Modu';

  @override
  String get examModeScrollDesc => 'Bütün suallar görünür, sərbəst gəzmək olar';

  @override
  String get examModeSequential => 'Ardıcıl Mod';

  @override
  String get examModeSequentialDesc => 'Sual sual, geri dönülməz';

  @override
  String get examTiming => 'Zamanlama';

  @override
  String get examGlobalTimer => 'Ümumi Müddət Limiti';

  @override
  String get examQuestionTimer => 'Hər Suala Müddət';

  @override
  String get examAntiCheat => 'Anti-Fırıldaq';

  @override
  String get examShuffleQuestions => 'Sual Sırasını Qarışdır';

  @override
  String get examShuffleOptions => 'Variant Sırasını Qarışdır';

  @override
  String get examShowStudent => 'Tələbəyə Göstər';

  @override
  String get examShowScore => 'Xalını göstər';

  @override
  String get examShowCorrect => 'Doğru cavabları göstər';

  @override
  String get examShowLeaderboard => 'Sıralamanı göstər';

  @override
  String get questionsTitle => 'Suallar';

  @override
  String questionsTotalPoints(Object points) {
    return 'Cəmi: $points xal';
  }

  @override
  String get questionsAdd => '+ Sual Əlavə Et';

  @override
  String get questionEditor => 'Sual Redaktoru';

  @override
  String get questionSave => 'Yadda Saxla';

  @override
  String get questionText => 'Sual Mətni *';

  @override
  String get questionMcq => 'Çoxseçimli Sual';

  @override
  String get questionTf => 'Doğru / Yanlış';

  @override
  String get questionSa => 'Qısa Cavab';

  @override
  String get questionPoints => 'Xal';

  @override
  String questionCorrect(Object answer) {
    return 'Doğru cavab: $answer';
  }

  @override
  String get previewTitle => 'Önizləmə';

  @override
  String get previewBanner => 'Tələbənin görəcəyi görünüş';

  @override
  String get previewEdit => '← Düzəlt';

  @override
  String get previewPublish => 'Yayımla →';

  @override
  String get shareTitle => 'İmtahanı Paylaş';

  @override
  String get shareCode => 'İmtahan Kodu';

  @override
  String get shareWhatsApp => 'WhatsApp';

  @override
  String get shareWhatsAppSub => 'Mesaj hazır, göndər!';

  @override
  String get shareQr => 'QR Kod';

  @override
  String get shareQrSub => 'Yansıt və ya paylaş';

  @override
  String get shareCopy => 'Linki Kopyala';

  @override
  String get shareCopySub => 'Panoya kopyala';

  @override
  String get shareOther => 'Digər Tətbiqlər';

  @override
  String get shareOtherSub => 'Telegram, Mail...';

  @override
  String get shareGoLive => 'Canlı Nəzarətə Keç →';

  @override
  String get liveTitle => 'Canlı Nəzarət';

  @override
  String get liveWaiting => 'İmtahan Başlamadı';

  @override
  String get liveActive => 'Davam Edir';

  @override
  String liveStudentsReady(Object count) {
    return '$count tələbə hazır';
  }

  @override
  String liveCompleted(Object done, Object total) {
    return 'Tamamlayan: $done / $total';
  }

  @override
  String get liveStart => 'İmtahanı Başlat';

  @override
  String get liveStartSub => 'Başladınca bütün tələbələrə eyni anda açılır';

  @override
  String get liveEndEarly => 'İmtahanı Erkən Bitir';

  @override
  String get resultsTitle => 'İmtahan Nəticələri';

  @override
  String resultsParticipants(Object count) {
    return '$count tələbə';
  }

  @override
  String get resultsAverage => 'Ortalama';

  @override
  String get resultsHighest => 'Ən Yüksək';

  @override
  String get resultsPassRate => 'Keçmə';

  @override
  String get resultsRanking => 'Sıralama';

  @override
  String get resultsAnalysis => 'Sual Analizi';

  @override
  String get studentDetailTitle => 'Tələbə Detayı';

  @override
  String studentDetailRank(Object rank) {
    return '$rank. Sırada';
  }

  @override
  String studentDetailScore(Object score, Object total) {
    return '$score / $total xal';
  }

  @override
  String get studentDetailCorrect => 'Doğru';

  @override
  String get studentDetailWrong => 'Yanlış';

  @override
  String get studentDetailEmpty => 'Boş';

  @override
  String get settingsTitle => 'Tənzimləmələr';

  @override
  String get settingsLanguage => 'Tətbiq Dili';

  @override
  String get settingsVersion => 'ExamKit v1.0.0';

  @override
  String get settingsAbout => 'Haqqında';

  @override
  String get settingsLogout => 'Çıxış Et';

  @override
  String get statusDraft => 'Qaralama';

  @override
  String get statusActive => 'Aktiv';

  @override
  String get statusLive => '● Canlı';

  @override
  String get statusCompleted => 'Tamamlandı';
}
