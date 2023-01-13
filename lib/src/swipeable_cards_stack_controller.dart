import 'package:flutter/material.dart';

typedef TriggerListener = void Function(AxisDirection dir);
typedef AppendItem = void Function(Widget item);
typedef EnableSwipe = void Function(bool dir);

class SwipeableCardsStackController {
  late TriggerListener listener;
  late AppendItem addItem;
  late EnableSwipe enableSwipeListener;

  void triggerSwipeLeft() {
    return listener.call(AxisDirection.left);
  }

  void triggerSwipeRight() {
    return listener.call(AxisDirection.right);
  }

  void triggerSwipeUp() {
    return listener.call(AxisDirection.up);
  }

  void triggerSwipeDown() {
    return listener.call(AxisDirection.down);
  }

  void appendItem(Widget item) {
    return addItem.call(item);
  }

  void enableSwipe(bool isSwipeEnabled) {
    return enableSwipeListener.call(isSwipeEnabled);
  }
}
