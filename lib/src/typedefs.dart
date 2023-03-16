import 'package:flutter_card_swiper/src/enums.dart';

typedef CardSwiperOnSwipe = bool? Function(
  int index,
  CardSwiperDirection direction,
);

typedef CardSwiperOnEnd = void Function();

typedef CardSwiperOnTapDisabled = void Function();
