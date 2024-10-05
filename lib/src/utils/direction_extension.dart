import 'package:flutter/widgets.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

extension DirectionExtension on CardSwiperDirection {
  Axis get axis {
    if (this == CardSwiperDirection.left || this == CardSwiperDirection.right) {
      return Axis.horizontal;
    } else if (this == CardSwiperDirection.top ||
        this == CardSwiperDirection.bottom) {
      return Axis.vertical;
    } else if (this == CardSwiperDirection.none) {
      throw Exception('Direction is none');
    } else {
      // Handle custom angles: if the angle is closer to horizontal or vertical
      if ((angle >= 45 && angle <= 135) || (angle >= 225 && angle <= 315)) {
        return Axis.vertical; // Top/Bottom-ish
      } else {
        return Axis.horizontal; // Left/Right-ish
      }
    }
  }
}
