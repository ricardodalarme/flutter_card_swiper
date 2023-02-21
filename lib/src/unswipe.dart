import 'package:flutter/widgets.dart';

class Unswipe {
  Widget widget;
  bool horizontal;
  bool vertical;
  int swipedDirectionHorizontal;
  int swipedDirectionVertical;

  Unswipe({
    required this.widget,
    required this.horizontal,
    required this.vertical,
    required this.swipedDirectionHorizontal,
    required this.swipedDirectionVertical,
  });
}
