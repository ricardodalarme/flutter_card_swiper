import 'package:flutter/widgets.dart';
import 'package:flutter_card_swiper/src/enums.dart';
import 'package:flutter_card_swiper/src/extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('num.isBetween', () {
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

  group('CardSwiperDirection.axis', () {
    test('should return horizontal when direction is left', () {
      final axis = CardSwiperDirection.left.axis;
      expect(axis, Axis.horizontal);
    });

    test('should return horizontal when direction is right', () {
      final axis = CardSwiperDirection.right.axis;
      expect(axis, Axis.horizontal);
    });

    test('should return vertical when direction is top', () {
      final axis = CardSwiperDirection.top.axis;
      expect(axis, Axis.vertical);
    });

    test('should return vertical when direction is bottom', () {
      final axis = CardSwiperDirection.bottom.axis;
      expect(axis, Axis.vertical);
    });

    test('should throw exception when direction is none', () {
      expect(() => CardSwiperDirection.none.axis, throwsException);
    });
  });
}
