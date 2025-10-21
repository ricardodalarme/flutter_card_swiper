import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_card_swiper/src/direction/card_swiper_direction.dart';

typedef CardSwiperOnSwipe = FutureOr<bool> Function(
  int previousIndex,
  int? currentIndex,
  CardSwiperDirection direction,
);

typedef CardSwiperOnSwipeUpdate = void Function(
  int? currentIndex,
  CardSwiperDirection direction,
);

typedef NullableCardBuilder = Widget? Function(
  BuildContext context,
  int index,
  int horizontalOffsetPercentage,
  int verticalOffsetPercentage,
);

typedef CardSwiperDirectionChange = void Function(
  CardSwiperDirection horizontalDirection,
  CardSwiperDirection verticalDirection,
);

typedef CardSwiperOnEnd = FutureOr<void> Function();

typedef CardSwiperOnTapDisabled = FutureOr<void> Function();

typedef CardSwiperOnUndo = bool Function(
  int? previousIndex,
  int currentIndex,
  CardSwiperDirection direction,
);

/// Builder for an overlay widget that appears above the front card while
/// the user is dragging/swiping it.
///
/// Parameters:
/// * [index] — index of the front (active) card.
/// * [direction] — dominant swipe direction determined from the largest
///   axis displacement or `CardSwiperDirection.none` when idle.
/// * [progress] — normalized progress in the dominant axis (0.0–1.0) where
///   1.0 means the movement reached or exceeded the swipe `threshold`.
///
/// Return `null` to render no overlay for the current state.
///
/// You may return any widget, including a `Positioned` to anchor your overlay
/// inside the card bounds. If you return a non-`Positioned` widget, it will be
/// wrapped in a full-size layer over the card.
///
/// The overlay is wrapped with an `Opacity` that uses `progress` so you don't
/// need to animate it manually (but you can if you prefer by ignoring the
/// provided progress value).
typedef CardSwiperOverlayBuilder = Widget? Function(
  BuildContext context,
  int index,
  CardSwiperDirection direction,
  double progress,
);
