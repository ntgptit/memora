import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/enums/dialog_type.dart';
import 'package:memora/core/enums/snackbar_type.dart';
import 'package:memora/core/theme/app_theme.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/composites/dialogs/app_action_sheet.dart';
import 'package:memora/presentation/shared/composites/dialogs/app_alert_dialog.dart';
import 'package:memora/presentation/shared/composites/dialogs/app_bottom_sheet.dart';
import 'package:memora/presentation/shared/composites/dialogs/app_confirm_dialog.dart';
import 'package:memora/presentation/shared/composites/dialogs/app_input_dialog.dart';
import 'package:memora/presentation/shared/composites/feedback/app_retry_panel.dart';
import 'package:memora/presentation/shared/composites/feedback/app_snackbar_listener.dart';
import 'package:memora/presentation/shared/composites/feedback/app_toast_listener.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(screenInfo: const ScreenInfo.fallback()),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  testWidgets('dialogs composites render', (tester) async {
    await tester.pumpWidget(
      wrap(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppAlertDialog(
              title: 'Alert',
              content: Text('Alert content'),
              type: DialogType.warning,
            ),
            const SizedBox(height: 16),
            AppConfirmDialog(
              title: 'Confirm',
              content: const Text('Confirm content'),
              onConfirm: () {},
            ),
            const SizedBox(height: 16),
            AppInputDialog(
              title: 'Input',
              hintText: 'Enter value',
              onSubmitted: (_) {},
            ),
            const SizedBox(height: 16),
            AppBottomSheet(
              title: 'Bottom sheet',
              subtitle: 'Sheet subtitle',
              child: const Text('Sheet body'),
            ),
            const SizedBox(height: 16),
            AppActionSheet(
              title: 'Actions',
              actions: [
                AppActionSheetAction(label: 'One', onPressed: () {}),
                AppActionSheetAction(
                  label: 'Delete',
                  destructive: true,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );

    expect(find.text('Alert'), findsOneWidget);
    expect(find.text('Alert content'), findsOneWidget);
    expect(find.text('Confirm'), findsAtLeastNWidgets(1));
    expect(find.text('Confirm content'), findsOneWidget);
    expect(find.text('Input'), findsOneWidget);
    expect(find.text('Enter value'), findsOneWidget);
    expect(find.text('Bottom sheet'), findsOneWidget);
    expect(find.text('Sheet subtitle'), findsOneWidget);
    expect(find.text('Sheet body'), findsOneWidget);
    expect(find.text('Actions'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
  });

  testWidgets('feedback composites render listeners and panel', (tester) async {
    await tester.pumpWidget(
      wrap(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppRetryPanel(
              title: 'Try again',
              message: 'The operation failed.',
              onRetry: () {},
            ),
            const SizedBox(height: 16),
            AppSnackbarListener(
              message: 'Saved',
              title: 'Success',
              type: SnackbarType.success,
              child: const Text('Snack child'),
            ),
            const SizedBox(height: 16),
            AppToastListener(
              message: 'Toast message',
              title: 'Toast',
              type: SnackbarType.info,
              child: const Text('Toast child'),
            ),
          ],
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('The operation failed.'), findsOneWidget);
    expect(find.text('Saved'), findsWidgets);
    expect(find.text('Toast message'), findsWidgets);
    expect(find.text('Snack child'), findsOneWidget);
    expect(find.text('Toast child'), findsOneWidget);
  });
}
