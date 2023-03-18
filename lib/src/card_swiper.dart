import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_card_swiper/src/card_swiper_controller.dart';
import 'package:flutter_card_swiper/src/enums.dart';
import 'package:flutter_card_swiper/src/extensions.dart';
import 'package:flutter_card_swiper/src/typedefs.dart';

class CardSwiper<T extends Widget> extends StatefulWidget {
  /// widget builder for rendering cards
  final NullableIndexedWidgetBuilder cardBuilder;

  /// cards count
  final int cardsCount;

  /// controller to trigger actions
  final CardSwiperController? controller;

  /// duration of every animation
  final Duration duration;

  /// padding of the swiper
  final EdgeInsetsGeometry padding;

  /// maximum angle the card reaches while swiping
  final double maxAngle;

  /// threshold from which the card is swiped away
  final int threshold;

  /// scale of the card that is behind the front card
  final double scale;

  /// set to true if swiping should be disabled, exception: triggered from the outside
  final bool isDisabled;

  /// function that gets called with the new index and detected swipe direction when the user swiped or swipe is triggered by controller
  final CardSwiperOnSwipe? onSwipe;

  /// function that gets called when there is no widget left to be swiped away
  final CardSwiperOnEnd? onEnd;

  /// function that gets triggered when the swiper is disabled
  final CardSwiperOnTapDisabled? onTapDisabled;

  /// direction in which the card gets swiped when triggered by controller, default set to right
  final CardSwiperDirection direction;

  /// set to false if you want your card to move only across the vertical axis when swiping
  final bool isHorizontalSwipingEnabled;

  /// set to false if you want your card to move only across the horizontal axis when swiping
  final bool isVerticalSwipingEnabled;

  /// set to true if the stack should loop
  final bool isLoop;

  /// here you can change the number of cards that are displayed at the same time
  final int numberOfCardsDisplayed;

  const CardSwiper({
    Key? key,
    required this.cardBuilder,
    required this.cardsCount,
    this.controller,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
    this.duration = const Duration(milliseconds: 200),
    this.maxAngle = 30,
    this.threshold = 50,
    this.scale = 0.9,
    this.isDisabled = false,
    this.onTapDisabled,
    this.onSwipe,
    this.onEnd,
    this.direction = CardSwiperDirection.right,
    this.isHorizontalSwipingEnabled = true,
    this.isVerticalSwipingEnabled = true,
    this.isLoop = true,
    this.numberOfCardsDisplayed = 2,
  })  : assert(
          maxAngle >= 0 && maxAngle <= 360,
          'maxAngle must be between 0 and 360',
        ),
        assert(
          threshold >= 1 && threshold <= 100,
          'threshold must be between 1 and 100',
        ),
        assert(
          direction != CardSwiperDirection.none,
          'direction must not be none',
        ),
        assert(
          scale >= 0 && scale <= 1,
          'scale must be between 0 and 1',
        ),
        assert(
          numberOfCardsDisplayed >= 1 && numberOfCardsDisplayed <= cardsCount,
          'you must display at least one card, and no more than the length of cards parameter',
        ),
        super(key: key);

  @override
  State createState() => _CardSwiperState<T>();
}

class _CardSwiperState<T extends Widget> extends State<CardSwiper<T>>
    with SingleTickerProviderStateMixin {
  double _left = 0;
  double _top = 0;
  double _total = 0;
  double _angle = 0;
  late double _scale = widget.scale;
  double _difference = 40;

  SwipeType _swipeType = SwipeType.none;
  bool _tapOnTop = false; //position of starting drag point on card

  late AnimationController _animationController;
  late Animation<double> _leftAnimation;
  late Animation<double> _topAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _differenceAnimation;

  CardSwiperDirection detectedDirection = CardSwiperDirection.none;

  double get _maxAngle => widget.maxAngle * (pi / 180);

  int? _currentIndex = 0;
  bool get _canSwipe => _currentIndex != null && !widget.isDisabled;

  int? get _nextIndex {
    if (_currentIndex == null) {
      return null;
    }
    return convertToValidIndex(_currentIndex! + 1);
  }

  int? convertToValidIndex(int index) {
    if (!widget.isLoop && !index.isBetween(0, widget.cardsCount)) {
      return null;
    }
    return index % widget.cardsCount;
  }

  @override
  void initState() {
    super.initState();

    widget.controller?.addListener(_controllerListener);

    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )
      ..addListener(_animationListener)
      ..addStatusListener(_animationStatusListener);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    widget.controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Padding(
          padding: widget.padding,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: List.generate(nbOfCardsOnScreen(), (index) {
                  if (index == 0) {
                    return _frontItem(constraints);
                  }

                  return _backItem(
                    constraints,
                    index,
                  );
                }).reversed.toList(),
              );
            },
          ),
        );
      },
    );
  }

  ///the number of cards that are built on the screen
  int nbOfCardsOnScreen() {
    if (widget.isLoop) {
      return widget.numberOfCardsDisplayed;
    }

    return min(
      widget.numberOfCardsDisplayed,
      widget.cardsCount - _currentIndex! + 1,
    );
  }

  /// The card shown at the front of the stack, that can be dragged and swipped
  Widget _frontItem(BoxConstraints constraints) {
    if (_currentIndex == null) {
      return const SizedBox();
    }

    return Positioned(
      left: _left,
      top: _top,
      child: GestureDetector(
        child: Transform.rotate(
          angle: _angle,
          child: ConstrainedBox(
            constraints: constraints,
            child: widget.cardBuilder(context, _currentIndex!),
          ),
        ),
        onTap: () {
          if (widget.isDisabled) {
            widget.onTapDisabled?.call();
          }
        },
        onPanStart: (tapInfo) {
          if (!widget.isDisabled) {
            final renderBox = context.findRenderObject()! as RenderBox;
            final position = renderBox.globalToLocal(tapInfo.globalPosition);

            if (position.dy < renderBox.size.height / 2) _tapOnTop = true;
          }
        },
        onPanUpdate: (tapInfo) {
          if (!widget.isDisabled) {
            setState(() {
              if (widget.isHorizontalSwipingEnabled) {
                _left += tapInfo.delta.dx;
              }
              if (widget.isVerticalSwipingEnabled) {
                _top += tapInfo.delta.dy;
              }
              _total = _left + _top;
              _calculateAngle();
              _calculateScale();
              _calculateDifference();
            });
          }
        },
        onPanEnd: (tapInfo) {
          if (_canSwipe) {
            _tapOnTop = false;
            _onEndAnimation();
            _animationController.forward();
          }
        },
      ),
    );
  }

  /// if widget.numberOfCardsDisplayed > 2, those cards are built behind the
  /// _secondItem and can't move at all
  Widget _backItem(BoxConstraints constraints, int offset) {
    final index = convertToValidIndex(_currentIndex! + offset);
    if (index == null) {
      return const SizedBox();
    }

    return Positioned(
      top: offset == 1 ? _difference : 40,
      left: 0,
      child: Transform.scale(
        scale: widget.scale,
        child: ConstrainedBox(
          constraints: constraints,
          child: widget.cardBuilder(
            context,
            index,
          ),
        ),
      ),
    );
  }

  //swipe widget from the outside
  void _controllerListener() {
    switch (widget.controller!.state) {
      case CardSwiperState.swipe:
        _swipe(context, widget.direction);
        break;
      case CardSwiperState.swipeLeft:
        _swipe(context, CardSwiperDirection.left);
        break;
      case CardSwiperState.swipeRight:
        _swipe(context, CardSwiperDirection.right);
        break;
      case CardSwiperState.swipeTop:
        _swipe(context, CardSwiperDirection.top);
        break;
      case CardSwiperState.swipeBottom:
        _swipe(context, CardSwiperDirection.bottom);
        break;
      default:
        break;
    }
  }

  //when value of controller changes
  void _animationListener() {
    if (_animationController.status == AnimationStatus.forward) {
      setState(() {
        _left = _leftAnimation.value;
        _top = _topAnimation.value;
        _scale = _scaleAnimation.value;
        _difference = _differenceAnimation.value;
      });
    }
  }

  //when the status of animation changes
  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        if (_swipeType == SwipeType.swipe) {
          final previousIndex = _currentIndex;
          final isLastCard = _currentIndex == widget.cardsCount - 1;

          _currentIndex = _nextIndex;
          widget.onSwipe?.call(
            previousIndex,
            _currentIndex,
            detectedDirection,
          );

          if (isLastCard) {
            widget.onEnd?.call();
          }
        }
        _animationController.reset();
        _left = 0;
        _top = 0;
        _total = 0;
        _angle = 0;
        _scale = widget.scale;
        _difference = 40;
        _swipeType = SwipeType.none;
      });
    }
  }

  void _calculateAngle() {
    if (_angle <= _maxAngle && _angle >= -_maxAngle) {
      _angle = (_maxAngle / 100) * (_left / 10);
      if (_tapOnTop) _angle *= -1;
    }
  }

  void _calculateScale() {
    if (_scale <= 1.0 && _scale >= widget.scale) {
      _scale = (_total > 0)
          ? widget.scale + (_total / 5000)
          : widget.scale + -1 * (_total / 5000);
    }
  }

  void _calculateDifference() {
    if (_difference >= 0 && _difference <= _difference) {
      _difference = (_total > 0) ? 40 - (_total / 10) : 40 + (_total / 10);
    }
  }

  void _onEndAnimation() {
    if (_left < -widget.threshold || _left > widget.threshold) {
      _swipeHorizontal(context);
    } else if (_top < -widget.threshold || _top > widget.threshold) {
      _swipeVertical(context);
    } else {
      _goBack(context);
    }
  }

  void _swipe(BuildContext context, CardSwiperDirection direction) {
    if (!_canSwipe) return;

    switch (direction) {
      case CardSwiperDirection.left:
        _left = -1;
        _swipeHorizontal(context);
        break;
      case CardSwiperDirection.right:
        _left = widget.threshold + 1;
        _swipeHorizontal(context);
        break;
      case CardSwiperDirection.top:
        _top = -1;
        _swipeVertical(context);
        break;
      case CardSwiperDirection.bottom:
        _top = widget.threshold + 1;
        _swipeVertical(context);
        break;
      default:
        break;
    }
    _animationController.forward();
  }

  //moves the card away to the left or right
  void _swipeHorizontal(BuildContext context) {
    _leftAnimation = Tween<double>(
      begin: _left,
      end: (_left == 0 && widget.direction == CardSwiperDirection.right) ||
              _left > widget.threshold
          ? MediaQuery.of(context).size.width
          : -MediaQuery.of(context).size.width,
    ).animate(_animationController);
    _topAnimation = Tween<double>(
      begin: _top,
      end: _top + _top,
    ).animate(_animationController);
    _scaleAnimation = Tween<double>(
      begin: _scale,
      end: 1.0,
    ).animate(_animationController);
    _differenceAnimation = Tween<double>(
      begin: _difference,
      end: 0,
    ).animate(_animationController);

    _swipeType = SwipeType.swipe;
    if (_left > widget.threshold ||
        _left == 0 && widget.direction == CardSwiperDirection.right) {
      detectedDirection = CardSwiperDirection.right;
    } else {
      detectedDirection = CardSwiperDirection.left;
    }
  }

  //moves the card away to the top or bottom
  void _swipeVertical(BuildContext context) {
    _leftAnimation = Tween<double>(
      begin: _left,
      end: _left + _left,
    ).animate(_animationController);
    _topAnimation = Tween<double>(
      begin: _top,
      end: (_top == 0 && widget.direction == CardSwiperDirection.bottom) ||
              _top > widget.threshold
          ? MediaQuery.of(context).size.height
          : -MediaQuery.of(context).size.height,
    ).animate(_animationController);
    _scaleAnimation = Tween<double>(
      begin: _scale,
      end: 1.0,
    ).animate(_animationController);
    _differenceAnimation = Tween<double>(
      begin: _difference,
      end: 0,
    ).animate(_animationController);

    _swipeType = SwipeType.swipe;
    if (_top > widget.threshold ||
        _top == 0 && widget.direction == CardSwiperDirection.bottom) {
      detectedDirection = CardSwiperDirection.bottom;
    } else {
      detectedDirection = CardSwiperDirection.top;
    }
  }

  //moves the card back to starting position
  void _goBack(BuildContext context) {
    _leftAnimation = Tween<double>(
      begin: _left,
      end: 0,
    ).animate(_animationController);
    _topAnimation = Tween<double>(
      begin: _top,
      end: 0,
    ).animate(_animationController);
    _scaleAnimation = Tween<double>(
      begin: _scale,
      end: widget.scale,
    ).animate(_animationController);
    _differenceAnimation = Tween<double>(
      begin: _difference,
      end: 40,
    ).animate(_animationController);

    _swipeType = SwipeType.back;
  }
}
