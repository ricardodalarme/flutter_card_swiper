import 'package:flutter_card_swiper/src/card_swiper_controller.dart';
import 'package:flutter_card_swiper/src/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CardSwiperController', () {
    test('swipe() changes state to swipe', () {
      final controller = CardSwiperController();
      controller.swipe();
      expect(controller.state, CardSwiperState.swipe);
    });

    test('swipeLeft() changes state to swipeLeft', () {
      final controller = CardSwiperController();
      controller.swipeLeft();
      expect(controller.state, CardSwiperState.swipeLeft);
    });

    test('swipeRight() changes state to swipeRight', () {
      final controller = CardSwiperController();
      controller.swipeRight();
      expect(controller.state, CardSwiperState.swipeRight);
    });

    test('swipeTop() changes state to swipeTop', () {
      final controller = CardSwiperController();
      controller.swipeTop();
      expect(controller.state, CardSwiperState.swipeTop);
    });

    test('swipeBottom() changes state to swipeBottom', () {
      final controller = CardSwiperController();
      controller.swipeBottom();
      expect(controller.state, CardSwiperState.swipeBottom);
    });

    test('undo() changes state to undo', () {
      final controller = CardSwiperController();
      controller.undo();
      expect(controller.state, CardSwiperState.undo);
    });
  });
}
