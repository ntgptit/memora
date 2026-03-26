import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memora/app/app_route_data.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/reminder/providers/reminder_provider.dart';
import 'package:memora/presentation/features/reminder/widgets/reminder_frequency_selector.dart';
import 'package:memora/presentation/features/reminder/widgets/reminder_toggle_tile.dart';
import 'package:memora/presentation/shared/composites/forms/app_form_section.dart';
import 'package:memora/presentation/shared/layouts/app_detail_page_layout.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_secondary_button.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';

class ReminderSettingsScreen extends ConsumerWidget {
  const ReminderSettingsScreen({super.key, this.onOpenSuggestedDeck});

  final VoidCallback? onOpenSuggestedDeck;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reminderControllerProvider);
    final controller = ref.read(reminderControllerProvider.notifier);

    return AppDetailPageLayout(
      title: Text(context.l10n.reminderTitle),
      subtitle: Text(context.l10n.reminderSubtitle),
      body: ListView(
        children: [
          AppFormSection(
            title: Text(context.l10n.reminderOverviewSectionTitle),
            subtitle: Text(context.l10n.reminderOverviewSectionSubtitle),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReminderToggleTile(
                  title: context.l10n.reminderToggleTitle,
                  subtitle: context.l10n.reminderToggleSubtitle,
                  value: state.enabled,
                  onChanged: controller.toggleEnabled,
                ),
                SizedBox(height: context.spacing.md),
                Wrap(
                  spacing: context.spacing.sm,
                  runSpacing: context.spacing.sm,
                  children: [
                    AppChip(
                      label: Text(
                        context.l10n.reminderDueCountLabel(state.dueCount),
                      ),
                    ),
                    AppChip(
                      label: Text(
                        context.l10n.reminderOverdueCountLabel(
                          state.overdueCount,
                        ),
                      ),
                    ),
                    AppChip(
                      label: Text(
                        context.l10n.reminderActiveSlotsLabel(
                          state.activeTimeSlots.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: context.spacing.lg),
          AppFormSection(
            title: Text(context.l10n.reminderFrequencySectionTitle),
            subtitle: Text(context.l10n.reminderFrequencySectionSubtitle),
            child: ReminderFrequencySelector(
              selectedFrequency: state.frequency,
              onFrequencyChanged: controller.setFrequency,
            ),
          ),
          SizedBox(height: context.spacing.lg),
          AppFormSection(
            title: Text(context.l10n.reminderSuggestedDeckSectionTitle),
            subtitle: Text(context.l10n.reminderSuggestedDeckSectionSubtitle),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.suggestion.deckName,
                  style: context.textTheme.titleMedium,
                ),
                SizedBox(height: context.spacing.xxs),
                AppBodyText(
                  text: context.l10n.reminderSuggestedDeckMessage(
                    state.suggestion.dueCount,
                    state.suggestion.overdueCount,
                  ),
                  isSecondary: true,
                ),
                SizedBox(height: context.spacing.md),
                Wrap(
                  spacing: context.spacing.sm,
                  runSpacing: context.spacing.sm,
                  children: [
                    AppPrimaryButton(
                      text: context.l10n.reminderPreviewAction,
                      onPressed: () =>
                          const ReminderPreviewRouteData().push(context),
                    ),
                    AppSecondaryButton(
                      text: context.l10n.reminderManageSlotsAction,
                      onPressed: () =>
                          const ReminderTimeSlotsRouteData().push(context),
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
