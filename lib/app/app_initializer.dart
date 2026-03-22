import 'package:flutter/widgets.dart';

abstract final class AppInitializer {
  static Future<void> ensureInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();
  }
}
