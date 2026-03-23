import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/app/app_routes.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/progress/providers/progress_filter_provider.dart';
import 'package:memora/presentation/features/progress/providers/progress_provider.dart';
import 'package:memora/presentation/features/progress/widgets/progress_chart_section.dart';
import 'package:memora/presentation/features/progress/widgets/progress_filter_bar.dart';
import 'package:memora/presentation/features/progress/widgets/progress_history_list.dart';
import 'package:memora/presentation/features/progress/widgets/streak_calendar.dart';
import 'package:memora/presentation/shared/composites/states/app_error_state.dart';
import 'package:memora/presentation/shared/composites/states/app_loading_state.dart';
import 'package:memora/presentation/shared/layouts/app_detail_page_layout.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_text_button.dart';

class StudyCalendarScreen extends ConsumerWidget {
  const StudyCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(progressFilterControllerProvider);
    final asyncState = ref.watch(progressControllerProvider);
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
          if (asyncState.asData?.value.recommendation
              case final recommendation?)
            Wrap(
              spacing: context.spacing.sm,
              runSpacing: context.spacing.sm,
              children: [
                AppTextButton(
                  text: context.l10n.progressDeckProgressActionLabel,
                  onPressed: () => context.push(
                    AppRoutes.deckProgress(recommendation.deckId),
                  ),
                ),
              ],
            ),
          if (asyncState.asData?.value.recommendation != null)
            SizedBox(height: context.spacing.md),
          ProgressFilterBar(
            period: filter.period,
            onPeriodChanged: filterController.setPeriod,
            onRefresh: progressController.refresh,
          ),
        ],
      ),
      body: asyncState.when(
        loading: () => AppLoadingState(
          message: context.l10n.loading,
          subtitle: context.l10n.progressLoadingMessage,
        ),
        error: (error, _) => AppErrorState(
          title: context.l10n.progressErrorTitle,
          message: context.l10n.progressLoadErrorMessage,
          details: kDebugMode ? error.toString() : null,
          primaryActionLabel: context.l10n.retry,
          onPrimaryAction: progressController.refresh,
        ),
        data: (state) => SingleChildScrollView(
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
      ),
    );
  }
}
