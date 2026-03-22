import 'package:flutter/material.dart';

class SnackbarService {
  const SnackbarService(this.messengerKey);

  final GlobalKey<ScaffoldMessengerState> messengerKey;

  void show(
    String message, {
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  }) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message), action: action, duration: duration),
    );
  }

  void clear() {
    messengerKey.currentState?.clearSnackBars();
  }
}
