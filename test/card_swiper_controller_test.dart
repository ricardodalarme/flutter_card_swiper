import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers/card_builder.dart';
import 'test_helpers/finders.dart';
import 'test_helpers/pump_app.dart';

void main() {
  group('CardSwiperController', () {
    test('swipe() should change the state to swipe', () {
      final controller = CardSwiperController();
      controller.swipe();
      expect(controller.state, CardSwiperState.swipe);
    });

    test('swipeLeft() should change the state to swipeLeft', () {
      final controller = CardSwiperController();
      controller.swipeLeft();
      expect(controller.state, CardSwiperState.swipeLeft);
    });

    test('swipeRight() should change the state to swipeRight', () {
      final controller = CardSwiperController();
      controller.swipeRight();
      expect(controller.state, CardSwiperState.swipeRight);
    });

    test('swipeTop() should change the state to swipeTop', () {
      final controller = CardSwiperController();
      controller.swipeTop();
      expect(controller.state, CardSwiperState.swipeTop);
    });

    test('swipeBottom() should change the state to swipeBottom', () {
      final controller = CardSwiperController();
      controller.swipeBottom();
      expect(controller.state, CardSwiperState.swipeBottom);
    });

    test('undo() changes state to undo', () {
      final controller = CardSwiperController();
      controller.undo();
      expect(controller.state, CardSwiperState.undo);
    });

    for (final isDisabled in [false, true]) {
      group('isDisabled=$isDisabled', () {
        testWidgets('swipe() should swipe the card to the defined direction',
            (tester) async {
          final controller = CardSwiperController();
          var direction = CardSwiperDirection.none;

          await tester.pumpApp(
            CardSwiper(
              isDisabled: isDisabled,
              controller: controller,
              cardsCount: 10,
              cardBuilder: genericBuilder,
              direction: CardSwiperDirection.top,
              onSwipe: (oldIndex, currentIndex, swipeDirection) {
                direction = swipeDirection;
                return true;
              },
            ),
          );

          controller.swipe();
          await tester.pumpAndSettle();

          expect(direction, CardSwiperDirection.top);
        });

        testWidgets('swipeLeft() should swipe the card to the left',
            (tester) async {
          final controller = CardSwiperController();
          var direction = CardSwiperDirection.none;

          await tester.pumpApp(
            CardSwiper(
              isDisabled: isDisabled,
              controller: controller,
              cardsCount: 10,
              cardBuilder: genericBuilder,
              direction: CardSwiperDirection.left,
              onSwipe: (oldIndex, currentIndex, swipeDirection) {
                direction = swipeDirection;
                return true;
              },
            ),
          );

          controller.swipeLeft();
          await tester.pumpAndSettle();

          expect(direction, CardSwiperDirection.left);
        });

        testWidgets('swipeRight() should swipe the card to the right',
            (tester) async {
          final controller = CardSwiperController();
          var direction = CardSwiperDirection.none;

          await tester.pumpApp(
            CardSwiper(
              isDisabled: isDisabled,
              controller: controller,
              cardsCount: 10,
              cardBuilder: genericBuilder,
              onSwipe: (oldIndex, currentIndex, swipeDirection) {
                direction = swipeDirection;
                return true;
              },
            ),
          );

          controller.swipeRight();
          await tester.pumpAndSettle();

          expect(direction, CardSwiperDirection.right);
        });

        testWidgets('swipeTop() should swipe the card to the top',
            (tester) async {
          final controller = CardSwiperController();
          var direction = CardSwiperDirection.none;

          await tester.pumpApp(
            CardSwiper(
              isDisabled: isDisabled,
              controller: controller,
              cardsCount: 10,
              cardBuilder: genericBuilder,
              direction: CardSwiperDirection.top,
              onSwipe: (oldIndex, currentIndex, swipeDirection) {
                direction = swipeDirection;
                return true;
              },
            ),
          );

          controller.swipeTop();
          await tester.pumpAndSettle();

          expect(direction, CardSwiperDirection.top);
        });

        testWidgets('swipeBottom() should swipe the card to the bottom',
            (tester) async {
          final controller = CardSwiperController();
          var direction = CardSwiperDirection.none;

          await tester.pumpApp(
            CardSwiper(
              isDisabled: isDisabled,
              controller: controller,
              cardsCount: 10,
              cardBuilder: genericBuilder,
              direction: CardSwiperDirection.bottom,
              onSwipe: (oldIndex, currentIndex, swipeDirection) {
                direction = swipeDirection;
                return true;
              },
            ),
          );

          controller.swipeBottom();
          await tester.pumpAndSettle();

          expect(direction, CardSwiperDirection.bottom);
        });

        group('undo()', () {
          testWidgets('should undo the last swipe', (tester) async {
            final controller = CardSwiperController();

            await tester.pumpApp(
              CardSwiper(
                isDisabled: isDisabled,
                controller: controller,
                cardsCount: 10,
                cardBuilder: genericBuilder,
              ),
            );

            controller.swipe();
            await tester.pumpAndSettle();

            expect(find.card(1), findsOneWidget);

            controller.undo();
            await tester.pumpAndSettle();

            expect(find.card(0), findsOneWidget);
          });

          testWidgets('should undo the last swipe left', (tester) async {
            final controller = CardSwiperController();
            var direction = CardSwiperDirection.none;

            await tester.pumpApp(
              CardSwiper(
                isDisabled: isDisabled,
                controller: controller,
                cardsCount: 10,
                cardBuilder: genericBuilder,
                onUndo: (_, __, swipeDirection) {
                  direction = swipeDirection;
                  return true;
                },
              ),
            );

            controller.swipeLeft();
            await tester.pumpAndSettle();

            expect(find.card(1), findsOneWidget);

            controller.undo();
            await tester.pumpAndSettle();

            expect(find.card(0), findsOneWidget);
            expect(direction, CardSwiperDirection.left);
          });

          testWidgets('should undo the last swipe right', (tester) async {
            final controller = CardSwiperController();
            var direction = CardSwiperDirection.none;

            await tester.pumpApp(
              CardSwiper(
                isDisabled: isDisabled,
                controller: controller,
                cardsCount: 10,
                cardBuilder: genericBuilder,
                onUndo: (_, __, swipeDirection) {
                  direction = swipeDirection;
                  return true;
                },
              ),
            );

            controller.swipeRight();
            await tester.pumpAndSettle();

            expect(find.card(1), findsOneWidget);

            controller.undo();
            await tester.pumpAndSettle();

            expect(find.card(0), findsOneWidget);
            expect(direction, CardSwiperDirection.right);
          });

          testWidgets('should undo the last swipe top', (tester) async {
            final controller = CardSwiperController();
            var direction = CardSwiperDirection.none;

            await tester.pumpApp(
              CardSwiper(
                isDisabled: isDisabled,
                controller: controller,
                cardsCount: 10,
                cardBuilder: genericBuilder,
                onUndo: (_, __, swipeDirection) {
                  direction = swipeDirection;
                  return true;
                },
              ),
            );

            controller.swipeTop();
            await tester.pumpAndSettle();

            expect(find.card(1), findsOneWidget);

            controller.undo();
            await tester.pumpAndSettle();

            expect(find.card(0), findsOneWidget);
            expect(direction, CardSwiperDirection.top);
          });

          testWidgets('should undo the last swipe bottom', (tester) async {
            final controller = CardSwiperController();
            var direction = CardSwiperDirection.none;

            await tester.pumpApp(
              CardSwiper(
                isDisabled: isDisabled,
                controller: controller,
                cardsCount: 10,
                cardBuilder: genericBuilder,
                onUndo: (_, __, swipeDirection) {
                  direction = swipeDirection;
                  return true;
                },
              ),
            );

            controller.swipeBottom();
            await tester.pumpAndSettle();

            expect(find.card(1), findsOneWidget);

            controller.undo();
            await tester.pumpAndSettle();

            expect(find.card(0), findsOneWidget);
            expect(direction, CardSwiperDirection.bottom);
          });

          testWidgets('should not undo if onUndo returns false',
              (tester) async {
            final controller = CardSwiperController();

            await tester.pumpApp(
              CardSwiper(
                isDisabled: isDisabled,
                controller: controller,
                cardsCount: 10,
                cardBuilder: genericBuilder,
                onUndo: (_, __, swipeDirection) {
                  return false;
                },
              ),
            );

            controller.swipe();
            await tester.pumpAndSettle();

            controller.undo();
            await tester.pumpAndSettle();

            expect(find.card(0), findsNothing);
          });
        });
      });
    }
  });
}
