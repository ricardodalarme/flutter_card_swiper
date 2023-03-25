import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_card_swiper/src/card_swiper_controller.dart';
import 'package:flutter_card_swiper/src/enums.dart';
import 'package:flutter_card_swiper/src/extensions.dart';
import 'package:flutter_card_swiper/src/typedefs.dart';

class CardSwiper extends StatefulWidget {
  /// Function that builds each card in the stack.
  ///
  /// The [int] parameter specifies the index of the card to build, and the [BuildContext]
  /// parameter provides the build context. The function should return a widget that represents
  /// the card at the given index. It can return `null`, which will result in an
  /// empty card being displayed.
  final NullableIndexedWidgetBuilder cardBuilder;

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

  /// The direction in which the card is swiped when triggered by the [controller].
  ///
  /// Defaults to [CardSwiperDirection.right].
  final CardSwiperDirection direction;

  /// A boolean value that determines whether the card can be swiped horizontally. The default value is true.
  final bool isHorizontalSwipingEnabled;

  /// A boolean value that determines whether the card can be swiped vertically. The default value is true.
  final bool isVerticalSwipingEnabled;

  /// A boolean value that determines whether the card stack should loop. When the last card is swiped,
  /// if isLoop is true, the first card will become the last card again. The default value is true.
  final bool isLoop;

  /// An integer that determines the number of cards that are displayed at the same time.
  /// The default value is 2. Note that you must display at least one card, and no more than the [cardsCount] parameter.
  final int numberOfCardsDisplayed;

  const CardSwiper({
    Key? key,
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
        assert(
          initialIndex >= 0 && initialIndex < cardsCount,
          'initialIndex must be between 0 and cardsCount',
        ),
        super(key: key);

  @override
  State createState() => _CardSwiperState();
}

class _CardSwiperState<T extends Widget> extends State<CardSwiper>
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

  int? _currentIndex;

  int? get _nextIndex => getValidIndexOffset(1);

  bool get _canSwipe => _currentIndex != null && !widget.isDisabled;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex;

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
                  if (index == 1) {
                    return _secondItem(constraints);
                  }
                  return _backItem(constraints, index);
                }).reversed.toList(),
              );
            },
          ),
        );
      },
    );
  }

  /// The card shown at the front of the stack, that can be dragged and swipped
  Widget _frontItem(BoxConstraints constraints) {
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

  /// the card that is just behind the _frontItem, only moves to take its place
  /// during a movement of _frontItem
  Widget _secondItem(BoxConstraints constraints) {
    return Positioned(
      top: _difference,
      left: 0,
      child: Transform.scale(
        scale: _scale,
        child: ConstrainedBox(
          constraints: constraints,
          child: widget.cardBuilder(context, _nextIndex!),
        ),
      ),
    );
  }

  /// if widget.numberOfCardsDisplayed > 2, those cards are built behind the
  /// _secondItem and can't move at all
  Widget _backItem(BoxConstraints constraints, int offset) {
    return Positioned(
      top: 40,
      left: 0,
      child: Transform.scale(
        scale: widget.scale,
        child: ConstrainedBox(
          constraints: constraints,
          child: widget.cardBuilder(
            context,
            getValidIndexOffset(offset)!,
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

  // handle the onSwipe methode as well as removing the current card from the
  // stack if onSwipe does not return false
  void _handleOnSwipe() {
    setState(() {
      if (_swipeType == SwipeType.swipe) {
        final shouldCancelSwipe = widget.onSwipe
                ?.call(_currentIndex, _nextIndex, detectedDirection) ==
            false;

        if (shouldCancelSwipe) {
          return;
        }

        _currentIndex = _nextIndex;

        final isLastCard = _currentIndex == widget.cardsCount - 1;
        if (isLastCard) {
          widget.onEnd?.call();
        }
      }
    });
  }

  // reset the card animation
  void _resetCardAnimation() {
    setState(() {
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

  //when the status of animation changes
  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _handleOnSwipe();
      _resetCardAnimation();
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

  ///the number of cards that are built on the screen
  int nbOfCardsOnScreen() {
    if (widget.isLoop) {
      return widget.numberOfCardsDisplayed;
    }
    if (_currentIndex == null) {
      return 0;
    }

    return min(
      widget.numberOfCardsDisplayed,
      widget.cardsCount - _currentIndex!,
    );
  }

  int? getValidIndexOffset(int offset) {
    if (_currentIndex == null) {
      return null;
    }

    final index = _currentIndex! + offset;
    if (!widget.isLoop && !index.isBetween(0, widget.cardsCount)) {
      return null;
    }
    return index % widget.cardsCount;
  }
}
