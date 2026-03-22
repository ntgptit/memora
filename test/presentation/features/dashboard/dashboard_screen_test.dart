import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/config/app_strings.dart';
import 'package:memora/core/theme/app_theme.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/presentation/features/dashboard/providers/dashboard_provider.dart';
import 'package:memora/presentation/features/dashboard/screens/dashboard_screen.dart';

void main() {
  testWidgets('Dashboard screen reacts to due deck updates', (tester) async {
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
          home: const DashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.dashboardSummaryTitle), findsOneWidget);
    expect(find.text(AppStrings.dashboardVerbsDeckTitle), findsOneWidget);

    container.read(dashboardControllerProvider.notifier).startDeck('verbs');
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.dashboardVerbsDeckTitle), findsNothing);
    expect(find.text(AppStrings.dashboardMedicalDeckTitle), findsOneWidget);
  });
}
