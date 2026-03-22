import 'package:flutter/widgets.dart';

abstract final class RouteUtils {
  static String? currentRouteName(BuildContext context) {
    return ModalRoute.of(context)?.settings.name;
  }

  static bool isCurrentRoute(BuildContext context, String routeName) {
    return currentRouteName(context) == routeName;
  }

  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  static bool popIfPossible<T extends Object?>(
    BuildContext context, [
    T? result,
  ]) {
    if (!canPop(context)) {
      return false;
    }
    Navigator.of(context).pop(result);
    return true;
  }
}
