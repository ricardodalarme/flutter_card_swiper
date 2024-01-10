import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

extension Gestures on WidgetTester {
  Future<void> dragLeft(Key key, {double offset = -300}) async {
    return drag(find.byKey(key), Offset(offset, 0));
  }

  Future<void> dragRight(Key key, {double offset = 300}) async {
    return drag(find.byKey(key), Offset(offset, 0));
  }

  Future<void> dragUp(Key key, {double offset = -300}) async {
    return drag(find.byKey(key), Offset(0, offset));
  }

  Future<void> dragDown(Key key, {double offset = 300}) async {
    return drag(find.byKey(key), Offset(0, offset));
  }
}
