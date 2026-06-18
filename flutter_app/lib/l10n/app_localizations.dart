import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_az.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('az'),
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In tr, this message translates to:
  /// **'ExamKit'**
  String get appName;

  /// No description provided for @splashLoading.
  ///
  /// In tr, this message translates to:
  /// **'Hazırlanıyor...'**
  String get splashLoading;

  /// No description provided for @onboardingSkip.
  ///
  /// In tr, this message translates to:
  /// **'Atla'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In tr, this message translates to:
  /// **'Başla'**
  String get onboardingStart;

  /// No description provided for @onboardingTitle1.
  ///
  /// In tr, this message translates to:
  /// **'Sınav Oluştur, Paylaş'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSub1.
  ///
  /// In tr, this message translates to:
  /// **'Dakikalar içinde sınav hazırla, öğrencilerinle paylaş.'**
  String get onboardingSub1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In tr, this message translates to:
  /// **'WhatsApp ile Tek Tuşta Paylaş'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSub2.
  ///
  /// In tr, this message translates to:
  /// **'Oluşturduğun sınavı tek dokunuşla WhatsApp grubuna gönder.'**
  String get onboardingSub2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In tr, this message translates to:
  /// **'Anlık Sonuçları Gör'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSub3.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenciler tamamladıkça sonuçları canlı izle.'**
  String get onboardingSub3;

  /// No description provided for @loginTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınıza giriş yapın'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Google hesabınızla devam edin'**
  String get loginSubtitle;

  /// No description provided for @loginGoogle.
  ///
  /// In tr, this message translates to:
  /// **'Google ile Giriş Yap'**
  String get loginGoogle;

  /// No description provided for @loginNoAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesap oluşturmaya gerek yok'**
  String get loginNoAccount;

  /// No description provided for @profileTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profil Bilgileri'**
  String get profileTitle;

  /// No description provided for @profileName.
  ///
  /// In tr, this message translates to:
  /// **'Ad Soyad'**
  String get profileName;

  /// No description provided for @profileSchool.
  ///
  /// In tr, this message translates to:
  /// **'Okul Adı (isteğe bağlı)'**
  String get profileSchool;

  /// No description provided for @profileComplete.
  ///
  /// In tr, this message translates to:
  /// **'Tamamla ve Başla'**
  String get profileComplete;

  /// No description provided for @homeGreeting.
  ///
  /// In tr, this message translates to:
  /// **'Merhaba, {name} 👋'**
  String homeGreeting(Object name);

  /// No description provided for @homeGroups.
  ///
  /// In tr, this message translates to:
  /// **'Grup'**
  String get homeGroups;

  /// No description provided for @homeExams.
  ///
  /// In tr, this message translates to:
  /// **'Sınav'**
  String get homeExams;

  /// No description provided for @homeToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get homeToday;

  /// No description provided for @homeNewGroup.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Grup Oluştur'**
  String get homeNewGroup;

  /// No description provided for @homeNewExam.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Sınav Oluştur'**
  String get homeNewExam;

  /// No description provided for @homeRecentExams.
  ///
  /// In tr, this message translates to:
  /// **'Son Sınavlar'**
  String get homeRecentExams;

  /// No description provided for @homeSeeAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Gör'**
  String get homeSeeAll;

  /// No description provided for @groupsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Gruplarım'**
  String get groupsTitle;

  /// No description provided for @groupsSearch.
  ///
  /// In tr, this message translates to:
  /// **'Grup ara...'**
  String get groupsSearch;

  /// No description provided for @groupsEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Henüz grup yok'**
  String get groupsEmpty;

  /// No description provided for @groupsCreateFirst.
  ///
  /// In tr, this message translates to:
  /// **'İlk Grubunu Oluştur'**
  String get groupsCreateFirst;

  /// No description provided for @groupNew.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Grup'**
  String get groupNew;

  /// No description provided for @groupEdit.
  ///
  /// In tr, this message translates to:
  /// **'Grubu Düzenle'**
  String get groupEdit;

  /// No description provided for @groupName.
  ///
  /// In tr, this message translates to:
  /// **'Grup Adı *'**
  String get groupName;

  /// No description provided for @groupDescription.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama (isteğe bağlı)'**
  String get groupDescription;

  /// No description provided for @groupSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get groupSave;

  /// No description provided for @groupCancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get groupCancel;

  /// No description provided for @groupStudentInfo.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenciler gruba önceden eklenmez — sınava katılırken otomatik eklenir'**
  String get groupStudentInfo;

  /// No description provided for @groupExamCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} sınav'**
  String groupExamCount(Object count);

  /// No description provided for @groupCreateExam.
  ///
  /// In tr, this message translates to:
  /// **'Bu Grupla Sınav Oluştur'**
  String get groupCreateExam;

  /// No description provided for @groupPastExams.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş Sınavlar'**
  String get groupPastExams;

  /// No description provided for @examsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sınavlarım'**
  String get examsTitle;

  /// No description provided for @examsEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Henüz sınav yok'**
  String get examsEmpty;

  /// No description provided for @examNew.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Sınav'**
  String get examNew;

  /// No description provided for @examTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sınav Başlığı *'**
  String get examTitle;

  /// No description provided for @examTitleHint.
  ///
  /// In tr, this message translates to:
  /// **'örn: Riyaziyyat Fənn İmtahanı'**
  String get examTitleHint;

  /// No description provided for @examSelectGroup.
  ///
  /// In tr, this message translates to:
  /// **'Grup seçin'**
  String get examSelectGroup;

  /// No description provided for @examContinue.
  ///
  /// In tr, this message translates to:
  /// **'Devam Et →'**
  String get examContinue;

  /// No description provided for @examSettings.
  ///
  /// In tr, this message translates to:
  /// **'Sınav Ayarları'**
  String get examSettings;

  /// No description provided for @examMode.
  ///
  /// In tr, this message translates to:
  /// **'Sınav Modu'**
  String get examMode;

  /// No description provided for @examModeScroll.
  ///
  /// In tr, this message translates to:
  /// **'Kaydırma Modu'**
  String get examModeScroll;

  /// No description provided for @examModeScrollDesc.
  ///
  /// In tr, this message translates to:
  /// **'Tüm sorular görünür, serbestçe gezilebilir'**
  String get examModeScrollDesc;

  /// No description provided for @examModeSequential.
  ///
  /// In tr, this message translates to:
  /// **'Sıralı Mod'**
  String get examModeSequential;

  /// No description provided for @examModeSequentialDesc.
  ///
  /// In tr, this message translates to:
  /// **'Soru soru, geri dönülemez'**
  String get examModeSequentialDesc;

  /// No description provided for @examTiming.
  ///
  /// In tr, this message translates to:
  /// **'Zamanlama'**
  String get examTiming;

  /// No description provided for @examGlobalTimer.
  ///
  /// In tr, this message translates to:
  /// **'Genel Süre Sınırı'**
  String get examGlobalTimer;

  /// No description provided for @examQuestionTimer.
  ///
  /// In tr, this message translates to:
  /// **'Soru Başına Süre'**
  String get examQuestionTimer;

  /// No description provided for @examAntiCheat.
  ///
  /// In tr, this message translates to:
  /// **'Anti-Hile'**
  String get examAntiCheat;

  /// No description provided for @examShuffleQuestions.
  ///
  /// In tr, this message translates to:
  /// **'Soru Sırasını Karıştır'**
  String get examShuffleQuestions;

  /// No description provided for @examShuffleOptions.
  ///
  /// In tr, this message translates to:
  /// **'Şık Sırasını Karıştır'**
  String get examShuffleOptions;

  /// No description provided for @examShowStudent.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenciye Göster'**
  String get examShowStudent;

  /// No description provided for @examShowScore.
  ///
  /// In tr, this message translates to:
  /// **'Puanını göster'**
  String get examShowScore;

  /// No description provided for @examShowCorrect.
  ///
  /// In tr, this message translates to:
  /// **'Doğru cevapları göster'**
  String get examShowCorrect;

  /// No description provided for @examShowLeaderboard.
  ///
  /// In tr, this message translates to:
  /// **'Sıralamayı göster'**
  String get examShowLeaderboard;

  /// No description provided for @questionsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sorular'**
  String get questionsTitle;

  /// No description provided for @questionsTotalPoints.
  ///
  /// In tr, this message translates to:
  /// **'Toplam: {points} puan'**
  String questionsTotalPoints(Object points);

  /// No description provided for @questionsAdd.
  ///
  /// In tr, this message translates to:
  /// **'+ Soru Ekle'**
  String get questionsAdd;

  /// No description provided for @questionEditor.
  ///
  /// In tr, this message translates to:
  /// **'Soru Editörü'**
  String get questionEditor;

  /// No description provided for @questionSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get questionSave;

  /// No description provided for @questionText.
  ///
  /// In tr, this message translates to:
  /// **'Soru Metni *'**
  String get questionText;

  /// No description provided for @questionMcq.
  ///
  /// In tr, this message translates to:
  /// **'Çoktan Seçmeli Soru'**
  String get questionMcq;

  /// No description provided for @questionTf.
  ///
  /// In tr, this message translates to:
  /// **'Doğru / Yanlış'**
  String get questionTf;

  /// No description provided for @questionSa.
  ///
  /// In tr, this message translates to:
  /// **'Kısa Cevap'**
  String get questionSa;

  /// No description provided for @questionPoints.
  ///
  /// In tr, this message translates to:
  /// **'Puan'**
  String get questionPoints;

  /// No description provided for @questionCorrect.
  ///
  /// In tr, this message translates to:
  /// **'Doğru cevap: {answer}'**
  String questionCorrect(Object answer);

  /// No description provided for @previewTitle.
  ///
  /// In tr, this message translates to:
  /// **'Önizleme'**
  String get previewTitle;

  /// No description provided for @previewBanner.
  ///
  /// In tr, this message translates to:
  /// **'Öğrencinin göreceği görünüm'**
  String get previewBanner;

  /// No description provided for @previewEdit.
  ///
  /// In tr, this message translates to:
  /// **'← Düzenle'**
  String get previewEdit;

  /// No description provided for @previewPublish.
  ///
  /// In tr, this message translates to:
  /// **'Yayınla →'**
  String get previewPublish;

  /// No description provided for @shareTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sınavı Paylaş'**
  String get shareTitle;

  /// No description provided for @shareCode.
  ///
  /// In tr, this message translates to:
  /// **'Sınav Kodu'**
  String get shareCode;

  /// No description provided for @shareWhatsApp.
  ///
  /// In tr, this message translates to:
  /// **'WhatsApp'**
  String get shareWhatsApp;

  /// No description provided for @shareWhatsAppSub.
  ///
  /// In tr, this message translates to:
  /// **'Mesaj hazır, gönder!'**
  String get shareWhatsAppSub;

  /// No description provided for @shareQr.
  ///
  /// In tr, this message translates to:
  /// **'QR Kod'**
  String get shareQr;

  /// No description provided for @shareQrSub.
  ///
  /// In tr, this message translates to:
  /// **'Yansıt veya paylaş'**
  String get shareQrSub;

  /// No description provided for @shareCopy.
  ///
  /// In tr, this message translates to:
  /// **'Linki Kopyala'**
  String get shareCopy;

  /// No description provided for @shareCopySub.
  ///
  /// In tr, this message translates to:
  /// **'Panoya kopyala'**
  String get shareCopySub;

  /// No description provided for @shareOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer Uygulamalar'**
  String get shareOther;

  /// No description provided for @shareOtherSub.
  ///
  /// In tr, this message translates to:
  /// **'Telegram, Mail...'**
  String get shareOtherSub;

  /// No description provided for @shareGoLive.
  ///
  /// In tr, this message translates to:
  /// **'Canlı Kontrole Geç →'**
  String get shareGoLive;

  /// No description provided for @liveTitle.
  ///
  /// In tr, this message translates to:
  /// **'Canlı Kontrol'**
  String get liveTitle;

  /// No description provided for @liveWaiting.
  ///
  /// In tr, this message translates to:
  /// **'Sınav Başlamadı'**
  String get liveWaiting;

  /// No description provided for @liveActive.
  ///
  /// In tr, this message translates to:
  /// **'Devam Ediyor'**
  String get liveActive;

  /// No description provided for @liveStudentsReady.
  ///
  /// In tr, this message translates to:
  /// **'{count} öğrenci hazır'**
  String liveStudentsReady(Object count);

  /// No description provided for @liveCompleted.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlayan: {done} / {total}'**
  String liveCompleted(Object done, Object total);

  /// No description provided for @liveStart.
  ///
  /// In tr, this message translates to:
  /// **'Sınavı Başlat'**
  String get liveStart;

  /// No description provided for @liveStartSub.
  ///
  /// In tr, this message translates to:
  /// **'Başlatınca tüm öğrencilere aynı anda açılır'**
  String get liveStartSub;

  /// No description provided for @liveEndEarly.
  ///
  /// In tr, this message translates to:
  /// **'Sınavı Erken Bitir'**
  String get liveEndEarly;

  /// No description provided for @resultsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sınav Sonuçları'**
  String get resultsTitle;

  /// No description provided for @resultsParticipants.
  ///
  /// In tr, this message translates to:
  /// **'{count} öğrenci'**
  String resultsParticipants(Object count);

  /// No description provided for @resultsAverage.
  ///
  /// In tr, this message translates to:
  /// **'Ortalama'**
  String get resultsAverage;

  /// No description provided for @resultsHighest.
  ///
  /// In tr, this message translates to:
  /// **'En Yüksek'**
  String get resultsHighest;

  /// No description provided for @resultsPassRate.
  ///
  /// In tr, this message translates to:
  /// **'Geçme'**
  String get resultsPassRate;

  /// No description provided for @resultsRanking.
  ///
  /// In tr, this message translates to:
  /// **'Sıralama'**
  String get resultsRanking;

  /// No description provided for @resultsAnalysis.
  ///
  /// In tr, this message translates to:
  /// **'Soru Analizi'**
  String get resultsAnalysis;

  /// No description provided for @studentDetailTitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci Detayı'**
  String get studentDetailTitle;

  /// No description provided for @studentDetailRank.
  ///
  /// In tr, this message translates to:
  /// **'{rank}. Sırada'**
  String studentDetailRank(Object rank);

  /// No description provided for @studentDetailScore.
  ///
  /// In tr, this message translates to:
  /// **'{score} / {total} puan'**
  String studentDetailScore(Object score, Object total);

  /// No description provided for @studentDetailCorrect.
  ///
  /// In tr, this message translates to:
  /// **'Doğru'**
  String get studentDetailCorrect;

  /// No description provided for @studentDetailWrong.
  ///
  /// In tr, this message translates to:
  /// **'Yanlış'**
  String get studentDetailWrong;

  /// No description provided for @studentDetailEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Boş'**
  String get studentDetailEmpty;

  /// No description provided for @settingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Dili'**
  String get settingsLanguage;

  /// No description provided for @settingsVersion.
  ///
  /// In tr, this message translates to:
  /// **'ExamKit v1.0.0'**
  String get settingsVersion;

  /// No description provided for @settingsAbout.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get settingsAbout;

  /// No description provided for @settingsLogout.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get settingsLogout;

  /// No description provided for @statusDraft.
  ///
  /// In tr, this message translates to:
  /// **'Taslak'**
  String get statusDraft;

  /// No description provided for @statusActive.
  ///
  /// In tr, this message translates to:
  /// **'Aktif'**
  String get statusActive;

  /// No description provided for @statusLive.
  ///
  /// In tr, this message translates to:
  /// **'● Canlı'**
  String get statusLive;

  /// No description provided for @statusCompleted.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı'**
  String get statusCompleted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['az', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'az':
      return AppLocalizationsAz();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
