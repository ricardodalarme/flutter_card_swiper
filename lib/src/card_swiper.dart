import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/src/card_swiper_controller.dart';
import 'package:flutter_card_swiper/src/enums.dart';
import 'package:flutter_card_swiper/src/typedefs.dart';

class CardSwiper extends StatefulWidget {
  /// list of widgets for the swiper
  final List<Widget?> cards;

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

  const CardSwiper({
    Key? key,
    required this.cards,
    this.controller,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
    this.duration = const Duration(milliseconds: 200),
    this.maxAngle = 30,
    this.threshold = 50,
    this.isDisabled = false,
    this.onTapDisabled,
    this.onSwipe,
    this.onEnd,
    this.direction = CardSwiperDirection.right,
  })  : assert(maxAngle >= 0 && maxAngle <= 360),
        assert(threshold >= 1 && threshold <= 100),
        assert(direction != CardSwiperDirection.none),
        super(key: key);

  @override
  State createState() => _CardSwiperState();
}

class _CardSwiperState extends State<CardSwiper>
    with SingleTickerProviderStateMixin {
  double _left = 0;
  double _top = 0;
  double _total = 0;
  double _angle = 0;
  double _maxAngle = 0;
  double _scale = 0.9;
  double _difference = 40;

  int _currentIndex = 0;

  SwipeType _swipeTyp = SwipeType.none;
  bool _tapOnTop = false; //position of starting drag point on card

  late AnimationController _animationController;
  late Animation<double> _leftAnimation;
  late Animation<double> _topAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _differenceAnimation;

  CardSwiperDirection detectedDirection = CardSwiperDirection.none;

  bool get _isLastCard => _currentIndex == widget.cards.length - 1;
  int get _nextCardIndex => _isLastCard ? 0 : _currentIndex + 1;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      //swipe widget from the outside
      widget.controller!.addListener(() {
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
      });
    }

    if (widget.maxAngle > 0) {
      _maxAngle = widget.maxAngle * (pi / 180);
    }

    _animationController =
        AnimationController(duration: widget.duration, vsync: this);
    _animationController.addListener(() {
      //when value of controller changes
      if (_animationController.status == AnimationStatus.forward) {
        setState(() {
          _left = _leftAnimation.value;
          _top = _topAnimation.value;
          _scale = _scaleAnimation.value;
          _difference = _differenceAnimation.value;
        });
      }
    });

    _animationController.addStatusListener((status) {
      //when status of controller changes
      if (status == AnimationStatus.completed) {
        setState(() {
          if (_swipeTyp == SwipeType.swipe) {
            widget.onSwipe?.call(_currentIndex, detectedDirection);

            if (_isLastCard) {
              widget.onEnd?.call();
              _currentIndex = 0;
            } else {
              _currentIndex++;
            }
          }
          _animationController.reset();
          _left = 0;
          _top = 0;
          _total = 0;
          _angle = 0;
          _scale = 0.9;
          _difference = 40;
          _swipeTyp = SwipeType.none;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
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
                  children: [
                    _backItem(constraints, _nextCardIndex),
                    _frontItem(constraints, _currentIndex)
                  ]);
            },
          ),
        );
      },
    );
  }

  Widget _frontItem(BoxConstraints constraints, int index) {
    return Positioned(
      left: _left,
      top: _top,
      child: GestureDetector(
        child: Transform.rotate(
          angle: _angle,
          child: ConstrainedBox(
            constraints: constraints,
            child: widget.cards[index],
          ),
        ),
        onTap: () {
          if (widget.isDisabled) {
            widget.onTapDisabled?.call();
          }
        },
        onPanStart: (tapInfo) {
          if (!widget.isDisabled) {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            Offset position = renderBox.globalToLocal(tapInfo.globalPosition);

            if (position.dy < renderBox.size.height / 2) _tapOnTop = true;
          }
        },
        onPanUpdate: (tapInfo) {
          if (!widget.isDisabled) {
            setState(() {
              _left += tapInfo.delta.dx;
              _top += tapInfo.delta.dy;
              _total = _left + _top;
              _calculateAngle();
              _calculateScale();
              _calculateDifference();
            });
          }
        },
        onPanEnd: (tapInfo) {
          if (!widget.isDisabled) {
            _tapOnTop = false;
            _onEndAnimation();
            _animationController.forward();
          }
        },
      ),
    );
  }

  Widget _backItem(BoxConstraints constraints, int index) {
    return Positioned(
      top: _difference,
      left: 0,
      child: Transform.scale(
        scale: _scale,
        child: ConstrainedBox(
          constraints: constraints,
          child: widget.cards[index],
        ),
      ),
    );
  }

  void _calculateAngle() {
    if (_angle <= _maxAngle && _angle >= -_maxAngle) {
      (_tapOnTop)
          ? _angle = (_maxAngle / 100) * (_left / 10)
          : _angle = (_maxAngle / 100) * (_left / 10) * -1;
    }
  }

  void _calculateScale() {
    if (_scale <= 1.0 && _scale >= 0.9) {
      _scale =
          (_total > 0) ? 0.9 + (_total / 5000) : 0.9 + -1 * (_total / 5000);
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

  //moves the card away to the left or right
  void _swipeHorizontal(BuildContext context) {
    setState(() {
      _swipeTyp = SwipeType.swipe;
      _leftAnimation = Tween<double>(
        begin: _left,
        end: (_left == 0)
            ? (widget.direction == CardSwiperDirection.right)
                ? MediaQuery.of(context).size.width
                : -MediaQuery.of(context).size.width
            : (_left > widget.threshold)
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
    });
    if (_left > widget.threshold ||
        _left == 0 && widget.direction == CardSwiperDirection.right) {
      detectedDirection = CardSwiperDirection.right;
    } else {
      detectedDirection = CardSwiperDirection.left;
    }
  }

  void _swipe(BuildContext context, CardSwiperDirection direction) {
    if (widget.cards.isEmpty) return;

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

  //moves the card away to the top or bottom
  void _swipeVertical(BuildContext context) {
    setState(() {
      _swipeTyp = SwipeType.swipe;
      _leftAnimation = Tween<double>(
        begin: _left,
        end: _left + _left,
      ).animate(_animationController);
      _topAnimation = Tween<double>(
        begin: _top,
        end: (_top == 0)
            ? (widget.direction == CardSwiperDirection.bottom)
                ? MediaQuery.of(context).size.height
                : -MediaQuery.of(context).size.height
            : (_top > widget.threshold)
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
    });
    if (_top > widget.threshold ||
        _top == 0 && widget.direction == CardSwiperDirection.bottom) {
      detectedDirection = CardSwiperDirection.bottom;
    } else {
      detectedDirection = CardSwiperDirection.top;
    }
  }

  //moves the card back to starting position
  void _goBack(BuildContext context) {
    setState(() {
      _swipeTyp = SwipeType.back;
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
        end: 0.9,
      ).animate(_animationController);
      _differenceAnimation = Tween<double>(
        begin: _difference,
        end: 40,
      ).animate(_animationController);
    });
  }
}
