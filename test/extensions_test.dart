import 'package:flutter/widgets.dart';
import 'package:flutter_card_swiper/src/enums.dart';
import 'package:flutter_card_swiper/src/extensions.dart';
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

  group('CardSwiperDirection.axis', () {
    test('when direction is left expect to return horizontal ', () {
      final axis = CardSwiperDirection.left.axis;
      expect(axis, Axis.horizontal);
    });

    test('when direction is right expect to return horizontal', () {
      final axis = CardSwiperDirection.right.axis;
      expect(axis, Axis.horizontal);
    });

    test('when direction is top expect to return vertical', () {
      final axis = CardSwiperDirection.top.axis;
      expect(axis, Axis.vertical);
    });

    test('when direction is bottom expect to return vertical ', () {
      final axis = CardSwiperDirection.bottom.axis;
      expect(axis, Axis.vertical);
    });

    test('when direction is none expect to throw exception ', () {
      expect(() => CardSwiperDirection.none.axis, throwsException);
    });
  });
}
