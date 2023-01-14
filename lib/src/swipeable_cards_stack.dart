library swipeable_cards_stack;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:swipeable_cards_stack/src/cards_animation.dart';
import 'package:swipeable_cards_stack/src/swipeable_cards_stack_controller.dart';

const List<Alignment> cardsAlign = [
  Alignment(0.0, 1.0),
  Alignment(0.0, 0.8),
  Alignment(0.0, 0.0)
];
final List<Size> cardsSize = List.filled(3, const Size(1, 1));

class SwipeableCardsStack extends StatefulWidget {
  final SwipeableCardsStackController? cardController;

  //First 3 widgets
  final List<Widget> items;
  final Function? onCardSwiped;
  final double cardWidthTopMul;
  final double cardWidthMiddleMul;
  final double cardWidthBottomMul;
  final double cardHeightTopMul;
  final double cardHeightMiddleMul;
  final double cardHeightBottomMul;
  final Function? appendItemCallback;
  final bool enableSwipeUp;
  final bool enableSwipeDown;
  final bool enableSwipeLeft;
  final bool enableSwipeRight;

  SwipeableCardsStack({
    Key? key,
    this.cardController,
    required BuildContext context,
    required this.items,
    this.onCardSwiped,
    this.cardWidthTopMul = 0.9,
    this.cardWidthMiddleMul = 0.85,
    this.cardWidthBottomMul = 0.8,
    this.cardHeightTopMul = 0.6,
    this.cardHeightMiddleMul = 0.55,
    this.cardHeightBottomMul = 0.5,
    this.appendItemCallback,
    this.enableSwipeUp = true,
    this.enableSwipeDown = true,
    this.enableSwipeLeft = true,
    this.enableSwipeRight = true,
  }) : super(key: key) {
    cardsSize[0] = Size(
      MediaQuery.of(context).size.width * cardWidthTopMul,
      MediaQuery.of(context).size.height * cardHeightTopMul,
    );
    cardsSize[1] = Size(
      MediaQuery.of(context).size.width * cardWidthMiddleMul,
      MediaQuery.of(context).size.height * cardHeightMiddleMul,
    );
    cardsSize[2] = Size(
      MediaQuery.of(context).size.width * cardWidthBottomMul,
      MediaQuery.of(context).size.height * cardHeightBottomMul,
    );
  }

  @override
  State<SwipeableCardsStack> createState() => _SwipeableCardsStackState();
}

class _SwipeableCardsStackState extends State<SwipeableCardsStack>
    with SingleTickerProviderStateMixin {
  int cardsCounter = 0;
  int index = 0;
  Widget? appendCard;

  List<Widget?> cards = [];
  late AnimationController _controller;
  bool enableSwipe = true;

  final Alignment defaultFrontCardAlign = const Alignment(0.0, 0.0);
  Alignment frontCardAlign = cardsAlign[2];
  double frontCardRot = 0.0;

  void _triggerSwipe(AxisDirection dir) {
    final swipedCallback = widget.onCardSwiped ?? (_, __, ___) => true;
    bool? shouldAnimate = false;
    if (dir == AxisDirection.left) {
      shouldAnimate = swipedCallback(AxisDirection.left, index, cards[0]);
      frontCardAlign = const Alignment(-0.001, 0.0);
    } else if (dir == AxisDirection.right) {
      shouldAnimate = swipedCallback(AxisDirection.right, index, cards[0]);
      frontCardAlign = const Alignment(0.001, 0.0);
    } else if (dir == AxisDirection.up) {
      shouldAnimate = swipedCallback(AxisDirection.up, index, cards[0]);
      frontCardAlign = const Alignment(0.0, -0.001);
    } else if (dir == AxisDirection.down) {
      shouldAnimate = swipedCallback(AxisDirection.down, index, cards[0]);
      frontCardAlign = const Alignment(0.0, 0.001);
    }

    shouldAnimate ??= true;

    if (shouldAnimate) {
      animateCards();
    }
  }

  void _appendItem(Widget newCard) {
    appendCard = newCard;
  }

  void _enableSwipe(bool isSwipeEnabled) {
    setState(() {
      enableSwipe = isSwipeEnabled;
    });
  }

  @override
  void initState() {
    super.initState();

    final cardController = widget.cardController;
    if (cardController != null) {
      cardController.listener = _triggerSwipe;
      cardController.addItem = _appendItem;
      cardController.enableSwipeListener = _enableSwipe;
    }

    // Init cards
    for (cardsCounter = 0; cardsCounter < 3; cardsCounter++) {
      if (widget.items.isNotEmpty && cardsCounter < widget.items.length) {
        cards.add(widget.items[cardsCounter]);
      } else {
        cards.add(null);
      }
    }

    frontCardAlign = cardsAlign[2];

    // Init the animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) changeCardsOrder();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IgnorePointer(
        ignoring: !enableSwipe,
        child: Stack(
          children: <Widget>[
            if (cards[2] != null) backCard(),
            if (cards[1] != null) middleCard(),
            if (cards[0] != null) frontCard(),
            // Prevent swiping if the cards are animating
            if (_controller.status != AnimationStatus.forward)
              SizedBox.expand(
                child: GestureDetector(
                  // While dragging the first card
                  onPanUpdate: (DragUpdateDetails details) {
                    // Add what the user swiped in the last frame to the alignment of the card
                    setState(() {
                      frontCardAlign = Alignment(
                        frontCardAlign.x +
                            20 *
                                details.delta.dx /
                                MediaQuery.of(context).size.width,
                        frontCardAlign.y +
                            20 *
                                details.delta.dy /
                                MediaQuery.of(context).size.height,
                      );

                      frontCardRot = frontCardAlign.x; // * rotation speed;
                    });
                  },
                  // When releasing the first card
                  onPanEnd: (_) {
                    // If the front card was swiped far enough to count as swiped
                    final onCardSwiped =
                        widget.onCardSwiped ?? (_, __, ___) => true;
                    bool? shouldAnimate = false;
                    if (frontCardAlign.x > 3.0 && widget.enableSwipeRight) {
                      shouldAnimate =
                          onCardSwiped(AxisDirection.right, index, cards[0]);
                    } else if (frontCardAlign.x < -3.0 &&
                        widget.enableSwipeLeft) {
                      shouldAnimate =
                          onCardSwiped(AxisDirection.left, index, cards[0]);
                    } else if (frontCardAlign.y < -3.0 &&
                        widget.enableSwipeUp) {
                      shouldAnimate =
                          onCardSwiped(AxisDirection.up, index, cards[0]);
                    } else if (frontCardAlign.y > 3.0 &&
                        widget.enableSwipeDown) {
                      shouldAnimate =
                          onCardSwiped(AxisDirection.down, index, cards[0]);
                    } else {
                      // Return to the initial rotation and alignment
                      setState(() {
                        frontCardAlign = defaultFrontCardAlign;
                        frontCardRot = 0.0;
                      });
                    }

                    shouldAnimate ??= true;

                    if (shouldAnimate) {
                      animateCards();
                    }
                  },
                ),
              )
            else
              const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget backCard() {
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.backCardAlignmentAnim(_controller).value
          : cardsAlign[0],
      child: SizedBox.fromSize(
        size: _controller.status == AnimationStatus.forward
            ? CardsAnimation.backCardSizeAnim(_controller).value
            : cardsSize[2],
        child: cards[2],
      ),
    );
  }

  Widget middleCard() {
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.middleCardAlignmentAnim(_controller).value
          : cardsAlign[1],
      child: SizedBox.fromSize(
        size: _controller.status == AnimationStatus.forward
            ? CardsAnimation.middleCardSizeAnim(_controller).value
            : cardsSize[1],
        child: cards[1],
      ),
    );
  }

  Widget frontCard() {
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.frontCardDisappearAlignmentAnim(
              _controller,
              frontCardAlign,
            ).value
          : frontCardAlign,
      child: Transform.rotate(
        angle: (pi / 180.0) * frontCardRot,
        child: SizedBox.fromSize(size: cardsSize[0], child: cards[0]),
      ),
    );
  }

  void changeCardsOrder() {
    setState(() {
      // Swap cards (back card becomes the middle card; middle card becomes the front card)
      cards[0] = cards[1];
      cards[1] = cards[2];
      cards[2] = appendCard;
      appendCard = null;

      cardsCounter++;
      index++;

      frontCardAlign = defaultFrontCardAlign;
      frontCardRot = 0.0;
    });
  }

  void animateCards() {
    _controller
      ..stop()
      ..value = 0.0
      ..forward();
  }
}
