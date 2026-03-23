import 'package:flutter/material.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/progress/providers/progress_filter_provider.dart';
import 'package:memora/presentation/shared/composites/forms/app_filter_bar.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_icon_button.dart';
import 'package:memora/presentation/shared/primitives/displays/app_label.dart';
import 'package:memora/presentation/shared/primitives/selections/app_segmented_control.dart';

class ProgressFilterBar extends StatelessWidget {
  const ProgressFilterBar({
    super.key,
    required this.period,
    required this.onPeriodChanged,
    this.onRefresh,
  });

  final ProgressPeriod period;
  final ValueChanged<ProgressPeriod> onPeriodChanged;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppFilterBar(
      title: AppLabel(text: l10n.progressFilterTitle),
      trailing: onRefresh == null
          ? null
          : AppIconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: l10n.progressRefreshTooltip,
              onPressed: onRefresh,
            ),
      filters: [
        AppSegmentedControl<ProgressPeriod>(
          segments: [
            ButtonSegment(
              value: ProgressPeriod.today,
              label: Text(l10n.progressPeriodTodayLabel),
              icon: const Icon(Icons.today_rounded),
            ),
            ButtonSegment(
              value: ProgressPeriod.week,
              label: Text(l10n.progressPeriodWeekLabel),
              icon: const Icon(Icons.view_week_rounded),
            ),
            ButtonSegment(
              value: ProgressPeriod.month,
              label: Text(l10n.progressPeriodMonthLabel),
              icon: const Icon(Icons.calendar_month_rounded),
            ),
          ],
          selected: {period},
          onSelectionChanged: (selection) {
            if (selection.isEmpty) {
              return;
            }
            onPeriodChanged(selection.first);
          },
          emptySelectionAllowed: false,
          showSelectedIcon: true,
        ),
      ],
    );
  }
}
