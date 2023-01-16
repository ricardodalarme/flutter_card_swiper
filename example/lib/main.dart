import 'dart:developer';

import 'package:example/example_candidate_model.dart';
import 'package:example/example_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_card_swiper/card_swiper.dart';

import 'example_buttons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: Example(),
    );
  }
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

  List<ExampleCard> cards = [];

  @override
  void initState() {
    _loadCards();
    super.initState();
  }

  void _loadCards() {
    for (ExampleCandidateModel candidate in candidates) {
      cards.add(
        ExampleCard(
          candidate: candidate,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: CardSwiper(
              controller: controller,
              cards: cards,
              onSwipe: _swipe,
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 50,
                bottom: 40,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              swipeLeftButton(controller),
              const SizedBox(
                width: 20,
              ),
              swipeRightButton(controller),
            ],
          )
        ],
      ),
    );
  }

  void _swipe(int index, CardSwiperDirection direction) {
    log("the card was swiped to the: " + direction.name);
  }
}
