import 'package:flutter_test/flutter_test.dart';

import 'card_builder.dart';

extension Finders on CommonFinders {
  Finder card(int index) {
    return find.text(getIndexText(index));
  }
}
