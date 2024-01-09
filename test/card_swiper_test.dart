import 'package:flutter/widgets.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers/card_builder.dart';
import 'test_helpers/finders.dart';
import 'test_helpers/gestures.dart';
import 'test_helpers/pump_app.dart';

void main() {
  group('CardSwiper', () {
    testWidgets('pump widget', (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 3,
          cardBuilder: genericBuilder,
        ),
      );

      expect(find.byKey(swiperKey), findsOneWidget);
    });

    testWidgets(
        'when initialIndex is defined expect the related card be on top',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();
      const initialIndex = 7;

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          cardBuilder: genericBuilder,
          initialIndex: initialIndex,
        ),
      );

      expect(find.text(getIndexText(initialIndex)), findsOneWidget);
    });

    testWidgets('when swiping right expect to see the next card',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          cardBuilder: genericBuilder,
        ),
      );

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      expect(find.card(1), findsOneWidget);
    });

    testWidgets('when swiping left expect to see the next card',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          cardBuilder: genericBuilder,
        ),
      );

      await tester.dragLeft(swiperKey);
      await tester.pumpAndSettle();

      expect(find.card(1), findsOneWidget);
    });

    testWidgets('when swiping top expect to see the next card',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          cardBuilder: genericBuilder,
        ),
      );

      await tester.dragUp(swiperKey);
      await tester.pumpAndSettle();

      expect(find.card(1), findsOneWidget);
    });

    testWidgets('when swiping bottom expect to see the next card',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          cardBuilder: genericBuilder,
        ),
      );

      await tester.dragDown(swiperKey);
      await tester.pumpAndSettle();

      expect(find.card(1), findsOneWidget);
    });

    testWidgets('when numberOfCardsDisplayed is 1 expect to see only one card',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          cardBuilder: genericBuilder,
        ),
      );

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('when numberOfCardsDisplayed is 10 expect to see 10 cards',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 10,
          cardBuilder: genericBuilder,
        ),
      );

      expect(find.byType(Container), findsNWidgets(10));
    });

    testWidgets('when isDisabled is true expect to block swipes',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          cardBuilder: genericBuilder,
          isDisabled: true,
        ),
      );

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      expect(find.card(0), findsOneWidget);
    });

    testWidgets('when isDisabled is false expect to allow swipes',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          cardBuilder: genericBuilder,
        ),
      );

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      expect(find.card(1), findsOneWidget);
    });

    testWidgets('when isLoop is true expect to loop the cards',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 2,
          numberOfCardsDisplayed: 1,
          cardBuilder: genericBuilder,
        ),
      );

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      expect(find.card(1), findsOneWidget);

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      expect(find.card(0), findsOneWidget);
    });

    testWidgets('when isLoop is false expect to not return to the first card',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 2,
          numberOfCardsDisplayed: 1,
          cardBuilder: genericBuilder,
          isLoop: false,
        ),
      );

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      expect(find.card(1), findsOneWidget);

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      expect(find.byType(Container), findsNothing);
    });

    testWidgets('when onSwipe is defined expect to call it on swipe',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();
      var isCalled = false;

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          cardBuilder: genericBuilder,
          onSwipe: (oldIndex, currentIndex, direction) {
            isCalled = true;
            return true;
          },
        ),
      );

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      expect(isCalled, true);
    });

    testWidgets(
        'when onSwipe is defined and it returns false expect to not swipe',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          cardBuilder: genericBuilder,
          onSwipe: (oldIndex, currentIndex, direction) {
            return false;
          },
        ),
      );

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      expect(find.card(0), findsOneWidget);
    });

    testWidgets(
        'when onSwipe is defined expect it to return the correct direction',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();
      final directions = <CardSwiperDirection>[];

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          cardBuilder: genericBuilder,
          onSwipe: (oldIndex, currentIndex, swipeDirection) {
            directions.add(swipeDirection);
            return true;
          },
        ),
      );

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      await tester.dragLeft(swiperKey);
      await tester.pumpAndSettle();

      await tester.dragDown(swiperKey);
      await tester.pumpAndSettle();

      await tester.dragUp(swiperKey);
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

      await tester.pumpApp(
        CardSwiper(
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
      );

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      await tester.dragRight(swiperKey);
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

      await tester.pumpApp(
        CardSwiper(
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
      );

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      expect(oldIndexes, [0, 1, 2]);
      expect(newIndexes, [1, 2, null]);
    });

    testWidgets('when onEnd is defined expect to call it on end',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();
      var isCalled = false;

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 2,
          numberOfCardsDisplayed: 1,
          cardBuilder: genericBuilder,
          onEnd: () {
            isCalled = true;
          },
        ),
      );

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      expect(isCalled, true);
    });

    testWidgets('when swipes less than the threshold should go back',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();
      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          cardBuilder: genericBuilder,
        ),
      );

      await tester.drag(find.byKey(swiperKey), const Offset(50, 0));
      await tester.pumpAndSettle();

      expect(find.card(0), findsOneWidget);
    });

    testWidgets(
        'when isDisabled is true and tap on card expect to call onTapDisabled',
        (WidgetTester tester) async {
      final swiperKey = GlobalKey();
      var isCalled = false;

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          cardBuilder: genericBuilder,
          onTapDisabled: () {
            isCalled = true;
          },
          isDisabled: true,
        ),
      );

      await tester.tap(find.byKey(swiperKey));
      await tester.pumpAndSettle();

      expect(isCalled, true);
    });
  });

  group('Card swipe direction tests', () {
    testWidgets(
        'when swiping right and AllowedSwipeDirection.right=true,'
        ' expect to see the next card', (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          allowedSwipeDirection: const AllowedSwipeDirection.only(right: true),
          cardBuilder: genericBuilder,
        ),
      );

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      expect(find.card(1), findsOneWidget);
    });

    testWidgets(
        'when swiping right and AllowedSwipeDirection.right=false,'
        ' expect to see the same card', (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          allowedSwipeDirection: const AllowedSwipeDirection.only(left: true),
          cardBuilder: genericBuilder,
        ),
      );

      await tester.dragRight(swiperKey);
      await tester.pumpAndSettle();

      expect(find.card(0), findsOneWidget);
    });

    testWidgets(
        'when swiping left and AllowedSwipeDirection.left=true,'
        ' expect to see the next card', (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          allowedSwipeDirection: const AllowedSwipeDirection.only(left: true),
          cardBuilder: genericBuilder,
        ),
      );

      await tester.dragLeft(swiperKey);
      await tester.pumpAndSettle();

      expect(find.card(1), findsOneWidget);
    });

    testWidgets(
        'when swiping left and AllowedSwipeDirection.left=false,'
        ' expect to see the same card', (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          allowedSwipeDirection: const AllowedSwipeDirection.only(right: true),
          cardBuilder: genericBuilder,
        ),
      );

      await tester.dragLeft(swiperKey);
      await tester.pumpAndSettle();

      expect(find.card(0), findsOneWidget);
    });

    testWidgets(
        'when swiping up and AllowedSwipeDirection.up=true,'
        ' expect to see the next card', (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          allowedSwipeDirection: const AllowedSwipeDirection.only(up: true),
          cardBuilder: genericBuilder,
        ),
      );

      await tester.dragUp(swiperKey);
      await tester.pumpAndSettle();

      expect(find.card(1), findsOneWidget);
    });

    testWidgets(
        'when swiping up and AllowedSwipeDirection.up=false,'
        ' expect to see the same card', (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          allowedSwipeDirection: const AllowedSwipeDirection.only(down: true),
          cardBuilder: genericBuilder,
        ),
      );

      await tester.dragUp(swiperKey);
      await tester.pumpAndSettle();

      expect(find.card(0), findsOneWidget);
    });

    testWidgets(
        'when swiping down and AllowedSwipeDirection.down=true,'
        ' expect to see the next card', (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          allowedSwipeDirection: const AllowedSwipeDirection.only(down: true),
          cardBuilder: genericBuilder,
        ),
      );

      await tester.dragDown(swiperKey);
      await tester.pumpAndSettle();

      expect(find.card(1), findsOneWidget);
    });

    testWidgets(
        'when swiping down and AllowedSwipeDirection.down=false,'
        ' expect to see the same card', (WidgetTester tester) async {
      final swiperKey = GlobalKey();

      await tester.pumpApp(
        CardSwiper(
          key: swiperKey,
          cardsCount: 10,
          numberOfCardsDisplayed: 1,
          allowedSwipeDirection: const AllowedSwipeDirection.only(up: true),
          cardBuilder: genericBuilder,
        ),
      );

      await tester.dragDown(swiperKey);
      await tester.pumpAndSettle();

      expect(find.card(0), findsOneWidget);
    });
  });
}
