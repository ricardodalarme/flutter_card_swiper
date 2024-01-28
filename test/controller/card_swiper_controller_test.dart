import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_card_swiper/src/controller/controller_event.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers/card_builder.dart';
import '../test_helpers/finders.dart';
import '../test_helpers/pump_app.dart';

void main() {
  group('CardSwiperController', () {
    test('Swipe event adds ControllerSwipeEvent to the stream', () {
      final controller = CardSwiperController();
      const direction = CardSwiperDirection.right;

      expectLater(
        controller.events,
        emits(
          isA<ControllerSwipeEvent>()
              .having((event) => event.direction, 'direction', direction),
        ),
      );

      controller.swipe(direction);
    });

    test('Undo event adds ControllerUndoEvent to the stream', () {
      final controller = CardSwiperController();

      expectLater(
        controller.events,
        emits(isA<ControllerUndoEvent>()),
      );

      controller.undo();
    });

    test('Swipe event adds ControllerSwipeEvent to the stream', () {
      final controller = CardSwiperController();
      const index = 42;

      expectLater(
        controller.events,
        emits(
          isA<ControllerMoveEvent>()
              .having((event) => event.index, 'index', index),
        ),
      );

      controller.moveTo(index);
    });

    test('Dispose closes the stream', () {
      final controller = CardSwiperController();

      expect(controller.events.isBroadcast, isTrue);

      controller.dispose();

      expect(
        () => controller.swipe(CardSwiperDirection.left),
        throwsStateError,
      );
    });

    for (final direction in [
      CardSwiperDirection.left,
      CardSwiperDirection.right,
      CardSwiperDirection.top,
      CardSwiperDirection.bottom,
    ]) {
      testWidgets('swipe([direction]) should swipe the card to the [direction]',
          (tester) async {
        final controller = CardSwiperController();
        var detectedDirection = CardSwiperDirection.none;

        await tester.pumpApp(
          CardSwiper(
            controller: controller,
            cardsCount: 10,
            cardBuilder: genericBuilder,
            onSwipe: (oldIndex, currentIndex, swipeDirection) {
              detectedDirection = swipeDirection;
              return true;
            },
          ),
        );

        controller.swipe(direction);
        await tester.pumpAndSettle();

        expect(detectedDirection, direction);
      });

      testWidgets('undo() should undo the last swipe [direction]',
          (tester) async {
        final controller = CardSwiperController();
        var detectedDirection = CardSwiperDirection.none;

        await tester.pumpApp(
          CardSwiper(
            controller: controller,
            cardsCount: 10,
            cardBuilder: genericBuilder,
            onUndo: (_, __, swipeDirection) {
              detectedDirection = swipeDirection;
              return true;
            },
          ),
        );

        controller.swipe(direction);
        await tester.pumpAndSettle();

        expect(find.card(1), findsOneWidget);

        controller.undo();
        await tester.pumpAndSettle();

        expect(find.card(0), findsOneWidget);
        expect(detectedDirection, direction);
      });
    }

    testWidgets('should not undo if onUndo returns false', (tester) async {
      final controller = CardSwiperController();

      await tester.pumpApp(
        CardSwiper(
          controller: controller,
          cardsCount: 10,
          cardBuilder: genericBuilder,
          onUndo: (_, __, swipeDirection) {
            return false;
          },
        ),
      );

      controller.swipe(CardSwiperDirection.left);
      await tester.pumpAndSettle();

      controller.undo();
      await tester.pumpAndSettle();

      expect(find.card(0), findsNothing);
    });
  });
}
