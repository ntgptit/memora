import 'package:flutter/widgets.dart';

abstract final class FocusUtils {
  static void request(FocusNode node) {
    node.requestFocus();
  }

  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
