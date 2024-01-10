import 'package:flutter_card_swiper/src/utils/undoable.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('when defined the initial value expect to store and retrieve state', () {
    final undoable = Undoable<int>(0);
    expect(undoable.state, equals(0));
    expect(undoable.previousState, isNull);
  });

  test('when state is changed expect to store previous state', () {
    final undoable = Undoable<int>(0);
    undoable.state = 1;
    expect(undoable.state, equals(1));
    expect(undoable.previousState, equals(0));
  });

  test('when state is changed multiple times expect to store previous state',
      () {
    final undoable = Undoable<int>(0);
    undoable.state = 1;
    undoable.state = 2;
    expect(undoable.state, equals(2));
    expect(undoable.previousState, equals(1));
  });

  test('when undo is called expect to return previous state', () {
    final undoable = Undoable<int>(0);
    undoable.state = 1;
    undoable.undo();
    expect(undoable.state, equals(0));
    expect(undoable.previousState, isNull);
  });

  test('when undo is called multiple times expect to return previous state',
      () {
    final undoable = Undoable<int>(0);
    undoable.state = 1;
    undoable.state = 2;
    undoable.undo();
    expect(undoable.state, equals(1));
    expect(undoable.previousState, equals(0));
    undoable.undo();
    expect(undoable.state, equals(0));
    expect(undoable.previousState, isNull);
  });
}
