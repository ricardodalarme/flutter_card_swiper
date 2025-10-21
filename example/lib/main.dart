import 'package:example/example_candidate_model.dart';
import 'package:example/example_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: Example()),
  );
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<Example> {
  final CardSwiperController controller = CardSwiperController();

  final cards = candidates.map(ExampleCard.new).toList();
  int current = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: CardSwiper(
                controller: controller,
                cardsCount: cards.length,
                onSwipe: _onSwipe,
                onUndo: _onUndo,
                numberOfCardsDisplayed: 1,
                backCardOffset: const Offset(40, 40),
                padding: const EdgeInsets.all(24.0),
                duration: const Duration(milliseconds: 500),
                overlayBuilder: (
                  context,
                  index,
                  direction,
                  progress,
                ) {
                  if (direction == CardSwiperDirection.none) return null;
                  final isPositive = direction == CardSwiperDirection.right ||
                      direction == CardSwiperDirection.top;
                  // Requirement: when swiping left, overlay should be on right side.
                  // We'll position based on direction explicitly.
                  return Positioned(
                    top: 16,
                    left: direction == CardSwiperDirection.right ? 16 : null,
                    right: direction == CardSwiperDirection.left
                        ? 16
                        : (direction == CardSwiperDirection.top ? 16 : null),
                    child: Opacity(
                      opacity: progress,
                      child: Transform.rotate(
                        angle:
                            direction == CardSwiperDirection.left ? -0.2 : 0.2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isPositive ? Colors.green : Colors.red,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isPositive ? 'LIKE' : 'NOPE',
                            style: TextStyle(
                              color: isPositive ? Colors.green : Colors.red,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                dialogBuilder: AlertDialog(
                  backgroundColor: Colors.yellow,
                  alignment: Alignment.bottomCenter,
                  title: Text(
                    'Select an option ${cards[current].candidate.name}',
                  ),
                  content: const Text('Do you want to swipe the card?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop('Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        debugPrint('name: ${cards[current].candidate.job}');
                        Navigator.of(context).pop(
                          cards[current].candidate.job == 'Manager'
                              ? 'Left-Swipe'
                              : 'Swipe',
                        );
                      },
                      child: const Text('Swipe'),
                    ),
                  ],
                ),
                cardBuilder: (
                  context,
                  index,
                  horizontalThresholdPercentage,
                  verticalThresholdPercentage,
                ) =>
                    cards[index],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: controller.undo,
                    child: const Icon(Icons.rotate_left),
                  ),
                  FloatingActionButton(
                    onPressed: () => controller.swipe(CardSwiperDirection.left),
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  FloatingActionButton(
                    onPressed: () =>
                        controller.swipe(CardSwiperDirection.right),
                    child: const Icon(Icons.keyboard_arrow_right),
                  ),
                  FloatingActionButton(
                    onPressed: () => controller.swipe(CardSwiperDirection.top),
                    child: const Icon(Icons.keyboard_arrow_up),
                  ),
                  FloatingActionButton(
                    onPressed: () =>
                        controller.swipe(CardSwiperDirection.bottom),
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    current = currentIndex!;
    setState(() {});
    debugPrint('current: $current');
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $currentIndex was undone from the ${direction.name}',
    );
    return true;
  }
}
