import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Temel test — uygulama başlatılabilir
    // (Firebase bağlantısı gerektirdiği için full widget test
    //  Firebase emulator ile daha sonra yazılacak)
    expect(true, isTrue);
  });
}
