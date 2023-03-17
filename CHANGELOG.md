## [2.0.2]

- **BREAKING CHANGE**:
  - CardSwipers onSwipe function now returns <bool?> instead of <void>. In order to restore
    compatibility it is enough to declare <bool?> as the new return type, no further changes are
    needed. If onSwipe returns false, the swipe action will now be canceled and the current card
    will remain on top of the stack.

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

- Dipose the CardSwiperController to avoid memory leaks

## [1.1.0]

- Add option to slide up and down through controller

## [1.0.2]

- Make all callbacks type-safe

## [1.0.1]

- Fix problem with the back card not being rendered

## [1.0.0]

- Based on Appinio Swiper
