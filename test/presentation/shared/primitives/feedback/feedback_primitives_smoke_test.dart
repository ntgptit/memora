import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/enums/snackbar_type.dart';
import 'package:memora/core/theme/app_theme.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_banner.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_circular_loader.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_linear_loader.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_loader.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_shimmer.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_snackbar.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_tooltip.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(screenInfo: const ScreenInfo.fallback()),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Center(child: child)),
    );
  }

  testWidgets('feedback primitives render', (tester) async {
    await tester.pumpWidget(
      wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLoader(
              semanticsLabel: 'Generic loader',
              child: const Text('Loading shell'),
            ),
            const SizedBox(height: 16),
            const AppCircularLoader(),
            const SizedBox(height: 16),
            const AppLinearLoader(value: 0.4),
            const SizedBox(height: 16),
            const AppShimmer(
              child: SizedBox(
                width: 120,
                height: 16,
                child: ColoredBox(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            const AppTooltip(
              message: 'Tooltip text',
              child: Icon(Icons.info_rounded),
            ),
            const SizedBox(height: 16),
            AppSnackbar(
              title: 'Saved',
              message: 'Your changes were stored.',
              type: SnackbarType.success,
              actionLabel: 'Undo',
              onActionPressed: _noop,
            ),
            const SizedBox(height: 16),
            const AppBanner(
              title: 'Offline',
              message: 'You are currently offline.',
              type: SnackbarType.warning,
            ),
          ],
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Loading shell'), findsOneWidget);
    expect(find.byType(AppCircularLoader), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.byType(AppShimmer), findsOneWidget);
    expect(find.byType(Tooltip), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Your changes were stored.'), findsOneWidget);
    expect(find.text('Undo'), findsOneWidget);
    expect(find.text('Offline'), findsOneWidget);
    expect(find.text('You are currently offline.'), findsOneWidget);
  });
}

void _noop() {}
