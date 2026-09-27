import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:cancun_dashbooth/domain/entities/ai_badge_result.dart';

void main() {
  group('AiBadgeResult Entity Tests', () {
    test('instantiates correctly and supports equality', () {
      final bytes1 = Uint8List.fromList([1, 2, 3]);
      final bytes2 = Uint8List.fromList([1, 2, 3]);

      final result1 = AiBadgeResult(
        imageBytes: bytes1,
        aiVibeTitle: 'Dash Surfista Legendario | Vibra Caribeña 100%',
        isAiTransformed: true,
      );

      final result2 = AiBadgeResult(
        imageBytes: bytes2,
        aiVibeTitle: 'Dash Surfista Legendario | Vibra Caribeña 100%',
        isAiTransformed: true,
      );

      expect(result1.imageBytes, equals(bytes1));
      expect(result1.aiVibeTitle,
          equals('Dash Surfista Legendario | Vibra Caribeña 100%'));
      expect(result1.isAiTransformed, isTrue);
      expect(result1, equals(result2));
    });

    test('defaults isAiTransformed to false', () {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final result = AiBadgeResult(
        imageBytes: bytes,
        aiVibeTitle: 'Fallback Title',
      );
      expect(result.isAiTransformed, isFalse);
    });
  });
}
