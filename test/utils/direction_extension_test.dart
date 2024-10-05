import 'package:flutter/widgets.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_card_swiper/src/utils/direction_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
