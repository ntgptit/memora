import 'package:flutter/foundation.dart';

abstract final class Logger {
  static void debug(String message) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('[Memora] $message');
  }
}
