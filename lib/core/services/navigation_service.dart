import 'package:flutter/material.dart';

class NavigationService {
  const NavigationService(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  Future<T?> push<T extends Object?>(Route<T> route) {
    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      return Future<T?>.error(
        StateError('NavigationService requires a mounted NavigatorState.'),
      );
    }

    return navigator.push<T>(route);
  }

  Future<bool> maybePop<T extends Object?>([T? result]) async {
    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      return false;
    }

    return navigator.maybePop<T>(result);
  }

  void pop<T extends Object?>([T? result]) {
    final navigator = navigatorKey.currentState;
    if (navigator == null || !navigator.canPop()) {
      return;
    }

    navigator.pop<T>(result);
  }
}
