import 'package:flutter_card_swiper/flutter_card_swiper.dart';

abstract class ControllerEvent {
  const ControllerEvent();
}

class ControllerSwipeEvent extends ControllerEvent {
  final CardSwiperDirection direction;

  const ControllerSwipeEvent(this.direction);
}

class ControllerUndoEvent extends ControllerEvent {
  const ControllerUndoEvent();
}
