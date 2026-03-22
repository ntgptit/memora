import 'package:flutter/material.dart';

class DialogService {
  const DialogService(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  Future<T?> showAppDialog<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    RouteSettings? routeSettings,
  }) {
    final context = navigatorKey.currentContext;
    if (context == null) {
      return Future<T?>.error(
        StateError('DialogService requires a mounted Navigator context.'),
      );
    }

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      routeSettings: routeSettings,
      builder: builder,
    );
  }
}
