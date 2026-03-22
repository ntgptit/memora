import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/theme/app_theme.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/presentation/shared/composites/cards/app_action_card.dart';
import 'package:memora/presentation/shared/composites/cards/app_info_card.dart';
import 'package:memora/presentation/shared/composites/cards/app_progress_card.dart';
import 'package:memora/presentation/shared/composites/cards/app_stat_card.dart';
import 'package:memora/presentation/shared/composites/states/app_empty_state.dart';
import 'package:memora/presentation/shared/composites/states/app_error_state.dart';
import 'package:memora/presentation/shared/composites/states/app_fullscreen_loader.dart';
import 'package:memora/presentation/shared/composites/states/app_loading_state.dart';
import 'package:memora/presentation/shared/composites/states/app_no_result_state.dart';
import 'package:memora/presentation/shared/composites/states/app_offline_state.dart';
import 'package:memora/presentation/shared/composites/states/app_unauthorized_state.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/displays/app_icon.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(screenInfo: const ScreenInfo.fallback()),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  testWidgets('cards and states composites render', (tester) async {
    var actionTapped = false;

    await tester.pumpWidget(
      wrap(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppActionCard(
              title: 'Action card',
              subtitle: 'Perform a primary action',
              leading: const AppIcon(Icons.flash_on_rounded),
              primaryActionLabel: 'Primary',
              onPrimaryAction: () {},
              secondaryActionLabel: 'Secondary',
              onSecondaryAction: () {},
              onTap: () {
                actionTapped = true;
              },
            ),
            const SizedBox(height: 16),
            const AppInfoCard(
              title: 'Info card',
              subtitle: 'Useful context',
              leading: AppIcon(Icons.info_rounded),
              child: Text('Extra content'),
            ),
            const SizedBox(height: 16),
            const AppProgressCard(
              title: 'Progress card',
              subtitle: 'Study progress',
              value: 0.6,
              leading: AppIcon(Icons.timeline_rounded),
            ),
            const SizedBox(height: 16),
            const AppStatCard(
              label: 'Sessions',
              value: '12',
              subtitle: 'This week',
              leading: AppIcon(Icons.insights_rounded),
            ),
            const SizedBox(height: 16),
            AppEmptyState(
              title: 'Empty state',
              message: 'Nothing here yet.',
              icon: const AppIcon(Icons.inbox_rounded),
              actions: const [AppPrimaryButton(text: 'Create')],
            ),
            const SizedBox(height: 16),
            const AppNoResultState(message: 'No matching items'),
            const SizedBox(height: 16),
            const AppErrorState(
              title: 'Error state',
              message: 'Something failed.',
              details: 'Error code 500',
            ),
            const SizedBox(height: 16),
            const AppOfflineState(message: 'Offline now'),
            const SizedBox(height: 16),
            const AppUnauthorizedState(message: 'Please sign in'),
            const SizedBox(height: 16),
            const AppLoadingState(message: 'Loading data'),
            const SizedBox(height: 16),
            const AppFullscreenLoader(
              message: 'Syncing',
              child: Text('Base content'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Action card'));
    await tester.pump();

    expect(actionTapped, isTrue);
    expect(find.text('Action card'), findsOneWidget);
    expect(find.text('Info card'), findsOneWidget);
    expect(find.text('Progress card'), findsOneWidget);
    expect(find.text('Sessions'), findsOneWidget);
    expect(find.text('Empty state'), findsOneWidget);
    expect(find.text('No results found'), findsOneWidget);
    expect(find.text('Error state'), findsOneWidget);
    expect(find.text('You are offline'), findsOneWidget);
    expect(find.text('Access required'), findsOneWidget);
    expect(find.text('Loading data'), findsOneWidget);
    expect(find.text('Base content'), findsOneWidget);
  });
}
