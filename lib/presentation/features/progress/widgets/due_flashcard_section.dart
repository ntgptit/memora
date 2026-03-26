import 'package:flutter/material.dart';
import 'package:memora/app/app_route_data.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/progress/providers/progress_state.dart';
import 'package:memora/presentation/features/progress/widgets/progress_summary_card.dart';
import 'package:memora/presentation/shared/composites/cards/app_info_card.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_outline_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/displays/app_icon.dart';
import 'package:memora/presentation/shared/primitives/displays/app_label.dart';
import 'package:memora/presentation/shared/composites/states/app_no_result_state.dart';
import 'package:memora/presentation/shared/primitives/displays/app_tag.dart';

class DueFlashcardSection extends StatelessWidget {
  const DueFlashcardSection({
    super.key,
    required this.state,
    this.onOpenDeckProgress,
  });

  final ProgressState state;
  final VoidCallback? onOpenDeckProgress;

  @override
  Widget build(BuildContext context) {
    final recommendation = state.recommendation;
    if (recommendation == null) {
      return AppNoResultState(
        message: context.l10n.progressRecommendationEmptyMessage,
        actionLabel: context.l10n.progressViewDeckActionLabel,
        onActionPressed: onOpenDeckProgress,
      );
    }

    return AppInfoCard(
      title: context.l10n.progressRecommendationTitle,
      subtitle: context.l10n.progressRecommendationSubtitle,
      leading: const AppIcon(Icons.lightbulb_rounded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppLabel(
                  text: recommendation.deckName,
                  style: context.textTheme.titleMedium,
                  color: context.colorScheme.onSurface,
                  maxLines: 2,
                ),
              ),
              AppTag(label: escalationLabel(context, state.escalationLevel)),
            ],
          ),
          SizedBox(height: context.spacing.sm),
          AppLabel(
            text: context.l10n.progressRecommendationMetaLabel(
              recommendation.recommendedSessionType,
              recommendation.estimatedSessionMinutes,
            ),
            maxLines: 2,
          ),
          SizedBox(height: context.spacing.sm),
          Wrap(
            spacing: context.spacing.xs,
            runSpacing: context.spacing.xs,
            children: [
              AppTag(
                label: context.l10n.progressDueCountChipLabel(
                  recommendation.dueCount,
                ),
              ),
              AppTag(
                label: context.l10n.progressOverdueCountChipLabel(
                  recommendation.overdueCount,
                ),
              ),
              for (final reminderType in state.reminderTypes)
                AppTag(label: reminderType),
            ],
          ),
          SizedBox(height: context.spacing.md),
          Wrap(
            spacing: context.spacing.sm,
            runSpacing: context.spacing.sm,
            children: [
              AppPrimaryButton(
                text: context.l10n.progressStudyNowActionLabel,
                onPressed: () => DeckDetailRouteData(
                  folderId: recommendation.folderId,
                  deckId: recommendation.deckId,
                ).go(context),
              ),
              AppOutlineButton(
                text: context.l10n.progressViewDeckActionLabel,
                onPressed: onOpenDeckProgress,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
