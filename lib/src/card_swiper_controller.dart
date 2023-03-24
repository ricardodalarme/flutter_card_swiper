import 'package:flutter/foundation.dart';
import 'package:flutter_card_swiper/src/enums.dart';

/// A controller that can be used to trigger swipes on a CardSwiper widget.
class CardSwiperController extends ChangeNotifier {
  CardSwiperState? state;

  /// Swipe the card by changing the status of the controller
  void swipe() {
    state = CardSwiperState.swipe;
    notifyListeners();
  }

  /// Swipe the card to the left side by changing the status of the controller
  void swipeLeft() {
    state = CardSwiperState.swipeLeft;
    notifyListeners();
  }

  /// Swipe the card to the right side by changing the status of the controller
  void swipeRight() {
    state = CardSwiperState.swipeRight;
    notifyListeners();
  }

  /// Swipe the card to the top side by changing the status of the controller
  void swipeTop() {
    state = CardSwiperState.swipeTop;
    notifyListeners();
  }

  /// Swipe the card to the bottom side by changing the status of the controller
  void swipeBottom() {
    state = CardSwiperState.swipeBottom;
    notifyListeners();
  }

  // Undo the last swipe by changing the status of the controller
  void undo() {
    state = CardSwiperState.undo;
    notifyListeners();
  }
}
