import 'package:flutter/material.dart';

class DialogService {
  const DialogService(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  BuildContext? get currentContext => navigatorKey.currentContext;
  bool get isAvailable => currentContext != null;

  Future<T?> showAppDialog<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    RouteSettings? routeSettings,
    bool useRootNavigator = true,
  }) {
    final context = currentContext;
    if (context == null) {
      return Future<T?>.error(
        StateError('DialogService requires a mounted Navigator context.'),
      );
    }

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      builder: builder,
    );
  }

  void close<T extends Object?>([T? result]) {
    final context = currentContext;
    if (context == null) {
      return;
    }

    final navigator = Navigator.of(context, rootNavigator: true);
    if (!navigator.canPop()) {
      return;
    }

    navigator.pop<T>(result);
  }
}
