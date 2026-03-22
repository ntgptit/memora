import 'package:flutter/material.dart';

class BottomSheetService {
  const BottomSheetService(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  Future<T?> show<T>({
    required WidgetBuilder builder,
    bool isScrollControlled = false,
    Color? backgroundColor,
  }) {
    final context = navigatorKey.currentContext;
    if (context == null) {
      return Future<T?>.error(
        StateError('BottomSheetService requires a mounted Navigator context.'),
      );
    }

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      builder: builder,
    );
  }
}
