import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/theme/app_theme.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/core/enums/snackbar_type.dart';
import 'package:memora/presentation/shared/primitives/displays/app_avatar.dart';
import 'package:memora/presentation/shared/primitives/displays/app_badge.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';
import 'package:memora/presentation/shared/primitives/displays/app_counter_badge.dart';
import 'package:memora/presentation/shared/primitives/displays/app_divider.dart';
import 'package:memora/presentation/shared/primitives/displays/app_label.dart';
import 'package:memora/presentation/shared/primitives/displays/app_outlined_card.dart';
import 'package:memora/presentation/shared/primitives/displays/app_pill.dart';
import 'package:memora/presentation/shared/primitives/displays/app_progress_bar.dart';
import 'package:memora/presentation/shared/primitives/displays/app_surface.dart';
import 'package:memora/presentation/shared/primitives/displays/app_tag.dart';
import 'package:memora/presentation/shared/primitives/displays/app_value_text.dart';
import 'package:memora/presentation/shared/primitives/displays/app_vertical_divider.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_banner.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_circular_loader.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_linear_loader.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_loader.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_shimmer.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_snackbar.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_tooltip.dart';
import 'package:memora/presentation/shared/primitives/layout/app_constrained_box.dart';
import 'package:memora/presentation/shared/primitives/layout/app_gap.dart';
import 'package:memora/presentation/shared/primitives/layout/app_spacing.dart';
import 'package:memora/presentation/shared/primitives/layout/app_responsive_container.dart';
import 'package:memora/presentation/shared/primitives/layout/app_safe_area.dart';
import 'package:memora/presentation/shared/primitives/selections/app_checkbox.dart';
import 'package:memora/presentation/shared/primitives/selections/app_radio.dart';
import 'package:memora/presentation/shared/primitives/selections/app_segmented_control.dart';
import 'package:memora/presentation/shared/primitives/selections/app_switch.dart';
import 'package:memora/presentation/shared/primitives/selections/app_toggle.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_caption_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_link_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_title_text.dart';

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

  testWidgets('display, feedback, selection, layout, and text primitives render',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSurface(child: Padding(padding: EdgeInsets.all(8), child: Text('surface'))),
            const SizedBox(height: 12),
            const AppOutlinedCard(child: Text('outlined card')),
            const SizedBox(height: 12),
            const AppAvatar(child: Text('A')),
            const SizedBox(height: 12),
            const AppBadge(label: Text('3'), child: Icon(Icons.mail_rounded)),
            const SizedBox(height: 12),
            const AppChip(label: Text('chip')),
            const SizedBox(height: 12),
            const AppTag(label: 'tag'),
            const SizedBox(height: 12),
            const AppPill(child: Text('pill')),
            const SizedBox(height: 12),
            const AppDivider(),
            const AppVerticalDivider(width: 24),
            const AppLabel(text: 'label'),
            const AppValueText(text: 'value'),
            const AppCounterBadge(count: 12, child: Icon(Icons.inbox_rounded)),
            const AppProgressBar(value: 0.4),
            const SizedBox(height: 12),
            const AppLoader(child: Text('loader')),
            const AppCircularLoader(),
            const AppLinearLoader(),
            AppShimmer(child: Container(width: 120, height: 16, color: Colors.white)),
            const AppTooltip(message: 'tip', child: Icon(Icons.help_outline_rounded)),
            const AppSnackbar(message: 'snackbar'),
            const AppBanner(message: 'banner message', title: 'banner'),
            const AppCheckbox(value: true, onChanged: null),
            const AppRadio<int>(value: 1, groupValue: 1, onChanged: null),
            const AppSwitch(value: true, onChanged: null),
            AppToggle(
              isSelected: const [true, false],
              onPressed: (_) {},
              children: const [Text('one'), Text('two')],
            ),
            AppSegmentedControl<int>(
              segments: const [
                ButtonSegment<int>(value: 1, label: Text('One')),
                ButtonSegment<int>(value: 2, label: Text('Two')),
              ],
              selected: const {1},
              onSelectionChanged: (_) {},
            ),
            const AppGap(size: 8),
            const AppSpacing(size: AppSpacingSize.md),
            const AppSafeArea(child: Text('safe')),
            const AppConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 160),
              child: Text('constrained'),
            ),
            const AppResponsiveContainer(child: Text('responsive')),
            const AppText(text: 'plain text'),
            const AppTitleText(text: 'title text'),
            const AppBodyText(text: 'body text'),
            const AppCaptionText(text: 'caption text'),
            AppLinkText(
              text: 'link text',
              onTap: () {},
            ),
            const SizedBox(height: 8),
            const AppProgressBar(value: 0.7),
            const AppCircularLoader(semanticsLabel: 'circular loader'),
            const AppLinearLoader(),
            AppShimmer(
              child: Container(width: 80, height: 12, color: Colors.white),
            ),
            const AppBanner(
              message: 'warn',
              title: 'warn',
              type: SnackbarType.warning,
            ),
          ],
        ),
      ),
    );

    expect(find.text('surface'), findsOneWidget);
    expect(find.text('outlined card'), findsOneWidget);
    expect(find.text('chip'), findsOneWidget);
    expect(find.text('tag'), findsOneWidget);
    expect(find.text('pill'), findsOneWidget);
    expect(find.text('label'), findsOneWidget);
    expect(find.text('value'), findsOneWidget);
    expect(find.text('loader'), findsOneWidget);
    expect(find.text('snackbar'), findsOneWidget);
    expect(find.text('banner'), findsOneWidget);
    expect(find.text('plain text'), findsOneWidget);
    expect(find.text('title text'), findsOneWidget);
    expect(find.text('body text'), findsOneWidget);
    expect(find.text('caption text'), findsOneWidget);
    expect(find.text('link text'), findsOneWidget);
  });
}
