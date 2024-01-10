import 'package:flutter_card_swiper/src/utils/number_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('num.isBetween', () {
    test('when value is within range expect to return true', () {
      const value = 5;
      const from = 1;
      const to = 10;

      final result = value.isBetween(from, to);

      expect(result, isTrue);
    });

    test('when value is equal to the range limits expect to return true', () {
      const value = 1;
      const from = 1;
      const to = 1;

      final result = value.isBetween(from, to);

      expect(result, isTrue);
    });

    test('when value is outside the range expect to return false', () {
      const value = 15;
      const from = 1;
      const to = 10;

      final result = value.isBetween(from, to);

      expect(result, isFalse);
    });

    test('when the range limits are inverted expect to return false', () {
      const value = 5;
      const from = 10;
      const to = 1;

      final result = value.isBetween(from, to);

      expect(result, isFalse);
    });
  });
}
