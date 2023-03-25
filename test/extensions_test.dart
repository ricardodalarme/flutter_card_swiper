import 'package:flutter_card_swiper/src/extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isBetween', () {
    test('should return true when value is within range', () {
      const value = 5;
      const from = 1;
      const to = 10;

      final result = value.isBetween(from, to);

      expect(result, isTrue);
    });

    test('should return true when value is equal to the range limits', () {
      const value = 1;
      const from = 1;
      const to = 1;

      final result = value.isBetween(from, to);

      expect(result, isTrue);
    });

    test('should return false when value is outside the range', () {
      const value = 15;
      const from = 1;
      const to = 10;

      final result = value.isBetween(from, to);

      expect(result, isFalse);
    });

    test('should return false when the range limits are inverted', () {
      const value = 5;
      const from = 10;
      const to = 1;

      final result = value.isBetween(from, to);

      expect(result, isFalse);
    });
  });
}
