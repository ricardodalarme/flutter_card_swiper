part of 'card_swiper.dart';

class _CardSwiperState<T extends Widget> extends State<CardSwiper>
    with SingleTickerProviderStateMixin {
  late CardAnimation _cardAnimation;
  late AnimationController _animationController;

  SwipeType _swipeType = SwipeType.none;
  CardSwiperDirection _detectedDirection = CardSwiperDirection.none;
  CardSwiperDirection _detectedHorizontalDirection = CardSwiperDirection.none;
  CardSwiperDirection _detectedVerticalDirection = CardSwiperDirection.none;
  bool _tappedOnTop = false;

  final _undoableIndex = Undoable<int?>(null);
  final Queue<CardSwiperDirection> _directionHistory = Queue();

  int? get _currentIndex => _undoableIndex.state;

  int? get _nextIndex => getValidIndexOffset(1);

  bool get _canSwipe => _currentIndex != null && !widget.isDisabled;

  StreamSubscription<ControllerEvent>? controllerSubscription;

  @override
  void initState() {
    super.initState();

    _undoableIndex.state = widget.initialIndex;

    controllerSubscription =
        widget.controller?.events.listen(_controllerListener);

    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )
      ..addListener(_animationListener)
      ..addStatusListener(_animationStatusListener);

    _cardAnimation = CardAnimation(
      animationController: _animationController,
      maxAngle: widget.maxAngle,
      initialScale: widget.scale,
      allowedSwipeDirection: widget.allowedSwipeDirection,
      initialOffset: widget.backCardOffset,
      onSwipeDirectionChanged: onSwipeDirectionChanged,
    );
  }

  void onSwipeDirectionChanged(CardSwiperDirection direction) {
    switch (direction) {
      case CardSwiperDirection.none:
        _detectedVerticalDirection = direction;
        _detectedHorizontalDirection = direction;
      case CardSwiperDirection.right:
      case CardSwiperDirection.left:
        _detectedHorizontalDirection = direction;
      case CardSwiperDirection.top:
      case CardSwiperDirection.bottom:
        _detectedVerticalDirection = direction;
    }

    widget.onSwipeDirectionChange
        ?.call(_detectedHorizontalDirection, _detectedVerticalDirection);
  }

  @override
  void dispose() {
    _animationController.dispose();
    controllerSubscription?.cancel();
    super.dispose();
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
                children: List.generate(numberOfCardsOnScreen(), (index) {
                  if (index == 0) return _frontItem(constraints);
                  return _backItem(constraints, index);
                }).reversed.toList(),
              );
            },
          ),
        );
      },
    );
  }

  Widget _frontItem(BoxConstraints constraints) {
    return Positioned(
      left: _cardAnimation.left,
      top: _cardAnimation.top,
      child: GestureDetector(
        child: Transform.rotate(
          angle: _cardAnimation.angle,
          child: ConstrainedBox(
            constraints: constraints,
            child: widget.cardBuilder(
              context,
              _currentIndex!,
              (100 * _cardAnimation.left / widget.threshold).ceil(),
              (100 * _cardAnimation.top / widget.threshold).ceil(),
            ),
          ),
        ),
        onTap: () async {
          if (widget.isDisabled) {
            await widget.onTapDisabled?.call();
          }
          await widget.onTap?.call(_currentIndex!);
        },
        onPanStart: (tapInfo) {
          if (!widget.isDisabled) {
            final renderBox = context.findRenderObject()! as RenderBox;
            final position = renderBox.globalToLocal(tapInfo.globalPosition);

            if (position.dy < renderBox.size.height / 2) _tappedOnTop = true;
          }
        },
        onPanUpdate: (tapInfo) {
          if (!widget.isDisabled) {
            setState(
              () => _cardAnimation.update(
                tapInfo.delta.dx,
                tapInfo.delta.dy,
                _tappedOnTop,
              ),
            );
          }
        },
        onPanEnd: (tapInfo) {
          if (_canSwipe) {
            _tappedOnTop = false;
            _onEndAnimation();
          }
        },
      ),
    );
  }

  Widget _backItem(BoxConstraints constraints, int index) {
    return Positioned(
      top: (widget.backCardOffset.dy * index) - _cardAnimation.difference.dy,
      left: (widget.backCardOffset.dx * index) - _cardAnimation.difference.dx,
      child: Transform.scale(
        scale: _cardAnimation.scale - ((1 - widget.scale) * (index - 1)),
        child: ConstrainedBox(
          constraints: constraints,
          child: widget.cardBuilder(context, getValidIndexOffset(index)!, 0, 0),
        ),
      ),
    );
  }

  void _controllerListener(ControllerEvent event) {
    return switch (event) {
      ControllerSwipeEvent(:final direction) => _swipe(direction),
      ControllerUndoEvent() => _undo(),
      ControllerMoveEvent(:final index) => _moveTo(index),
    };
  }

  void _animationListener() {
    if (_animationController.status == AnimationStatus.forward) {
      setState(_cardAnimation.sync);
    }
  }

  Future<void> _animationStatusListener(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      switch (_swipeType) {
        case SwipeType.swipe:
          await _handleCompleteSwipe();
        default:
          break;
      }

      _reset();
    }
  }

  Future<void> _handleCompleteSwipe() async {
    final isLastCard = _currentIndex! == widget.cardsCount - 1;
    final shouldCancelSwipe = await widget.onSwipe
            ?.call(_currentIndex!, _nextIndex, _detectedDirection) ==
        false;

    if (shouldCancelSwipe) {
      return;
    }

    _undoableIndex.state = _nextIndex;
    _directionHistory.add(_detectedDirection);

    if (isLastCard) {
      widget.onEnd?.call();
    }
  }

  void _reset() {
    onSwipeDirectionChanged(CardSwiperDirection.none);
    _detectedDirection = CardSwiperDirection.none;
    setState(() {
      _animationController.reset();
      _cardAnimation.reset();
      _swipeType = SwipeType.none;
    });
  }

  void _onEndAnimation() {
    final direction = _getEndAnimationDirection();
    final isValidDirection = _isValidDirection(direction);

    if (isValidDirection) {
      _swipe(direction);
    } else {
      _goBack();
    }
  }

  CardSwiperDirection _getEndAnimationDirection() {
    if (_cardAnimation.left.abs() > widget.threshold) {
      return _cardAnimation.left.isNegative
          ? CardSwiperDirection.left
          : CardSwiperDirection.right;
    }
    if (_cardAnimation.top.abs() > widget.threshold) {
      return _cardAnimation.top.isNegative
          ? CardSwiperDirection.top
          : CardSwiperDirection.bottom;
    }
    return CardSwiperDirection.none;
  }

  bool _isValidDirection(CardSwiperDirection direction) {
    return switch (direction) {
      CardSwiperDirection.left => widget.allowedSwipeDirection.left,
      CardSwiperDirection.right => widget.allowedSwipeDirection.right,
      CardSwiperDirection.top => widget.allowedSwipeDirection.up,
      CardSwiperDirection.bottom => widget.allowedSwipeDirection.down,
      _ => false
    };
  }

  void _swipe(CardSwiperDirection direction) {
    if (_currentIndex == null) return;
    _swipeType = SwipeType.swipe;
    _detectedDirection = direction;
    _cardAnimation.animate(context, direction);
  }

  void _goBack() {
    _swipeType = SwipeType.back;
    _cardAnimation.animateBack(context);
  }

  void _undo() {
    if (_directionHistory.isEmpty) return;
    if (_undoableIndex.previousState == null) return;

    final direction = _directionHistory.last;
    final shouldCancelUndo = widget.onUndo?.call(
          _currentIndex,
          _undoableIndex.previousState!,
          direction,
        ) ==
        false;

    if (shouldCancelUndo) {
      return;
    }

    _undoableIndex.undo();
    _directionHistory.removeLast();
    _swipeType = SwipeType.undo;
    _cardAnimation.animateUndo(context, direction);
  }

  void _moveTo(int index) {
    if (index == _currentIndex) return;
    if (index < 0 || index >= widget.cardsCount) return;

    setState(() {
      _undoableIndex.state = index;
    });
  }

  int numberOfCardsOnScreen() {
    if (widget.isLoop) {
      return widget.numberOfCardsDisplayed;
    }
    if (_currentIndex == null) {
      return 0;
    }

    return math.min(
      widget.numberOfCardsDisplayed,
      widget.cardsCount - _currentIndex!,
    );
  }

  int? getValidIndexOffset(int offset) {
    if (_currentIndex == null) {
      return null;
    }

    final index = _currentIndex! + offset;
    if (!widget.isLoop && !index.isBetween(0, widget.cardsCount - 1)) {
      return null;
    }
    return index % widget.cardsCount;
  }
}
