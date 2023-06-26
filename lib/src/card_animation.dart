import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class CardAnimation {
  CardAnimation({
    required this.animationController,
    required this.maxAngle,
    required this.initialScale,
    required this.initialOffset,
    this.isHorizontalSwipingEnabled = true,
    this.isVerticalSwipingEnabled = true,
    this.allowedSwipeDirection = const AllowedSwipeDirection.all(),
    this.onSwipeDirectionChanged,
  }) : scale = initialScale;

  final double maxAngle;
  final double initialScale;
  final Offset initialOffset;
  final AnimationController animationController;
  final bool isHorizontalSwipingEnabled;
  final bool isVerticalSwipingEnabled;
  final AllowedSwipeDirection allowedSwipeDirection;
  final ValueChanged<CardSwiperDirection>? onSwipeDirectionChanged;

  double left = 0;
  double top = 0;
  double total = 0;
  double angle = 0;
  double scale;
  Offset difference = Offset.zero;

  late Animation<double> _leftAnimation;
  late Animation<double> _topAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _differenceAnimation;

  double get _maxAngleInRadian => maxAngle * (math.pi / 180);

  void sync() {
    left = _leftAnimation.value;
    top = _topAnimation.value;
    scale = _scaleAnimation.value;
    difference = _differenceAnimation.value;
  }

  void reset() {
    animationController.reset();
    left = 0;
    top = 0;
    total = 0;
    angle = 0;
    scale = initialScale;
    difference = Offset.zero;
  }

  void update(double dx, double dy, bool inverseAngle) {
    if (allowedSwipeDirection.right && allowedSwipeDirection.left) {
      if (left > 0) {
        onSwipeDirectionChanged?.call(CardSwiperDirection.right);
      } else if (left < 0) {
        onSwipeDirectionChanged?.call(CardSwiperDirection.left);
      }
      left += dx;
    } else if (allowedSwipeDirection.right) {
      if (left >= 0) {
        onSwipeDirectionChanged?.call(CardSwiperDirection.right);
        left += dx;
      }
    } else if (allowedSwipeDirection.left) {
      if (left <= 0) {
        onSwipeDirectionChanged?.call(CardSwiperDirection.left);
        left += dx;
      }
    }

    if (allowedSwipeDirection.up && allowedSwipeDirection.down) {
      if (top > 0) {
        onSwipeDirectionChanged?.call(CardSwiperDirection.bottom);
      } else if (top < 0) {
        onSwipeDirectionChanged?.call(CardSwiperDirection.top);
      }
      top += dy;
    } else if (allowedSwipeDirection.up) {
      if (top <= 0) {
        onSwipeDirectionChanged?.call(CardSwiperDirection.top);
        top += dy;
      }
    } else if (allowedSwipeDirection.down) {
      if (top >= 0) {
        onSwipeDirectionChanged?.call(CardSwiperDirection.bottom);
        top += dy;
      }
    }

    total = left + top;
    updateAngle(inverseAngle);
    updateScale();
    updateDifference();
  }

  void updateAngle(bool inverse) {
    angle = clampDouble(
      _maxAngleInRadian * left / 1000,
      -_maxAngleInRadian,
      _maxAngleInRadian,
    );
    if (inverse) angle *= -1;
  }

  void updateScale() {
    scale = clampDouble(initialScale + (total.abs() / 5000), initialScale, 1.0);
  }

  void updateDifference() {
    final discrepancy = (total / 10).abs();

    var diffX = 0.0, diffY = 0.0;

    if (initialOffset.dx > 0) {
      diffX = discrepancy;
    } else if (initialOffset.dx < 0) {
      diffX = -discrepancy;
    }

    if (initialOffset.dy < 0) {
      diffY = -discrepancy;
    } else if (initialOffset.dy > 0) {
      diffY = discrepancy;
    }

    difference = Offset(diffX, diffY);
  }

  void animate(BuildContext context, CardSwiperDirection direction) {
    switch (direction) {
      case CardSwiperDirection.left:
        return animateHorizontally(context, false);
      case CardSwiperDirection.right:
        return animateHorizontally(context, true);
      case CardSwiperDirection.top:
        return animateVertically(context, false);
      case CardSwiperDirection.bottom:
        return animateVertically(context, true);
      default:
        return;
    }
  }

  void animateHorizontally(BuildContext context, bool isToRight) {
    final screenWidth = MediaQuery.of(context).size.width;

    _leftAnimation = Tween<double>(
      begin: left,
      end: isToRight ? screenWidth : -screenWidth,
    ).animate(animationController);
    _topAnimation = Tween<double>(
      begin: top,
      end: top + top,
    ).animate(animationController);
    _scaleAnimation = Tween<double>(
      begin: scale,
      end: 1.0,
    ).animate(animationController);
    _differenceAnimation = Tween<Offset>(
      begin: difference,
      end: initialOffset,
    ).animate(animationController);
    animationController.forward();
  }

  void animateVertically(BuildContext context, bool isToBottom) {
    final screenHeight = MediaQuery.of(context).size.height;

    _leftAnimation = Tween<double>(
      begin: left,
      end: left + left,
    ).animate(animationController);
    _topAnimation = Tween<double>(
      begin: top,
      end: isToBottom ? screenHeight : -screenHeight,
    ).animate(animationController);
    _scaleAnimation = Tween<double>(
      begin: scale,
      end: 1.0,
    ).animate(animationController);
    _differenceAnimation = Tween<Offset>(
      begin: difference,
      end: initialOffset,
    ).animate(animationController);
    animationController.forward();
  }

  void animateBack(BuildContext context) {
    _leftAnimation = Tween<double>(
      begin: left,
      end: 0,
    ).animate(animationController);
    _topAnimation = Tween<double>(
      begin: top,
      end: 0,
    ).animate(animationController);
    _scaleAnimation = Tween<double>(
      begin: scale,
      end: initialScale,
    ).animate(animationController);
    _differenceAnimation = Tween<Offset>(
      begin: difference,
      end: Offset.zero,
    ).animate(animationController);
    animationController.forward();
  }

  void animateUndo(BuildContext context, CardSwiperDirection direction) {
    switch (direction) {
      case CardSwiperDirection.left:
        return animateUndoHorizontally(context, false);
      case CardSwiperDirection.right:
        return animateUndoHorizontally(context, true);
      case CardSwiperDirection.top:
        return animateUndoVertically(context, false);
      case CardSwiperDirection.bottom:
        return animateUndoVertically(context, true);
      default:
        return;
    }
  }

  void animateUndoHorizontally(BuildContext context, bool isToRight) {
    final size = MediaQuery.of(context).size;

    _leftAnimation = Tween<double>(
      begin: isToRight ? size.width : -size.width,
      end: 0,
    ).animate(animationController);
    _topAnimation = Tween<double>(
      begin: top,
      end: top + top,
    ).animate(animationController);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: scale,
    ).animate(animationController);
    _differenceAnimation = Tween<Offset>(
      begin: initialOffset,
      end: difference,
    ).animate(animationController);
    animationController.forward();
  }

  void animateUndoVertically(BuildContext context, bool isToBottom) {
    final size = MediaQuery.of(context).size;

    _leftAnimation = Tween<double>(
      begin: left,
      end: left + left,
    ).animate(animationController);
    _topAnimation = Tween<double>(
      begin: isToBottom ? -size.height : size.height,
      end: 0,
    ).animate(animationController);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: scale,
    ).animate(animationController);
    _differenceAnimation = Tween<Offset>(
      begin: initialOffset,
      end: difference,
    ).animate(animationController);
    animationController.forward();
  }
}
