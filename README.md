# flutter_card_swiper

[![Pub Version](https://img.shields.io/pub/v/flutter_card_swiper?logo=dart&logoColor=white)](https://pub.dev/packages/flutter_card_swiper)
[![Pub Points](https://badgen.net/pub/points/flutter_card_swiper)](https://pub.dev/packages/flutter_card_swiper)
[![Pub Likes](https://badgen.net/pub/likes/flutter_card_swiper)](https://pub.dev/packages/flutter_card_swiper)
[![Pub popularity](https://badgen.net/pub/popularity/flutter_card_swiper)](https://pub.dev/packages/flutter_card_swiper)
[![Tests](https://github.com/ricardodalarme/flutter_card_swiper/actions/workflows/code-check.yml/badge.svg)](https://github.com/ricardodalarme/flutter_card_swiper/actions/workflows/code-check.yml)
[![codecov](https://codecov.io/gh/ricardodalarme/flutter_card_swiper/branch/main/graph/badge.svg?token=UW677LGCBF)](https://codecov.io/gh/ricardodalarme/flutter_card_swiper)

This is a Flutter package for a Tinder-like card swiper. ✨

It allows you to swipe left, right, up, and down and define your own business logic for each direction.

Very smooth animations supporting Android, iOS, Web & Desktop.

## Why?

We built this package because we wanted to:

- Have a fully customizable slider
- Swipe in any direction
- Undo swipes as many times as you want
- Choose your own settings such as duration, angle, padding and more
- Trigger swipes in any direction with the controller
- Add callbacks while swiping, on end, or when the swiper is disabled
- Detect the direction (left, right, top, bottom) the card was swiped

## Show Cases

| Swipe in any direction | Trigger swipes | Unswipe the cards |
| ---------------------- | :------------- | :---------------- |
| <img src="https://github.com/ricardodalarme/flutter_card_swiper/blob/main/images/swiping.gif?raw=true" height="275" /> | <img src="https://github.com/ricardodalarme/flutter_card_swiper/blob/main/images/swipe_left_right.gif?raw=true" height="275" /> | <img src="https://github.com/ricardodalarme/flutter_card_swiper/blob/main/images/unswipe.gif?raw=true" height="275" /> |

| Fully customizable |
| ------------------ | 
| <img src="https://github.com/ricardodalarme/flutter_card_swiper/blob/main/images/angle.gif?raw=true" height="275" />  <img src="https://github.com/ricardodalarme/flutter_card_swiper/blob/main/images/treshold.gif?raw=true" height="275" />  | 

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
card_swiper: ...
```

**OR** run

```yaml
flutter pub add flutter_card_swiper
```

in your project's root directory.

## Usage

You can place your `CardSwiper` inside of a `Scaffold` like we did here. Optional parameters can be defined to enable different features. See the following example:

```dart
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/material.dart';

class Example extends StatelessWidget {
  List<Container> cards = [
    Container(
      alignment: Alignment.center,
      child: const Text('1'),
      color: Colors.blue,
    ),
    Container(
      alignment: Alignment.center,
      child: const Text('2'),
      color: Colors.red,
    ),
    Container(
      alignment: Alignment.center,
      child: const Text('3'),
      color: Colors.purple,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flexible(
        child: CardSwiper(
          cardsCount: cards.length,
          cardBuilder: (context, index) => cards[index],
        ),
      ),
    );
  }
}
```

## Constructor

#### Basic

| Parameter                  | Default                                            | Description                                                                                                                                                                          | Required |
| -------------------------- | :------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------: |
| cardBuilder                | -                                                  | Widget builder for rendering cards                                                                                                                                                   |   true   |
| cardsCount                 | -                                                  | Number of cards                                                                                                                                                                      |   true   |
| initialIndex               | 0                                                  | Index of the first card when the swiper is initialized                                                                                                                               |  false   |
| controller                 | -                                                  | Trigger swipe                                                                                                                                                                        |  false   |
| padding                    | EdgeInsets.symmetric(horizontal: 20, vertical: 25) | Controller to trigger swipe actions                                                                                                                                                  |  false   |
| duration                   | 200 milliseconds                                   | The duration that every animation should last                                                                                                                                        |  false   |
| maxAngle                   | 30                                                 | Maximum angle that the card can reach during swiping                                                                                                                                 |  false   |
| threshold                  | 50                                                 | Threshold from which the card is swiped away                                                                                                                                         |  false   |
| scale                      | 0.9                                                | Scale of the card that is behind the front card                                                                                                                                      |  false   |
| isDisabled                 | false                                              | Set to `true` if swiping should be disabled, has no impact when triggered from the outside                                                                                           |  false   |
| isHorizontalSwipingEnabled | true                                               | Set to `false` if you want your card to move only across the vertical axis when swiping                                                                                              |  false   |
| isVerticalSwipingEnabled   | true                                               | Set to `false` if you want your card to move only across the horizontal axis when swiping                                                                                            |  false   |
| isLoop                     | true                                               | Set to `true` if the stack should loop                                                                                                                                               |  false   |
| onTapDisabled              | -                                                  | Function that get triggered when the swiper is disabled                                                                                                                              |  false   |
| onSwipe                    | -                                                  | Function that is called when the user swipes a card. If the function returns `false`, the swipe action is canceled. If it returns `true`, the swipe action is performed as expected  |  false   |
| onUndo                     | -                                                  | Function that is called when the controller calls undo. If the function returns `false`, the undo action is canceled. If it returns `true`, the undo action is performed as expected  |  false   |
| onEnd                      | -                                                  | Function that is called when there are no more cards left to swipe                                                                                                                   |  false   |
| direction                  | right                                              | Direction in which the card is swiped away when triggered from the outside                                                                                                           |  false   |
| numberOfCardsDisplayed     | 2                                                  | Number of cards to display at a time                                                                                                                                                 |  false   |

#### Controller

The `Controller` is used to swipe the card from outside of the widget. You can create a controller called `CardSwiperController` and save the instance for further usage. Please have a closer look at our Example for the usage.

| Method      | Description                                                                                      |
| ----------- | :----------------------------------------------------------------------------------------------- |
| swipe       | Changes the state of the controller to swipe and swipes the card in your selected direction.     |
| swipeLeft   | Changes the state of the controller to swipe left and swipes the card to the left side.          |
| swipeRight  | Changes the state of the controller to swipe right and swipes the card to the right side.        |
| swipeTop    | Changes the state of the controller to swipe top and swipes the card to the top side.            |
| swipeBottom | Changes the state of the controller to swipe bottom and swipes the card to the bottom side.      |
| undo        | Changes the state of the controller to undo and brings back the last card that was swiped away.  |

<hr/>

## Credits

- **Ricardo Dalarme** (Package maintainer)
- [**Appinio GmbH**](https://appinio.com) (Original project creator)
