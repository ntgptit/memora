import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/reminder/providers/reminder_provider.dart';
import 'package:memora/presentation/features/reminder/widgets/reminder_day_selector.dart';
import 'package:memora/presentation/features/reminder/widgets/reminder_time_slot_card.dart';
import 'package:memora/presentation/shared/composites/forms/app_form_section.dart';
import 'package:memora/presentation/shared/layouts/app_detail_page_layout.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';

class ReminderTimeSlotsScreen extends ConsumerWidget {
  const ReminderTimeSlotsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reminderControllerProvider);
    final controller = ref.read(reminderControllerProvider.notifier);

    return AppDetailPageLayout(
      title: Text(context.l10n.reminderTimeSlotsTitle),
      subtitle: Text(context.l10n.reminderTimeSlotsSubtitle),
      actions: [
        AppPrimaryButton(
          text: context.l10n.reminderAddSlotAction,
          onPressed: () => _pickAndAddTime(context, controller),
        ),
      ],
      body: ListView(
        children: [
          if (state.usesCustomDays) ...[
            AppFormSection(
              title: Text(context.l10n.reminderCustomDaysSectionTitle),
              subtitle: Text(context.l10n.reminderCustomDaysSectionSubtitle),
              child: ReminderDaySelector(
                selectedDays: state.selectedDays,
                onDayToggled: controller.toggleDay,
              ),
            ),
            SizedBox(height: context.spacing.lg),
          ],
          for (final slot in state.timeSlots) ...[
            ReminderTimeSlotCard(
              slot: slot,
              onEnabledChanged: (enabled) {
                controller.toggleTimeSlot(slotId: slot.id, enabled: enabled);
              },
              onEdit: () =>
                  _pickAndUpdateTime(context, controller, slot.id, slot.time),
              onDelete: state.timeSlots.length <= 1
                  ? null
                  : () => controller.removeTimeSlot(slot.id),
            ),
            SizedBox(height: context.spacing.md),
          ],
        ],
      ),
    );
  }

  Future<void> _pickAndAddTime(
    BuildContext context,
    ReminderController controller,
  ) async {
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (time == null) {
      return;
    }
    controller.addTimeSlot(time);
  }

  Future<void> _pickAndUpdateTime(
    BuildContext context,
    ReminderController controller,
    String slotId,
    TimeOfDay initialTime,
  ) async {
    final time = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (time == null) {
      return;
    }
    controller.updateTimeSlot(slotId: slotId, time: time);
  }
}
