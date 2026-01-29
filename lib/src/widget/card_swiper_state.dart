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

  int? _backgroundCardIndex;

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

  @override
  void didUpdateWidget(CardSwiper oldWidget) {
    super.didUpdateWidget(oldWidget);
    controllerSubscription?.cancel();
    controllerSubscription =
        widget.controller?.events.listen(_controllerListener);
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
    final Widget child = ConstrainedBox(
      constraints: constraints,
      child: widget.cardBuilder(
        context,
        _currentIndex!,
        (100 * _cardAnimation.left / widget.threshold).ceil(),
        (100 * _cardAnimation.top / widget.threshold).ceil(),
      ),
    );
    // Compute active direction & progress for overlay
    var activeDirection = CardSwiperDirection.none;
    double progress = 0;
    if (_cardAnimation.left.abs() > _cardAnimation.top.abs()) {
      if (_cardAnimation.left < 0) {
        activeDirection = CardSwiperDirection.left;
      } else if (_cardAnimation.left > 0) {
        activeDirection = CardSwiperDirection.right;
      }
      progress = (_cardAnimation.left.abs() / widget.threshold).clamp(0, 1);
    } else if (_cardAnimation.top.abs() > 0) {
      if (_cardAnimation.top < 0) {
        activeDirection = CardSwiperDirection.top;
      } else if (_cardAnimation.top > 0) {
        activeDirection = CardSwiperDirection.bottom;
      }
      progress = (_cardAnimation.top.abs() / widget.threshold).clamp(0, 1);
    }
    final overlay = widget.overlayBuilder?.call(
      context,
      _currentIndex!,
      activeDirection,
      progress,
    );
    // Overlay strategy:
    // 1. If null -> just card.
    // 2. If user returns Positioned -> we insert it directly in the Stack so it remains a direct child.
    // 3. Otherwise we wrap it with Positioned.fill to cover the card area.
    return Positioned(
      left: _cardAnimation.left,
      top: _cardAnimation.top,
      child: GestureDetector(
        child: Transform.rotate(
          angle: _cardAnimation.angle,
          child: overlay == null
              ? child
              : Stack(
                  clipBehavior: Clip.none,
                  children: [
                    child,
                    if (overlay is Positioned)
                      IgnorePointer(
                        child: _wrapOverlayOpacity(
                          overlay: overlay,
                          progress: progress,
                        ),
                      )
                    else
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: progress,
                            child: overlay,
                          ),
                        ),
                      ),
                  ],
                ),
        ),
        onTap: () async {
          if (widget.isDisabled) await widget.onTapDisabled?.call();
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
            setState(() {
              _cardAnimation.update(
                tapInfo.delta.dx,
                tapInfo.delta.dy,
                _tappedOnTop,
              );

              if (widget.showBackCardOnUndo) {
                final shouldShowPreviousCard = switch (widget.undoDirection) {
                  UndoDirection.left =>
                    _cardAnimation.left < -widget.undoSwipeThreshold,
                  UndoDirection.right =>
                    _cardAnimation.left > widget.undoSwipeThreshold,
                };

                if (shouldShowPreviousCard) {
                  _backgroundCardIndex =
                      _undoableIndex.previousState ?? getValidIndexOffset(-1);
                } else {
                  _backgroundCardIndex = _nextIndex;
                }
              }
            });
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

  Widget _wrapOverlayOpacity(
      {required Positioned overlay, required double progress}) {
    // Rebuild Positioned with its child wrapped in Opacity.
    return Positioned(
      key: overlay.key,
      left: overlay.left,
      top: overlay.top,
      right: overlay.right,
      bottom: overlay.bottom,
      width: overlay.width,
      height: overlay.height,
      child: Opacity(
        opacity: progress,
        child: overlay.child,
      ),
    );
  }

  Widget _backItem(BoxConstraints constraints, int index) {
    int? cardIndex;

    if (widget.showBackCardOnUndo && index == 1) {
      cardIndex = _backgroundCardIndex ?? getValidIndexOffset(index);
    } else {
      cardIndex = getValidIndexOffset(index);
    }

    if (cardIndex == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: (widget.backCardOffset.dy * index) - _cardAnimation.difference.dy,
      left: (widget.backCardOffset.dx * index) - _cardAnimation.difference.dx,
      child: Transform.scale(
        scale: _cardAnimation.scale - ((1 - widget.scale) * (index - 1)),
        child: ConstrainedBox(
          constraints: constraints,
          child: widget.cardBuilder(context, cardIndex, 0, 0),
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

    if (shouldCancelSwipe) return;

    _undoableIndex.state = _nextIndex;
    _directionHistory.add(_detectedDirection);

    if (isLastCard) widget.onEnd?.call();
  }

  void _reset() {
    onSwipeDirectionChanged(CardSwiperDirection.none);
    _detectedDirection = CardSwiperDirection.none;

    _backgroundCardIndex = null;

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

    if (shouldCancelUndo) return;

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
    if (widget.isLoop) return widget.numberOfCardsDisplayed;

    if (_currentIndex == null) return 0;

    return math.min(
      widget.numberOfCardsDisplayed,
      widget.cardsCount - _currentIndex!,
    );
  }

  int? getValidIndexOffset(int offset) {
    if (_currentIndex == null) return null;

    final index = _currentIndex! + offset;

    if (!widget.isLoop && !index.isBetween(0, widget.cardsCount - 1)) {
      return null;
    }

    final result = index % widget.cardsCount;
    return result < 0 ? result + widget.cardsCount : result;
  }

  Future<void> showSwipeOptionsDialog(
    CardSwiperDirection direction,
    Widget customDialog,
  ) async {
    // Animate the card back to its original position after the dialog is shown
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   // Add a delay before the card comes back
    //   await Future<void>.delayed(const Duration(seconds: 5));
    //   _cardAnimation.comeeBack(context);
    // });

    final result = await showDialog<String>(
      context: context,
      builder: (context) => customDialog,
    );
    // _cardAnimation.animateBack(context);
    if (result == 'Swipe') {
      _performSwipe(direction);
    } else if (result == 'Left-Swipe') {
      await Future<void>.delayed(Duration(seconds: widget.delay));
      _performSwipe(CardSwiperDirection.left);
    } else {
      _goBack();
    }
  }

  void _performSwipe(CardSwiperDirection direction) {
    if (_currentIndex == null) return;
    _swipeType = SwipeType.swipe;
    _detectedDirection = direction;
    _cardAnimation.animate(context, direction);
  }

  void _swipe(CardSwiperDirection direction) {
    if (direction == CardSwiperDirection.right && widget.showDialog) {
      _cardAnimation.animateToRight(context).then((_) {
        // Show the dialog after the card moves to the right
        showSwipeOptionsDialog(
          direction,
          widget.dialogBuilder ??
              AlertDialog(
                title: const Text('Select an option'),
                content: const Text('Do you want to swipe the card?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop('Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop('Swipe'),
                    child: const Text('Swipe'),
                  ),
                ],
              ),
        );
      });
    } else {
      _performSwipe(direction);
    }
  }
}
