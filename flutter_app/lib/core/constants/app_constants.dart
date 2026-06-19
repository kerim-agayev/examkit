/// ExamKit sabitleri.
class AppConstants {
  static const String appName = 'ExamKit';
  static const String studentWebBaseUrl = 'stitch.examkit.app';
  static const int maxStudentsPerExam = 99;
  static const int maxExamCodeLength = 6;
  static const int minGlobalTimerMinutes = 1;
  static const int maxGlobalTimerMinutes = 180;
  static const int defaultGlobalTimerMinutes = 45;
  static const int recoveryBufferMs = 30000; // ADR-006
  static const String firebaseProjectId = 'examkit-5e691';
  static const String firebaseRegion = 'europe-west1';
}
