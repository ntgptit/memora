import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/theme/app_theme.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/presentation/shared/primitives/selections/app_checkbox.dart';
import 'package:memora/presentation/shared/primitives/selections/app_radio.dart';
import 'package:memora/presentation/shared/primitives/selections/app_segmented_control.dart';
import 'package:memora/presentation/shared/primitives/selections/app_switch.dart';
import 'package:memora/presentation/shared/primitives/selections/app_toggle.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(screenInfo: const ScreenInfo.fallback()),
      home: Scaffold(body: Center(child: child)),
    );
  }

  testWidgets('selection primitives render', (tester) async {
    await tester.pumpWidget(
      wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppCheckbox(value: true, onChanged: (_) {}),
            AppRadio<int>(value: 1, groupValue: 1, onChanged: (_) {}),
            AppSwitch(value: true, onChanged: (_) {}),
            AppToggle(
              isSelected: const [true, false],
              onPressed: (_) {},
              children: const [Text('A'), Text('B')],
            ),
            AppSegmentedControl<int>(
              segments: const [
                ButtonSegment(value: 1, label: Text('One')),
                ButtonSegment(value: 2, label: Text('Two')),
              ],
              selected: const {1},
              onSelectionChanged: (_) {},
            ),
          ],
        ),
      ),
    );

    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.byType(Radio<int>), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
    expect(find.byType(ToggleButtons), findsOneWidget);
    expect(find.byType(SegmentedButton<int>), findsOneWidget);
  });
}
