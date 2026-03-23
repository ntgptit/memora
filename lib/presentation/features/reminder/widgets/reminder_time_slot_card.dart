import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/reminder/providers/reminder_state.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_icon_button.dart';
import 'package:memora/presentation/shared/primitives/displays/app_card.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';
import 'package:memora/presentation/shared/primitives/selections/app_switch.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';

class ReminderTimeSlotCard extends StatelessWidget {
  const ReminderTimeSlotCard({
    super.key,
    required this.slot,
    required this.onEnabledChanged,
    this.onEdit,
    this.onDelete,
  });

  final ReminderTimeSlot slot;
  final ValueChanged<bool> onEnabledChanged;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.time.format(context),
                  style: context.textTheme.titleLarge,
                ),
                SizedBox(height: context.spacing.xxs),
                AppBodyText(
                  text: _slotLabel(context, slot.kind),
                  isSecondary: true,
                ),
                SizedBox(height: context.spacing.sm),
                AppChip(
                  label: Text(
                    slot.enabled
                        ? context.l10n.reminderSlotEnabledLabel
                        : context.l10n.reminderSlotPausedLabel,
                  ),
                  selected: slot.enabled,
                ),
              ],
            ),
          ),
          SizedBox(width: context.spacing.sm),
          Column(
            children: [
              AppSwitch(value: slot.enabled, onChanged: onEnabledChanged),
              if (onEdit != null)
                AppIconButton(
                  icon: const Icon(Icons.edit_rounded),
                  tooltip: context.l10n.editLabel,
                  onPressed: onEdit,
                ),
              if (onDelete != null)
                AppIconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  tooltip: context.l10n.deleteLabel,
                  onPressed: onDelete,
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _slotLabel(BuildContext context, ReminderTimeSlotKind kind) {
    return switch (kind) {
      ReminderTimeSlotKind.morningReview =>
        context.l10n.reminderSlotMorningReviewLabel,
      ReminderTimeSlotKind.eveningReset =>
        context.l10n.reminderSlotEveningResetLabel,
      ReminderTimeSlotKind.studyBlock =>
        context.l10n.reminderSlotStudyBlockLabel,
    };
  }
}
