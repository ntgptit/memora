import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/reminder/providers/reminder_provider.dart';
import 'package:memora/presentation/shared/composites/forms/app_form_section.dart';
import 'package:memora/presentation/shared/layouts/app_detail_page_layout.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_secondary_button.dart';
import 'package:memora/presentation/shared/primitives/displays/app_card.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';

class ReminderPreviewScreen extends ConsumerWidget {
  const ReminderPreviewScreen({super.key, this.onOpenSuggestedDeck});

  final VoidCallback? onOpenSuggestedDeck;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reminderControllerProvider);
    final previewTitle = context.l10n.reminderPreviewCardTitle(
      state.suggestion.deckName,
    );
    final previewBody = context.l10n.reminderPreviewCardMessage(
      state.suggestion.dueCount,
      state.suggestion.overdueCount,
    );

    return AppDetailPageLayout(
      title: Text(context.l10n.reminderPreviewTitle),
      subtitle: Text(context.l10n.reminderPreviewSubtitle),
      body: ListView(
        children: [
          AppFormSection(
            title: Text(context.l10n.reminderPreviewSummaryTitle),
            subtitle: Text(context.l10n.reminderPreviewSummarySubtitle),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBodyText(
                  text: context.l10n.reminderPreviewScheduleMessage(
                    state.activeTimeSlots.isEmpty
                        ? '--'
                        : state.activeTimeSlots.first.time.format(context),
                  ),
                  isSecondary: true,
                ),
                SizedBox(height: context.spacing.md),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(previewTitle, style: context.textTheme.titleMedium),
                      SizedBox(height: context.spacing.xs),
                      AppBodyText(text: previewBody, isSecondary: true),
                    ],
                  ),
                ),
                SizedBox(height: context.spacing.md),
                Wrap(
                  spacing: context.spacing.sm,
                  runSpacing: context.spacing.sm,
                  children: [
                    AppPrimaryButton(
                      text: context.l10n.reminderOpenSuggestedDeckAction,
                      onPressed: onOpenSuggestedDeck,
                    ),
                    AppSecondaryButton(
                      text: context.l10n.reminderBackToSettingsAction,
                      onPressed: context.pop,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
