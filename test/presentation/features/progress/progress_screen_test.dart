import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/theme/app_theme.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/progress/screens/deck_progress_screen.dart';
import 'package:memora/presentation/features/progress/screens/learning_progress_screen.dart';

void main() {
  testWidgets('Learning progress screen renders progress overview', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light(
            screenInfo: ScreenInfo.fromSize(const Size(390, 844)),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const LearningProgressScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Progress'), findsWidgets);
    expect(find.text('Study overview'), findsOneWidget);
    expect(find.text('Study calendar'), findsOneWidget);
    expect(find.text('Deck progress'), findsWidgets);
  });

  testWidgets('Deck progress screen renders selected deck tags', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light(
            screenInfo: ScreenInfo.fromSize(const Size(390, 844)),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const DeckProgressScreen(deckId: 42),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Selected deck'), findsOneWidget);
    expect(find.text('Deck #42'), findsOneWidget);
  });
}
