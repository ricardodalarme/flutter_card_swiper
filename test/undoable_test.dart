import 'package:flutter_card_swiper/src/undoable.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should store and retrieve state', () {
    final undoable = Undoable<int>(0);
    expect(undoable.state, equals(0));
    expect(undoable.previousState, isNull);
  });

  test('should store previous state when state is changed', () {
    final undoable = Undoable<int>(0);
    undoable.state = 1;
    expect(undoable.state, equals(1));
    expect(undoable.previousState, equals(0));
  });

  test('should store previous state when state is changed multiple times', () {
    final undoable = Undoable<int>(0);
    undoable.state = 1;
    undoable.state = 2;
    expect(undoable.state, equals(2));
    expect(undoable.previousState, equals(1));
  });

  test('should return previous state when undo is called', () {
    final undoable = Undoable<int>(0);
    undoable.state = 1;
    undoable.undo();
    expect(undoable.state, equals(0));
    expect(undoable.previousState, isNull);
  });

  test('should return previous state when undo is called multiple times', () {
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
