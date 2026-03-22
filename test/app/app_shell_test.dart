import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/app/app.dart';

void main() {
  testWidgets('App shell shows bottom navigation and switches root tabs', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text("Today's overview"), findsOneWidget);

    await tester.tap(find.text('Folders'));
    await tester.pumpAndSettle();

    expect(find.text('Folder hub is ready'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings center is ready'), findsOneWidget);
  });

  testWidgets('App shell switches to navigation rail on large screens', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    tester.view.physicalSize = const Size(1440, 1024);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });
}
