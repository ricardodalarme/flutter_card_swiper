# swipeable_cards_stack

This is Tinder like swipeable cards package. You can add your own widgets to the stack, receive all four events, left, right, up and down. You can define your own business logic for each direction.

<img alt="Demo" src="images/swipe-card.gif" height="500">

## Documentation

### Installation

Add `swipeable_cards_stack` to your `pubspec.yaml`:

```yaml
dependencies:
  swipeable_cards_stack: <latest version>
```

### Usage

Use the `SwipeableCardsStack` widget provided by the package

```dart
import 'package:swipeable_cards_stack/swipeable_cards_stack.dart';

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final _cardsController = SwipeableCardsStackController();

  @override
  Widget build(BuildContext context) {
    return SwipeableCardsStack(
      cardController: _cardsController,
      context: context,
      // Add the first 3 cards (widgets)
      items: [
        CardView(text: "First card"),
        CardView(text: "Second card"),
        CardView(text: "Third card"),
      ],
      // Get card swipe event callbacks
      onCardSwiped: (dir, index, widget) {
        // Add the next card using _cardController
        _cardsController.addItem(CardView(text: "Next card"));

        // Take action on the swiped widget based on the direction of swipe
        // Return false to not animate cards
      },
      enableSwipeUp: true,
      enableSwipeDown: false,
    );
  }
}
```

### Contributing

If you want to contribute to this project, you may easily create issues and send PRs. Please take note that your code contributions will be applicable under MIT license unless specified otherwise.

### Credits

- **Ricardo Dalarme** (Package maintainer)
- [**CodeToArt Technology**](https://github.com/codetoart) (Original project creator)
