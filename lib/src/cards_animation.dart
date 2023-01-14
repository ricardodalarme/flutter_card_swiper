import 'package:flutter/widgets.dart';

import 'swipeable_cards_stack.dart';

class CardsAnimation {
  static Animation<Alignment> backCardAlignmentAnim(
    AnimationController parent,
  ) {
    return AlignmentTween(begin: cardsAlign[0], end: cardsAlign[1]).animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );
  }

  static Animation<Size?> backCardSizeAnim(AnimationController parent) {
    return SizeTween(begin: cardsSize[2], end: cardsSize[1]).animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );
  }

  static Animation<Alignment> middleCardAlignmentAnim(
    AnimationController parent,
  ) {
    return AlignmentTween(begin: cardsAlign[1], end: cardsAlign[2]).animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  static Animation<Size?> middleCardSizeAnim(AnimationController parent) {
    return SizeTween(begin: cardsSize[1], end: cardsSize[0]).animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  static Animation<Alignment> frontCardDisappearAlignmentAnim(
    AnimationController parent,
    Alignment beginAlign,
  ) {
    if (beginAlign.x == -0.001 ||
        beginAlign.x == 0.001 ||
        beginAlign.x > 3.0 ||
        beginAlign.x < -3.0) {
      return AlignmentTween(
        begin: beginAlign,
        end: Alignment(
          beginAlign.x > 0 ? beginAlign.x + 30.0 : beginAlign.x - 30.0,
          0.0,
        ), // Has swiped to the left or right?
      ).animate(
        CurvedAnimation(
          parent: parent,
          curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
        ),
      );
    } else {
      return AlignmentTween(
        begin: beginAlign,
        end: Alignment(
          0.0,
          beginAlign.y > 0 ? beginAlign.y + 30.0 : beginAlign.y - 30.0,
        ), // Has swiped to the top or bottom?
      ).animate(
        CurvedAnimation(
          parent: parent,
          curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
        ),
      );
    }
  }
}
