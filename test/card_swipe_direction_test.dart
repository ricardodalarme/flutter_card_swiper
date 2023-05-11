import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CardSwipeDirection.all() has all directions as true', () {
    const directions = AllowedSwipeDirection.all();
    expect(directions.up, true);
    expect(directions.down, true);
    expect(directions.right, true);
    expect(directions.left, true);
  });

  test('CardSwipeDirection.none() has all directions as false', () {
    const directions = AllowedSwipeDirection.none();
    expect(directions.up, false);
    expect(directions.down, false);
    expect(directions.right, false);
    expect(directions.left, false);
  });

  group('CardSwipeDirection.only() tests', () {
    test('CardSwipeDirection.only(up:true) has only the up direction as true',
        () {
      final directions = AllowedSwipeDirection.only(up: true);
      expect(directions.up, true);
      expect(directions.down, false);
      expect(directions.right, false);
      expect(directions.left, false);
    });

    test(
        'CardSwipeDirection.only(down:true) has only the set direction as true',
        () {
      final directions = AllowedSwipeDirection.only(down: true);
      expect(directions.up, false);
      expect(directions.down, true);
      expect(directions.right, false);
      expect(directions.left, false);
    });

    test(
        'CardSwipeDirection.only(right:true) has only the set direction as true',
        () {
      final directions = AllowedSwipeDirection.only(right: true);
      expect(directions.up, false);
      expect(directions.down, false);
      expect(directions.right, true);
      expect(directions.left, false);
    });

    test(
        'CardSwipeDirection.only(left:true) has only the set direction as true',
        () {
      final directions = AllowedSwipeDirection.only(left: true);
      expect(directions.up, false);
      expect(directions.down, false);
      expect(directions.right, false);
      expect(directions.left, true);
    });
  });

  group('CardSwipeDirection.symmetric() tests', () {
    test(
        'CardSwipeDirection.symmetric(horizontal:true) has left and right as true',
        () {
      final directions = AllowedSwipeDirection.symmetric(horizontal: true);
      expect(directions.up, false);
      expect(directions.down, false);
      expect(directions.right, true);
      expect(directions.left, true);
    });

    test('CardSwipeDirection.symmetric(vertical:true) has up and down as true',
        () {
      final directions = AllowedSwipeDirection.symmetric(vertical: true);
      expect(directions.up, true);
      expect(directions.down, true);
      expect(directions.right, false);
      expect(directions.left, false);
    });
  });
}
