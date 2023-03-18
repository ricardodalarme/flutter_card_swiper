# flutter_card_swiper

[![Pub Version](https://img.shields.io/pub/v/flutter_card_swiper?logo=dart&logoColor=white)](https://pub.dev/packages/flutter_card_swiper)
[![Pub points](https://badgen.net/pub/points/flutter_card_swiper)](https://pub.dev/packages/flutter_card_swiper)
[![Pub Likes](https://badgen.net/pub/likes/flutter_card_swiper)](https://pub.dev/packages/flutter_card_swiper)
[![Pub popularity](https://badgen.net/pub/popularity/flutter_card_swiper)](https://pub.dev/packages/flutter_card_swiper)
[![License](https://badgen.net/github/license/ricardodalarme/flutter_card_swiper)](https://github.com/ricardodalarme/flutter_card_swiper/blob/main/LICENSE)

This is a Flutter package for a Tinder-like card swiper. ✨

It allows you to swipe left, right, up, and down and define your own business logic for each direction.

Very smooth animations supporting Android, iOS, Web & Desktop.

## Why?

We build this package because we wanted to:

- have a completely customizable slider
- be able to swipe in every direction
- choose our own settings for the swiper such as duration, angle, padding, and more
- trigger slide to any direction you want using the controller
- add callbacks while wiping, on end or when the swiper is disabled
- detect the direction (left, right, top, bottom) in which the card was swiped away

## Show Cases

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/swiper/swiping.gif?raw=true" height="250" /> <img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/swiper/swipe_left_right.gif?raw=true" height="250" />

Customize the angle

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/swiper/angle.gif?raw=true" height="250" />

Customize the threshold (when the card should slide away)

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/swiper/treshold.gif?raw=true" height="250" />

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
          cards: cards,
        ),
      ),
    );
  }
}
```

## Constructor
#### Basic


| Parameter        | Default           | Description  | Required  |
| ------------- |:-------------|:-----|:-----:|
| cards      | - | List of Widgets for the swiper | true
| controller      | - | Trigger swipe | false
| padding      | EdgeInsets.symmetric(horizontal: 20, vertical: 25) | Control swiper padding | false
| duration      | 200 milliseconds    |   The duration that every animation should last | false
| maxAngle | 30      |    Maximum angle the card reaches while swiping | false
| threshold | 50     |    Threshold from which the card is swiped away | false
| scale | 0.9     |    Scale of the card that is behind the front card | false
| isDisabled | false      |   Set to ```true``` if swiping should be disabled, has no impact when triggered from the outside | false
| isHorizontalSwipingEnabled | true    |   Set to ```false``` if you want your card to move only across the vertical axis when swiping | false
| isVerticalSwipingEnabled | true    |   Set to ```false``` if you want your card to move only across the horizontal axis when swiping | false
| isLoop | true | set to ```true``` if the stack should loop | false
| onTapDisabled | -     |    Function that get triggered when the swiper is disabled | false
| onSwipe | -    |    Called with the new index and detected swipe direction when the user swiped | false
| onEnd | -    |    Called when there is no Widget left to be swiped away | false
| direction | right    |    Direction in which the card is swiped away when triggered from the outside | false
| numberOfCardsDisplayed | 2    |   If your widgets in the 'cards' list cause performance issues, you can choose to display more cards at a time to reduce how long the user waits for a card to appear | false 

#### Controller

The ```Controller``` is used to swipe the card from outside of the widget. You can create a controller called ```CardSwiperController``` and save the instance for further usage. Please have a closer look at our Example for the usage.

| Method        | Description
| ------------- |:-------------
| swipe      | Changes the state of the controller to swipe and swipes the card in your selected direction.
| swipeLeft      | Changes the state of the controller to swipe left and swipes the card to the left side.
| swipeRight      | Changes the state of the controller to swipe right and swipes the card to the right side.
| swipeTop      | Changes the state of the controller to swipe top and swipes the card to the top side.
| swipeBottom      | Changes the state of the controller to swipe bottom and swipes the card to the | swipeBottom      | Changes the state of the controller to swipe bottom and swipes the card to the right side.

<hr/>

## Credits

- **Ricardo Dalarme** (Package maintainer)
- [**Appinio GmbH**](https://appinio.com) (Original project creator)
