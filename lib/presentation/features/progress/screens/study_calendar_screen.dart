import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memora/app/app_route_data.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/progress/providers/progress_filter_provider.dart';
import 'package:memora/presentation/features/progress/providers/progress_provider.dart';
import 'package:memora/presentation/features/progress/widgets/progress_chart_section.dart';
import 'package:memora/presentation/features/progress/widgets/progress_filter_bar.dart';
import 'package:memora/presentation/features/progress/widgets/progress_history_list.dart';
import 'package:memora/presentation/features/progress/widgets/streak_calendar.dart';
import 'package:memora/presentation/shared/layouts/app_detail_page_layout.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_text_button.dart';

class StudyCalendarScreen extends ConsumerWidget {
  const StudyCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(progressFilterControllerProvider);
    final state = ref.watch(progressControllerProvider);
    final filterController = ref.read(
      progressFilterControllerProvider.notifier,
    );
    final progressController = ref.read(progressControllerProvider.notifier);

    return AppDetailPageLayout(
      title: Text(context.l10n.progressCalendarScreenTitle),
      subtitle: Text(context.l10n.progressCalendarScreenSubtitle),
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.recommendation case final recommendation?)
            Wrap(
              spacing: context.spacing.sm,
              runSpacing: context.spacing.sm,
              children: [
                AppTextButton(
                  text: context.l10n.progressDeckProgressActionLabel,
                  onPressed: () =>
                      DeckProgressRouteData(deckId: recommendation.deckId).push(
                        context,
                      ),
                ),
              ],
            ),
          if (state.recommendation != null)
            SizedBox(height: context.spacing.md),
          ProgressFilterBar(
            period: filter.period,
            onPeriodChanged: filterController.setPeriod,
            onRefresh: progressController.refresh,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreakCalendar(streakDays: state.streakDays),
            SizedBox(height: context.spacing.lg),
            ProgressHistoryList(state: state),
            SizedBox(height: context.spacing.lg),
            ProgressChartSection(state: state),
          ],
        ),
      ),
    );
  }
}
