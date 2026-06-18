import 'package:flutter_test/flutter_test.dart';
import 'package:examkit/core/utils/exam_code_generator.dart';

void main() {
  group('ExamCodeGenerator', () {
    test('generate returns 6 characters', () {
      final code = ExamCodeGenerator.generate();
      expect(code.length, 6);
    });

    test('generate uses only allowed charset', () {
      for (int i = 0; i < 100; i++) {
        final code = ExamCodeGenerator.generate();
        expect(RegExp(r'^[A-HJ-NP-Z2-9]{6}$').hasMatch(code), isTrue);
      }
    });

    test('isValid accepts valid code', () {
      expect(ExamCodeGenerator.isValid('ABCDEF'), isTrue);
      expect(ExamCodeGenerator.isValid('XYZ234'), isTrue);
    });

    test('isValid rejects invalid chars', () {
      expect(ExamCodeGenerator.isValid('ABCDE0'), isFalse); // 0 not allowed
      expect(ExamCodeGenerator.isValid('ABCDEI'), isFalse); // I not allowed
      expect(ExamCodeGenerator.isValid('ABCDEO'), isFalse); // O not allowed
    });

    test('isValid rejects wrong length', () {
      expect(ExamCodeGenerator.isValid('ABC'), isFalse);
      expect(ExamCodeGenerator.isValid('ABCDEFG'), isFalse);
    });
  });
}
