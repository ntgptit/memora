import 'package:flutter/widgets.dart';
import 'package:memora/app/app.dart';
import 'package:memora/app/app_initializer.dart';

Future<void> main() async {
  final container = await AppInitializer.ensureInitialized();
  runApp(App(container: container));
}
