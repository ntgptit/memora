import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/app/app_routes.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/progress/providers/progress_filter_provider.dart';
import 'package:memora/presentation/features/progress/providers/progress_provider.dart';
import 'package:memora/presentation/features/progress/providers/progress_state.dart';
import 'package:memora/presentation/features/progress/widgets/progress_chart_section.dart';
import 'package:memora/presentation/features/progress/widgets/progress_filter_bar.dart';
import 'package:memora/presentation/features/progress/widgets/progress_history_list.dart';
import 'package:memora/presentation/features/progress/widgets/progress_summary_card.dart';
import 'package:memora/presentation/features/progress/widgets/streak_calendar.dart';
import 'package:memora/presentation/shared/composites/cards/app_info_card.dart';
import 'package:memora/presentation/shared/composites/states/app_error_state.dart';
import 'package:memora/presentation/shared/composites/states/app_loading_state.dart';
import 'package:memora/presentation/shared/layouts/app_detail_page_layout.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_text_button.dart';
import 'package:memora/presentation/shared/primitives/displays/app_tag.dart';

class DeckProgressScreen extends ConsumerWidget {
  const DeckProgressScreen({super.key, required this.deckId});

  final int deckId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(progressFilterControllerProvider);
    final asyncState = ref.watch(progressControllerProvider);
    final filterController = ref.read(
      progressFilterControllerProvider.notifier,
    );
    final progressController = ref.read(progressControllerProvider.notifier);

    return AppDetailPageLayout(
      title: Text(context.l10n.progressDeckScreenTitle),
      subtitle: Text(context.l10n.progressDeckScreenSubtitle),
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: context.spacing.sm,
            runSpacing: context.spacing.sm,
            children: [
              AppTextButton(
                text: context.l10n.progressCalendarActionLabel,
                onPressed: () => context.push(AppRoutes.progressCalendar),
              ),
            ],
          ),
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
              _DeckFocusCard(deckId: deckId, state: state),
              SizedBox(height: context.spacing.lg),
              ProgressSummaryCard(state: state),
              SizedBox(height: context.spacing.lg),
              ProgressChartSection(state: state),
              SizedBox(height: context.spacing.lg),
              StreakCalendar(streakDays: state.streakDays),
              SizedBox(height: context.spacing.lg),
              ProgressHistoryList(state: state),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeckFocusCard extends StatelessWidget {
  const _DeckFocusCard({required this.deckId, required this.state});

  final int deckId;
  final ProgressState state;

  @override
  Widget build(BuildContext context) {
    final recommendation = state.recommendation;

    return AppInfoCard(
      title: context.l10n.progressDeckFocusTitle,
      subtitle: context.l10n.progressDeckFocusSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: context.spacing.xs,
            runSpacing: context.spacing.xs,
            children: [
              AppTag(label: context.l10n.progressDeckIdLabel(deckId)),
              AppTag(label: escalationLabel(context, state.escalationLevel)),
            ],
          ),
          if (recommendation != null) ...[
            SizedBox(height: context.spacing.sm),
            Text(
              context.l10n.progressDeckRecommendationLabel(
                recommendation.recommendedSessionType,
                recommendation.estimatedSessionMinutes,
              ),
              style: context.textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
