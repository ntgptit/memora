import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/study/providers/study_l10n.dart';
import 'package:memora/presentation/features/study/providers/study_result_provider.dart';
import 'package:memora/presentation/features/study/widgets/study_mode_stepper.dart';
import 'package:memora/presentation/features/study/widgets/study_result_summary.dart';
import 'package:memora/presentation/shared/composites/cards/app_action_card.dart';
import 'package:memora/presentation/shared/layouts/app_detail_page_layout.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_text_button.dart';

class StudyResultScreen extends ConsumerWidget {
  const StudyResultScreen({
    super.key,
    this.onRestartSession,
    this.onOpenHistory,
    this.onReturnToDeck,
  });

  final VoidCallback? onRestartSession;
  final VoidCallback? onOpenHistory;
  final VoidCallback? onReturnToDeck;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(studyResultControllerProvider);
    final l10n = context.l10n;
    return AppDetailPageLayout(
      title: Text(l10n.studyResultTitle),
      subtitle: Text(l10n.studyResultSubtitle),
      actions: [
        if (onOpenHistory != null)
          AppTextButton(text: l10n.studyHistoryTitle, onPressed: onOpenHistory),
      ],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StudyResultSummary(result: result),
            SizedBox(height: context.spacing.xl),
            StudyModeStepper(modePlan: result.modePlan),
            SizedBox(height: context.spacing.xl),
            AppActionCard(
              title: l10n.studyResultNextBlockTitle,
              subtitle: l10n.studyResultNextBlockSubtitle(
                result.modePlan.last.mode.label(l10n),
              ),
              leading: const Icon(Icons.refresh_rounded),
              primaryActionLabel: l10n.studyRestartSessionAction,
              onPrimaryAction: onRestartSession,
              secondaryActionLabel: l10n.studyReturnToDeckAction,
              onSecondaryAction: onReturnToDeck,
            ),
          ],
        ),
      ),
    );
  }
}
