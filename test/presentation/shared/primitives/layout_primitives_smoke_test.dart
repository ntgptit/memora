import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/theme/app_theme.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/presentation/shared/primitives/layout/app_constrained_box.dart';
import 'package:memora/presentation/shared/primitives/layout/app_gap.dart';
import 'package:memora/presentation/shared/primitives/layout/app_responsive_container.dart';
import 'package:memora/presentation/shared/primitives/layout/app_safe_area.dart';
import 'package:memora/presentation/shared/primitives/layout/app_spacing.dart';

void main() {
  Widget wrapWithApp(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(screenInfo: const ScreenInfo.fallback()),
      home: child,
    );
  }

  testWidgets('layout primitives render and resolve spacing tokens', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapWithApp(
        AppSafeArea(
          child: AppResponsiveContainer(
            child: Column(
              children: const [
                AppGap(size: 12),
                AppSpacing(size: AppSpacingSize.section),
                AppConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 320),
                  child: Text('Layout primitive'),
                ),
                Text('Responsive container child'),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Layout primitive'), findsOneWidget);
    expect(find.text('Responsive container child'), findsOneWidget);
  });
}
