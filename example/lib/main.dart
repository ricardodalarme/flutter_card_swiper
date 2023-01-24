import 'package:example/example_candidate_model.dart';
import 'package:example/example_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Example(),
  ));
}

class Example extends StatefulWidget {
  const Example({
    Key? key,
  }) : super(key: key);

  @override
  State<Example> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<Example> {
  final CardSwiperController controller = CardSwiperController();

  final cards = candidates.map((candidate) => ExampleCard(candidate)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: CardSwiper(
                controller: controller,
                cards: cards,
                onSwipe: _swipe,
                padding: const EdgeInsets.all(24.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: controller.swipe,
                    child: Icon(Icons.rotate_right),
                  ),
                  FloatingActionButton(
                    onPressed: controller.swipeLeft,
                    child: Icon(Icons.keyboard_arrow_left),
                  ),
                  FloatingActionButton(
                    onPressed: controller.swipeRight,
                    child: Icon(Icons.keyboard_arrow_right),
                  ),
                  FloatingActionButton(
                    onPressed: controller.swipeTop,
                    child: Icon(Icons.keyboard_arrow_up),
                  ),
                  FloatingActionButton(
                    onPressed: controller.swipeBottom,
                    child: Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _swipe(int index, CardSwiperDirection direction) {
    debugPrint("the card was swiped to the: " + direction.name);
  }
}
