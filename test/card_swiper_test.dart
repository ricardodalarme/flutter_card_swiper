import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  group('CardSwiper', () {
    testWidgets('pump widget', (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: CardSwiper(
            key: swiperKey,
            cardsCount: 3,
            cardBuilder: genericBuilder,
          ),
        ),
      );

      expect(find.byKey(swiperKey), findsOneWidget);
    });

    testWidgets(
        'when initialIndex is defined expect the related card be on top',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();
      const initialIndex = 7;

      await tester.pumpWidget(
        MaterialApp(
          home: CardSwiper(
            key: swiperKey,
            cardsCount: 10,
            numberOfCardsDisplayed: 1,
            cardBuilder: genericBuilder,
            initialIndex: initialIndex,
          ),
        ),
      );

      expect(find.text(getIndexText(initialIndex)), findsOneWidget);
    });

    testWidgets('when swiping right expect to see the next card',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: CardSwiper(
            key: swiperKey,
            cardsCount: 10,
            numberOfCardsDisplayed: 1,
            cardBuilder: genericBuilder,
          ),
        ),
      );

      await tester.drag(find.byKey(swiperKey), const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(find.text(getIndexText(1)), findsOneWidget);
    });

    testWidgets('when swiping left expect to see the next card',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: CardSwiper(
            key: swiperKey,
            cardsCount: 10,
            numberOfCardsDisplayed: 1,
            cardBuilder: genericBuilder,
          ),
        ),
      );

      await tester.drag(find.byKey(swiperKey), const Offset(-300, 0));
      await tester.pumpAndSettle();

      expect(find.text(getIndexText(1)), findsOneWidget);
    });

    testWidgets('when swiping top expect to see the next card',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: CardSwiper(
            key: swiperKey,
            cardsCount: 10,
            numberOfCardsDisplayed: 1,
            cardBuilder: genericBuilder,
          ),
        ),
      );

      await tester.drag(find.byKey(swiperKey), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.text(getIndexText(1)), findsOneWidget);
    });

    testWidgets('when swiping bottom expect to see the next card',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: CardSwiper(
            key: swiperKey,
            cardsCount: 10,
            numberOfCardsDisplayed: 1,
            cardBuilder: genericBuilder,
          ),
        ),
      );

      await tester.drag(find.byKey(swiperKey), const Offset(0, 300));
      await tester.pumpAndSettle();

      expect(find.text(getIndexText(1)), findsOneWidget);
    });

    testWidgets('when numberOfCardsDisplayed is 1 expect to see only one card',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: CardSwiper(
            key: swiperKey,
            cardsCount: 10,
            numberOfCardsDisplayed: 1,
            cardBuilder: genericBuilder,
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('when numberOfCardsDisplayed is 10 expect to see 10 cards',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: CardSwiper(
            key: swiperKey,
            cardsCount: 10,
            numberOfCardsDisplayed: 10,
            cardBuilder: genericBuilder,
          ),
        ),
      );

      expect(find.byType(Container), findsNWidgets(10));
    });

    testWidgets('when isDisabled is true expect to block swipes',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: CardSwiper(
            key: swiperKey,
            cardsCount: 10,
            numberOfCardsDisplayed: 1,
            cardBuilder: genericBuilder,
            isDisabled: true,
          ),
        ),
      );

      await tester.drag(find.byKey(swiperKey), const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(find.text(getIndexText(0)), findsOneWidget);
    });

    testWidgets('when isDisabled is false expect to allow swipes',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: CardSwiper(
            key: swiperKey,
            cardsCount: 10,
            numberOfCardsDisplayed: 1,
            cardBuilder: genericBuilder,
          ),
        ),
      );

      await tester.drag(find.byKey(swiperKey), const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(find.text(getIndexText(1)), findsOneWidget);
    });

    testWidgets('when isLoop is true expect to loop the cards',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: CardSwiper(
            key: swiperKey,
            cardsCount: 2,
            numberOfCardsDisplayed: 1,
            cardBuilder: genericBuilder,
          ),
        ),
      );

      await tester.drag(find.byKey(swiperKey), const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(find.text(getIndexText(1)), findsOneWidget);

      await tester.drag(find.byKey(swiperKey), const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(find.text(getIndexText(0)), findsOneWidget);
    });

    testWidgets('when isLoop is false expect to not return to the first card',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: CardSwiper(
            key: swiperKey,
            cardsCount: 2,
            numberOfCardsDisplayed: 1,
            cardBuilder: genericBuilder,
            isLoop: false,
          ),
        ),
      );

      await tester.drag(find.byKey(swiperKey), const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(find.text(getIndexText(1)), findsOneWidget);

      await tester.drag(find.byKey(swiperKey), const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(find.byType(Container), findsNothing);
    });

    testWidgets('when onSwipe is defined expect to call it on swipe',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();
      var isCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: CardSwiper(
            key: swiperKey,
            cardsCount: 10,
            numberOfCardsDisplayed: 1,
            cardBuilder: genericBuilder,
            onSwipe: (oldIndex, currentIndex, direction) {
              isCalled = true;
              return true;
            },
          ),
        ),
      );

      await tester.drag(find.byKey(swiperKey), const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(isCalled, true);
    });

    testWidgets(
        'when onSwipe is defined and it returns false expect to not swipe',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: CardSwiper(
            key: swiperKey,
            cardsCount: 10,
            numberOfCardsDisplayed: 1,
            cardBuilder: genericBuilder,
            onSwipe: (oldIndex, currentIndex, direction) {
              return false;
            },
          ),
        ),
      );

      await tester.drag(find.byKey(swiperKey), const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(find.text(getIndexText(0)), findsOneWidget);
    });

    testWidgets(
        'when onSwipe is defined expect it to return the correct direction',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();
      final directions = <CardSwiperDirection>[];

      await tester.pumpWidget(
        MaterialApp(
          home: CardSwiper(
            key: swiperKey,
            cardsCount: 10,
            numberOfCardsDisplayed: 1,
            cardBuilder: genericBuilder,
            onSwipe: (oldIndex, currentIndex, swipeDirection) {
              directions.add(swipeDirection);
              return true;
            },
          ),
        ),
      );

      await tester.drag(find.byKey(swiperKey), const Offset(300, 0));
      await tester.pumpAndSettle();

      await tester.drag(find.byKey(swiperKey), const Offset(-300, 0));
      await tester.pumpAndSettle();

      await tester.drag(find.byKey(swiperKey), const Offset(0, 300));
      await tester.pumpAndSettle();

      await tester.drag(find.byKey(swiperKey), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(directions, [
        CardSwiperDirection.right,
        CardSwiperDirection.left,
        CardSwiperDirection.bottom,
        CardSwiperDirection.top,
      ]);
    });

    testWidgets(
        'when onSwipe is defined and isLoop is true expect it to return the correct indexes',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();
      final oldIndexes = <int>[];
      final newIndexes = <int?>[];

      await tester.pumpWidget(
        MaterialApp(
          home: CardSwiper(
            key: swiperKey,
            cardsCount: 3,
            numberOfCardsDisplayed: 1,
            cardBuilder: genericBuilder,
            onSwipe: (oldIndex, currentIndex, swipeDirection) {
              oldIndexes.add(oldIndex);
              newIndexes.add(currentIndex);
              return true;
            },
          ),
        ),
      );

      await tester.drag(find.byKey(swiperKey), const Offset(300, 0));
      await tester.pumpAndSettle();

      await tester.drag(find.byKey(swiperKey), const Offset(300, 0));
      await tester.pumpAndSettle();

      await tester.drag(find.byKey(swiperKey), const Offset(300, 0));
      await tester.pumpAndSettle();

      await tester.drag(find.byKey(swiperKey), const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(oldIndexes, [0, 1, 2, 0]);
      expect(newIndexes, [1, 2, 0, 1]);
    });

    testWidgets(
        'when onSwipe is defined and isLoop is false expect it to return the correct indexes',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();
      final oldIndexes = <int>[];
      final newIndexes = <int?>[];

      await tester.pumpWidget(
        MaterialApp(
          home: CardSwiper(
            key: swiperKey,
            cardsCount: 3,
            numberOfCardsDisplayed: 1,
            cardBuilder: genericBuilder,
            onSwipe: (oldIndex, currentIndex, swipeDirection) {
              oldIndexes.add(oldIndex);
              newIndexes.add(currentIndex);
              return true;
            },
            isLoop: false,
          ),
        ),
      );

      await tester.drag(find.byKey(swiperKey), const Offset(300, 0));
      await tester.pumpAndSettle();

      await tester.drag(find.byKey(swiperKey), const Offset(300, 0));
      await tester.pumpAndSettle();

      await tester.drag(find.byKey(swiperKey), const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(oldIndexes, [0, 1, 2]);
      expect(newIndexes, [1, 2, null]);
    });

    testWidgets('when onEnd is defined expect to call it on end',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();
      var isCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: CardSwiper(
            key: swiperKey,
            cardsCount: 2,
            numberOfCardsDisplayed: 1,
            cardBuilder: genericBuilder,
            onEnd: () {
              isCalled = true;
            },
          ),
        ),
      );

      await tester.drag(find.byKey(swiperKey), const Offset(300, 0));
      await tester.pumpAndSettle();

      await tester.drag(find.byKey(swiperKey), const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(isCalled, true);
    });

    testWidgets('when swipes less than the threshold should go back',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: CardSwiper(
            key: swiperKey,
            cardsCount: 10,
            numberOfCardsDisplayed: 1,
            cardBuilder: genericBuilder,
          ),
        ),
      );

      await tester.drag(find.byKey(swiperKey), const Offset(50, 0));
      await tester.pumpAndSettle();

      expect(find.text(getIndexText(0)), findsOneWidget);
    });
  });

  testWidgets(
      'when isDisabled is true and tap on card expect to call onTapDisabled',
      (WidgetTester tester) async {
    final swiperKey = GlobalKey();
    var isCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          cardBuilder: genericBuilder,
          onTapDisabled: () {
            isCalled = true;
          },
          isDisabled: true,
        ),
      ),
    );

    await tester.tap(find.byKey(swiperKey));
    await tester.pumpAndSettle();

    expect(isCalled, true);
  });
}
