## NEXT

- **BREAKING CHANGES**:
  - Add currentIndex and previousIndex to the onSwipe callback

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

- Dipose the CardSwiperController to avoid memory leaks

## [1.1.0]

- Add option to slide up and down through controller

## [1.0.2]

- Make all callbacks type-safe

## [1.0.1]

- Fix problem with the back card not being rendered

## [1.0.0]

- Based on Appinio Swiper
