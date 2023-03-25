import 'package:flutter_card_swiper/src/card_swiper_controller.dart';
import 'package:flutter_card_swiper/src/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CardSwiperController', () {
    test('swipe() should change the state to swipe', () {
      final controller = CardSwiperController();
      controller.swipe();
      expect(controller.state, CardSwiperState.swipe);
    });

    test('swipeLeft() should change the state to swipeLeft', () {
      final controller = CardSwiperController();
      controller.swipeLeft();
      expect(controller.state, CardSwiperState.swipeLeft);
    });

    test('swipeRight() should change the state to swipeRight', () {
      final controller = CardSwiperController();
      controller.swipeRight();
      expect(controller.state, CardSwiperState.swipeRight);
    });

    test('swipeTop() should change the state to swipeTop', () {
      final controller = CardSwiperController();
      controller.swipeTop();
      expect(controller.state, CardSwiperState.swipeTop);
    });

    test('swipeBottom() should change the state to swipeBottom', () {
      final controller = CardSwiperController();
      controller.swipeBottom();
      expect(controller.state, CardSwiperState.swipeBottom);
    });
  });
}
