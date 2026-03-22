import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memora/core/theme/extensions/screen_context_ext.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/dashboard/providers/dashboard_l10n.dart';
import 'package:memora/presentation/features/dashboard/providers/dashboard_provider.dart';
import 'package:memora/presentation/features/dashboard/providers/dashboard_state.dart';
import 'package:memora/presentation/features/dashboard/widgets/dashboard_due_decks.dart';
import 'package:memora/presentation/features/dashboard/widgets/dashboard_header.dart';
import 'package:memora/presentation/features/dashboard/widgets/dashboard_quick_actions.dart';
import 'package:memora/presentation/features/dashboard/widgets/dashboard_streak_card.dart';
import 'package:memora/presentation/features/dashboard/widgets/dashboard_summary_card.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';
import 'package:memora/presentation/shared/layouts/app_split_view_layout.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);
    final controller = ref.read(dashboardControllerProvider.notifier);
    final spacing = context.spacing;
    final l10n = context.l10n;
    final mainContent = _DashboardMainContent(
      state: state,
      includePrioritySidebar: !context.screenClass.canUseSplitView,
      onRefresh: controller.refresh,
      onStartDeck: controller.startDeck,
      onSnoozeDeck: controller.snoozeDeck,
      onApplyQuickAction: controller.applyQuickAction,
      onDeferQuickAction: controller.deferQuickAction,
    );

    return AppScaffold(
      title: l10n.dashboardTitle,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: context.screenClass.canUseSplitView
            ? AppSplitViewLayout(
                collapseWhenCompact: false,
                gap: context.layout.gutter,
                primary: mainContent,
                secondary: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DashboardStreakCard(
                      currentStreak: state.currentStreak,
                      reviewedToday: state.reviewedToday,
                      dailyGoal: state.dailyGoal,
                    ),
                    SizedBox(height: spacing.lg),
                    DashboardQuickActions(
                      actions: state.quickActions,
                      focusLabel: state.focus.label(l10n),
                      onApplyAction: controller.applyQuickAction,
                      onDeferAction: controller.deferQuickAction,
                    ),
                  ],
                ),
              )
            : mainContent,
      ),
    );
  }
}

class _DashboardMainContent extends StatelessWidget {
  const _DashboardMainContent({
    required this.state,
    required this.includePrioritySidebar,
    required this.onRefresh,
    required this.onStartDeck,
    required this.onSnoozeDeck,
    required this.onApplyQuickAction,
    required this.onDeferQuickAction,
  });

  final DashboardState state;
  final bool includePrioritySidebar;
  final VoidCallback onRefresh;
  final ValueChanged<String> onStartDeck;
  final ValueChanged<String> onSnoozeDeck;
  final ValueChanged<String> onApplyQuickAction;
  final ValueChanged<String> onDeferQuickAction;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DashboardHeader(
          title: l10n.dashboardTitle,
          subtitle: l10n.dashboardHeadlineSubtitle,
          focusLabel: state.focus.label(l10n),
          dueDeckCount: state.dueDeckCount,
          dueCardCount: state.dueCardCount,
          onRefresh: onRefresh,
        ),
        SizedBox(height: spacing.xl),
        DashboardSummaryCard(
          dueDeckCount: state.dueDeckCount,
          dueCardCount: state.dueCardCount,
          reviewedToday: state.reviewedToday,
          dailyGoal: state.dailyGoal,
          totalStudyMinutes: state.totalStudyMinutes,
        ),
        if (includePrioritySidebar) ...[
          SizedBox(height: spacing.xl),
          DashboardStreakCard(
            currentStreak: state.currentStreak,
            reviewedToday: state.reviewedToday,
            dailyGoal: state.dailyGoal,
          ),
        ],
        SizedBox(height: spacing.xl),
        DashboardDueDecks(
          decks: state.dueDecks,
          onStartDeck: onStartDeck,
          onSnoozeDeck: onSnoozeDeck,
        ),
        if (includePrioritySidebar) ...[
          SizedBox(height: spacing.xl),
          DashboardQuickActions(
            actions: state.quickActions,
            focusLabel: state.focus.label(l10n),
            onApplyAction: onApplyQuickAction,
            onDeferAction: onDeferQuickAction,
          ),
        ],
      ],
    );
  }
}
