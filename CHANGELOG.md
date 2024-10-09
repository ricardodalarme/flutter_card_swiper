## [7.0.2]

- Added `CardAnimation.animateToAngle` helper to animate swipe the card to any given angle between 0-360°.
- Added `CardAnimation.animateUndoFromAngle` helper method to undo animation from any angle.
- Removed previous implementations for the above in the `CardAnimation` class, namely - `animateHorizontally`, `animateVertically`, `animateUndoHorizontally`, and `animateUndoVertically`.
- Replaced `enum CardSwiperDirection` with `class CardSwiperDirection` to support custom angle swiping.

## [7.0.2]

- Tracks `StreamSubscription<ControllerEvent>` given `widget.controller`, and calls `cancel` on dispose.

## [7.0.1]

- Prevents `CardSwiperController` to be disposed by `CardSwiper`.

## [7.0.0]

- Adds `moveTo` method to `CardSwiperController` to move to a specific card index.
- **BREAKING CHANGE**:
  - Upgrade min dart sdk to 3.0.0
  - Replace `swipe`, `swipeLeft`, `swipeRight`, `swipeUp`, `swipeDown` with `swipe(CardSwiperDirection direction)`
    - It also removes `direction` from the `CardSwiper` widget

## [6.1.0]

- Fixes cannot access context in onSwipe when no cards left then "destroy" the widget tree
- Make only and symetric const constructor for AllowedSwipeDirection 

## [6.0.0]

- Adds `onSwipeDirectionChange` callback containing the horizontal and vertical swipe direction
- **BREAKING CHANGE**:
  - Modifies the `cardBuilder` callback, to include the ratio of horizontal drag to threshold as a percentage
    and the ratio of vertical drag to threshold as a percentage. 
- **BREAKING CHANGE**:
  - `isHorizontalSwipingEnabled` and `isVerticalSwipingEnabled` have been removed. Use `allowedSwipeDirection` instead.

## [5.1.0]

- Adds AllowedSwipeDirection to allow card to be swiped in any combination of left, right, up or down directions.
- **DEPRECATION**:
  - `isHorizontalSwipingEnabled` and `isVerticalSwipingEnabled` have been deprecated. Use `allowedSwipeDirection` instead.

## [5.0.1]

- Adds support for negative back card offset.
- Fix only 2 cards displayed even when numberOfCardsDisplayed param is greater than 2.

## [5.0.0]

- Adds option to customize the back card offset.
- **BREAKING CHANGE**:
  - `CardSwiperController` is no longer disposed by `CardSwiper`, but who created it must dispose it.

## [4.1.3]

- Fix Swiping when `isDisabled` is `true` and triggered by the `controller`.

## [4.1.2]

- Fixes the `isHorizontalSwipingEnabled` and `isVerticalSwipingEnabled`.

## [4.1.1]

- Changes `onSwipe` and `onEnd` callbacks to be FutureOr.

## [4.1.0]

- Adds option to undo swipes.

## [4.0.2]

- Fixes `onSwipe` callback being called twice.

## [4.0.1]

- Updates the docs.

## [4.0.0]

- **BREAKING CHANGE**:
  - CardSwipers onSwipe function now returns ```<bool>``` instead of ```<void>```. If onSwipe returns ```false```,
    the swipe action will now be canceled and the current card will remain on top of the stack. 
    Otherwise, if it returns ```true```, the swipe action will be performed as expected.

## [3.1.0]

- Adds option to set the initial index of the swiper.

## [3.0.0]

- **BREAKING CHANGES**:
  - Adds currentIndex and previousIndex to the onSwipe callback.
  - Renders the items through a builder function.

## [2.1.0]

- Add option to display more cards at a time. Useful if the widgets you want in your cards take time to build (for example a network image or video): displaying more cards builds them in advance and makes a fast serie of swipes more fluid.

## [2.0.1]

- Fixes wrong item rendering.

## [2.0.0]

- Makes CardSwiper a generic of `Widget?`.
- Adds option to control if the stack should loop or not.
- **BREAKING CHANGE**:
  - Now CardSwiper is a stack, meaning that the last item is now the visible item.

## [1.2.1]

- Add option to disable vertical or horizontal swipping

## [1.2.0]

- Allow changing the scale of the card that is behind the front card

## [1.1.1]

- Dispose the CardSwiperController to avoid memory leaks

## [1.1.0]

- Add option to slide up and down through controller

## [1.0.2]

- Make all callbacks type-safe

## [1.0.1]

- Fix problem with the back card not being rendered

## [1.0.0]

- Based on Appinio Swiper
