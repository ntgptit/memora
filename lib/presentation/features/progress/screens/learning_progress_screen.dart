import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/app/app_routes.dart';
import 'package:memora/core/theme/extensions/screen_context_ext.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/progress/providers/progress_filter_provider.dart';
import 'package:memora/presentation/features/progress/providers/progress_provider.dart';
import 'package:memora/presentation/features/progress/providers/progress_state.dart';
import 'package:memora/presentation/features/progress/widgets/due_flashcard_section.dart';
import 'package:memora/presentation/features/progress/widgets/progress_chart_section.dart';
import 'package:memora/presentation/features/progress/widgets/progress_filter_bar.dart';
import 'package:memora/presentation/features/progress/widgets/progress_history_list.dart';
import 'package:memora/presentation/features/progress/widgets/progress_summary_card.dart';
import 'package:memora/presentation/features/progress/widgets/streak_calendar.dart';
import 'package:memora/presentation/shared/layouts/app_list_page_layout.dart';
import 'package:memora/presentation/shared/layouts/app_split_view_layout.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_text_button.dart';

class LearningProgressScreen extends ConsumerWidget {
  const LearningProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(progressFilterControllerProvider);
    final state = ref.watch(progressControllerProvider);
    final filterController = ref.read(
      progressFilterControllerProvider.notifier,
    );
    final progressController = ref.read(progressControllerProvider.notifier);

    return AppListPageLayout(
      title: Text(context.l10n.progressTitle),
      subtitle: Text(context.l10n.progressOverviewSubtitle),
      header: _ProgressActionsRow(recommendation: state.recommendation),
      filters: ProgressFilterBar(
        period: filter.period,
        onPeriodChanged: filterController.setPeriod,
        onRefresh: progressController.refresh,
      ),
      body: SingleChildScrollView(child: _ProgressOverviewBody(state: state)),
    );
  }
}

class _ProgressOverviewBody extends StatelessWidget {
  const _ProgressOverviewBody({required this.state});

  final ProgressState state;

  @override
  Widget build(BuildContext context) {
    final deckProgressAction = state.recommendation == null
        ? null
        : () => context.push(
            AppRoutes.deckProgress(state.recommendation!.deckId),
          );

    if (context.screenClass.canUseSplitView) {
      return AppSplitViewLayout(
        primary: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProgressSummaryCard(state: state),
            SizedBox(height: context.spacing.lg),
            ProgressChartSection(state: state),
            SizedBox(height: context.spacing.lg),
            ProgressHistoryList(state: state),
          ],
        ),
        secondary: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DueFlashcardSection(
              state: state,
              onOpenDeckProgress: deckProgressAction,
            ),
            SizedBox(height: context.spacing.lg),
            StreakCalendar(streakDays: state.streakDays),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProgressSummaryCard(state: state),
        SizedBox(height: context.spacing.lg),
        DueFlashcardSection(
          state: state,
          onOpenDeckProgress: deckProgressAction,
        ),
        SizedBox(height: context.spacing.lg),
        ProgressChartSection(state: state),
        SizedBox(height: context.spacing.lg),
        StreakCalendar(streakDays: state.streakDays),
        SizedBox(height: context.spacing.lg),
        ProgressHistoryList(state: state),
      ],
    );
  }
}

class _ProgressActionsRow extends StatelessWidget {
  const _ProgressActionsRow({this.recommendation});

  final ProgressRecommendation? recommendation;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.spacing.sm,
      runSpacing: context.spacing.sm,
      children: [
        AppTextButton(
          text: context.l10n.progressCalendarActionLabel,
          onPressed: () => context.push(AppRoutes.progressCalendar),
        ),
        if (recommendation != null)
          AppPrimaryButton(
            text: context.l10n.progressDeckProgressActionLabel,
            onPressed: () =>
                context.push(AppRoutes.deckProgress(recommendation!.deckId)),
          ),
      ],
    );
  }
}
