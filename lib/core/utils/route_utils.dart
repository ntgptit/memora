import 'package:flutter/widgets.dart';

abstract final class RouteUtils {
  static String? currentRouteName(BuildContext context) {
    return ModalRoute.of(context)?.settings.name;
  }

  static bool isCurrentRoute(BuildContext context, String routeName) {
    return currentRouteName(context) == routeName;
  }
}
