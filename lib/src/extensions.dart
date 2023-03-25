import 'package:flutter/widgets.dart';
import 'package:flutter_card_swiper/src/enums.dart';

extension Range on num {
  bool isBetween(num from, num to) {
    return from <= this && this <= to;
  }
}

extension CardSwiperDirectionExtension on CardSwiperDirection {
  Axis get axis {
    switch (this) {
      case CardSwiperDirection.left:
      case CardSwiperDirection.right:
        return Axis.horizontal;
      case CardSwiperDirection.top:
      case CardSwiperDirection.bottom:
        return Axis.vertical;
      case CardSwiperDirection.none:
        throw Exception('Direction is none');
    }
  }
}
