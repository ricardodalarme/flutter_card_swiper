//to call the swipe function from outside of the CardSwiper
import 'package:flutter/widgets.dart';
import 'package:flutter_card_swiper/src/enums.dart';

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
}
