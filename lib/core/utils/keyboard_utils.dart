import 'package:flutter/widgets.dart';

abstract final class KeyboardUtils {
  static void hide() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static void dismiss(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
