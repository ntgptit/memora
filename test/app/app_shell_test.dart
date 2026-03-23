import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/app/app.dart';
import 'package:memora/core/di/repository_providers.dart';

import '../support/fake_auth_repository.dart';

void main() {
  testWidgets('App shell shows bottom navigation and switches root tabs', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository.authenticated(),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(App(container: container));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, 0);

    await tester.tap(find.text('Folders'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, 1);

    await tester.tap(find.text('Settings'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, 4);
  });

  testWidgets('App shell switches to navigation rail on large screens', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    tester.view.physicalSize = const Size(1440, 1024);
    tester.view.devicePixelRatio = 1;
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository.authenticated(),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(App(container: container));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(tester.widget<NavigationRail>(find.byType(NavigationRail)).selectedIndex, 0);
  });
}
