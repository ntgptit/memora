import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/study/providers/study_l10n.dart';
import 'package:memora/presentation/features/study/providers/study_session_provider.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/features/study/providers/study_setup_provider.dart';
import 'package:memora/presentation/features/study/widgets/study_mode_stepper.dart';
import 'package:memora/presentation/shared/composites/cards/app_action_card.dart';
import 'package:memora/presentation/shared/composites/cards/app_info_card.dart';
import 'package:memora/presentation/shared/composites/cards/app_progress_card.dart';
import 'package:memora/presentation/shared/composites/cards/app_stat_card.dart';
import 'package:memora/presentation/shared/composites/forms/app_submit_bar.dart';
import 'package:memora/presentation/shared/composites/lists/app_list_item.dart';
import 'package:memora/presentation/shared/layouts/app_form_page_layout.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_text_button.dart';

const double _studySetupMetricCardWidth = 210;
const double _studySetupActionCardWidth = 280;

class StudySetupScreen extends ConsumerWidget {
  const StudySetupScreen({
    super.key,
    this.onStartSession,
    this.onOpenModePicker,
    this.onOpenHistory,
  });

  final VoidCallback? onStartSession;
  final VoidCallback? onOpenModePicker;
  final VoidCallback? onOpenHistory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studySetupControllerProvider);
    final controller = ref.read(studySetupControllerProvider.notifier);
    final l10n = context.l10n;
    return AppFormPageLayout(
      title: Text(l10n.studySetupTitle),
      subtitle: Text(l10n.studySetupSubtitle),
      sections: [
        AppInfoCard(
          title: state.deck.title,
          subtitle: state.deck.folderLabel,
          leading: const Icon(Icons.play_lesson_rounded),
          child: Wrap(
            spacing: context.spacing.md,
            runSpacing: context.spacing.md,
            children: [
              SizedBox(
                width: _studySetupMetricCardWidth,
                child: AppProgressCard(
                  title: l10n.studyDeckReadinessTitle,
                  subtitle: l10n.studyDeckReadinessSubtitle,
                  value: state.deck.masteryRatio,
                ),
              ),
              SizedBox(
                width: _studySetupMetricCardWidth,
                child: AppStatCard(
                  label: l10n.studyDueCountTitle,
                  value: '${state.deck.dueCards}',
                  subtitle: l10n.studyDueCountLabel(state.deck.dueCards),
                ),
              ),
              SizedBox(
                width: _studySetupMetricCardWidth,
                child: AppStatCard(
                  label: l10n.studySetupEstimateTitle,
                  value: l10n.studyMinutesShortLabel(
                    state.deck.estimatedMinutes,
                  ),
                  subtitle: l10n.studySetupEstimateSubtitle,
                ),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: context.spacing.lg,
          runSpacing: context.spacing.lg,
          children: [
            for (final sessionType in StudySessionType.values)
              SizedBox(
                width: _studySetupActionCardWidth,
                child: AppActionCard(
                  title: sessionType.label(l10n),
                  subtitle: sessionType.subtitle(l10n),
                  leading: Icon(
                    sessionType == StudySessionType.review
                        ? Icons.bolt_rounded
                        : Icons.layers_rounded,
                  ),
                  primaryActionLabel: state.selectedSessionType == sessionType
                      ? l10n.studySessionTypeSelectedAction
                      : l10n.studySessionTypeChooseAction,
                  onPrimaryAction: () =>
                      controller.selectSessionType(sessionType),
                ),
              ),
          ],
        ),
        if (state.resumeSummary != null)
          AppActionCard(
            title: l10n.studyResumeTitle,
            subtitle: l10n.studyResumeSubtitle(
              state.resumeSummary!.activeMode.label(l10n),
              state.resumeSummary!.completedItems,
              state.resumeSummary!.totalItems,
            ),
            leading: const Icon(Icons.history_rounded),
            primaryActionLabel: l10n.studyResumeAction,
            onPrimaryAction: () {
              controller.setPreferResumeSession(true);
              _prepareSession(ref, state.copyWith(preferResumeSession: true));
              onStartSession?.call();
            },
            secondaryActionLabel: l10n.studyStartFreshAction,
            onSecondaryAction: () => controller.setPreferResumeSession(false),
          ),
        AppInfoCard(
          title: l10n.studyModeSequenceTitle,
          subtitle: l10n.studyModeSequenceSubtitle,
          onTap: onOpenModePicker,
          child: StudyModeStepper(
            modePlan: state.modePlan,
            onSelectMode: controller.highlightMode,
          ),
        ),
        AppInfoCard(
          title: l10n.studyHistoryPreviewTitle,
          subtitle: l10n.studyHistoryPreviewSubtitle,
          onTap: onOpenHistory,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final entry in state.recentSessions.take(2)) ...[
                AppListItem(
                  title: Text(entry.deckTitle),
                  subtitle: Text(
                    l10n.studyHistoryEntrySubtitle(
                      entry.primaryMode.label(l10n),
                      entry.masteredItems,
                      entry.totalItems,
                    ),
                  ),
                  leading: const Icon(Icons.schedule_rounded),
                  compact: true,
                ),
                if (entry != state.recentSessions.take(2).last)
                  SizedBox(height: context.spacing.sm),
              ],
            ],
          ),
        ),
      ],
      submitBar: AppSubmitBar(
        primaryAction: AppPrimaryButton(
          text: l10n.studyStartAction,
          onPressed: () {
            _prepareSession(ref, state);
            onStartSession?.call();
          },
        ),
        secondaryAction: AppTextButton(
          text: l10n.studyModePickerTitle,
          onPressed: onOpenModePicker,
        ),
        actions: [
          if (onOpenHistory != null)
            AppTextButton(
              text: l10n.studyHistoryTitle,
              onPressed: onOpenHistory,
            ),
        ],
      ),
    );
  }

  void _prepareSession(WidgetRef ref, StudySetupState setupState) {
    ref
        .read(studySessionControllerProvider.notifier)
        .prepareFromSetup(setupState);
  }
}
