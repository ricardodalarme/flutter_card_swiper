import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_card_swiper/src/card_animation.dart';
import 'package:flutter_card_swiper/src/controller/controller_event.dart';
import 'package:flutter_card_swiper/src/utils/number_extension.dart';
import 'package:flutter_card_swiper/src/utils/undoable.dart';

part 'card_swiper_state.dart';

class CardSwiper extends StatefulWidget {
  /// Function that builds each card in the stack.
  ///
  /// The function is called with the index of the card to be built, the build context, the ratio
  /// of vertical drag to [threshold] as a percentage, and the ratio of horizontal drag to [threshold]
  /// as a percentage. The function should return a widget that represents the card at the given index.
  /// It can return `null`, which will result in an empty card being displayed.
  final NullableCardBuilder cardBuilder;

  /// The number of cards in the stack.
  ///
  /// The [cardsCount] parameter specifies the number of cards that will be displayed in the stack.
  ///
  /// This parameter is required and must be greater than 0.
  final int cardsCount;

  /// The index of the card to display initially.
  ///
  /// Defaults to 0, meaning the first card in the stack is displayed initially.
  final int initialIndex;

  /// The [CardSwiperController] used to control the swiper externally.
  ///
  /// If `null`, the swiper can only be controlled by user input.
  final CardSwiperController? controller;

  /// The duration of each swipe animation.
  ///
  /// Defaults to 200 milliseconds.
  final Duration duration;

  /// The padding around the swiper.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 20, vertical: 25)`.
  final EdgeInsetsGeometry padding;

  /// The maximum angle the card reaches while swiping.
  ///
  /// Must be between 0 and 360 degrees. Defaults to 30 degrees.
  final double maxAngle;

  /// The threshold from which the card is swiped away.
  ///
  /// Must be between 1 and 100 percent of the card width. Defaults to 50 percent.
  final int threshold;

  /// The scale of the card that is behind the front card.
  ///
  /// The [scale] and [backCardOffset] both impact the positions of the back cards.
  /// In order to keep the back card position same after changing the [scale],
  /// the [backCardOffset] should also be adjusted.
  /// * As a rough rule of thumb, 0.1 change in [scale] effects an
  /// [backCardOffset] of ~35px.
  ///
  /// Must be between 0 and 1. Defaults to 0.9.
  final double scale;

  /// Whether swiping is disabled.
  ///
  /// If `true`, swiping is disabled, except when triggered by the [controller].
  ///
  /// Defaults to `false`.
  final bool isDisabled;

  /// Callback function that is called when a swipe action is performed.
  ///
  /// The function is called with the oldIndex, the currentIndex and the direction of the swipe.
  /// If the function returns `false`, the swipe action is canceled and the current card remains
  /// on top of the stack. If the function returns `true`, the swipe action is performed as expected.
  final CardSwiperOnSwipe? onSwipe;

  /// Callback function that is called when there are no more cards to swipe.
  final CardSwiperOnEnd? onEnd;

  /// Callback function that is called when the swiper is disabled.
  final CardSwiperOnTapDisabled? onTapDisabled;

  /// Callback function that is called when the card is tapped (will not trigger from swipe movement)
  final CardSwiperOnTap? onTap;

  /// Defined the directions in which the card is allowed to be swiped.
  /// Defaults to [AllowedSwipeDirection.all]
  final AllowedSwipeDirection allowedSwipeDirection;

  /// A boolean value that determines whether the card stack should loop. When the last card is swiped,
  /// if isLoop is true, the first card will become the last card again. The default value is true.
  final bool isLoop;

  /// An integer that determines the number of cards that are displayed at the same time.
  /// The default value is 2. Note that you must display at least one card, and no more than the [cardsCount] parameter.
  final int numberOfCardsDisplayed;

  /// Callback function that is called when a card is unswiped.
  ///
  /// The function is called with the oldIndex, the currentIndex and the direction of the previous swipe.
  /// If the function returns `false`, the undo action is canceled and the current card remains
  /// on top of the stack. If the function returns `true`, the undo action is performed as expected.
  final CardSwiperOnUndo? onUndo;

  /// Callback function that is called when a card swipe direction changes.
  ///
  /// The function is called with the last detected horizontal direction and the last detected vertical direction
  final CardSwiperDirectionChange? onSwipeDirectionChange;

  /// The offset of the back card from the front card.
  ///
  /// In order to keep the back card position same after changing the [backCardOffset],
  /// the [scale] should also be adjusted.
  /// * As a rough rule of thumb, 35px change in [backCardOffset] effects a
  /// [scale] change of 0.1.
  ///
  /// Must be a positive value. Defaults to Offset(0, 40).
  final Offset backCardOffset;

  const CardSwiper({
    required this.cardBuilder,
    required this.cardsCount,
    this.controller,
    this.initialIndex = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
    this.duration = const Duration(milliseconds: 200),
    this.maxAngle = 30,
    this.threshold = 50,
    this.scale = 0.9,
    this.isDisabled = false,
    this.onTapDisabled,
    this.onTap,
    this.onSwipe,
    this.onEnd,
    this.onSwipeDirectionChange,
    this.allowedSwipeDirection = const AllowedSwipeDirection.all(),
    this.isLoop = true,
    this.numberOfCardsDisplayed = 2,
    this.onUndo,
    this.backCardOffset = const Offset(0, 40),
    super.key,
  })  : assert(
          maxAngle >= 0 && maxAngle <= 360,
          'maxAngle must be between 0 and 360',
        ),
        assert(
          threshold >= 1 && threshold <= 100,
          'threshold must be between 1 and 100',
        ),
        assert(
          scale >= 0 && scale <= 1,
          'scale must be between 0 and 1',
        ),
        assert(
          numberOfCardsDisplayed >= 1 && numberOfCardsDisplayed <= cardsCount,
          'you must display at least one card, and no more than [cardsCount]',
        ),
        assert(
          initialIndex >= 0 && initialIndex < cardsCount,
          'initialIndex must be between 0 and [cardsCount]',
        );

  @override
  State createState() => _CardSwiperState();
}
