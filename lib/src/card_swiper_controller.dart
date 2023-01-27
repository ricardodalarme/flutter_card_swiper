import 'package:flutter/foundation.dart';
import 'package:flutter_card_swiper/src/enums.dart';

//to call the swipe function from outside of the CardSwiper
class CardSwiperController extends ChangeNotifier {
  CardSwiperState? state;

  //swipe the card by changing the status of the controller
  void swipe() {
    state = CardSwiperState.swipe;
    notifyListeners();
  }

  //swipe the card to the left side by changing the status of the controller
  void swipeLeft() {
    state = CardSwiperState.swipeLeft;
    notifyListeners();
  }

  //swipe the card to the right side by changing the status of the controller
  void swipeRight() {
    state = CardSwiperState.swipeRight;
    notifyListeners();
  }

  //swipe the card to the top side by changing the status of the controller
  void swipeTop() {
    state = CardSwiperState.swipeTop;
    notifyListeners();
  }

  //swipe the card to the bottom side by changing the status of the controller
  void swipeBottom() {
    state = CardSwiperState.swipeBottom;
    notifyListeners();
  }
}
