import 'package:flutter/material.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/reminder/providers/reminder_state.dart';
import 'package:memora/presentation/shared/primitives/selections/app_segmented_control.dart';

class ReminderFrequencySelector extends StatelessWidget {
  const ReminderFrequencySelector({
    super.key,
    required this.selectedFrequency,
    required this.onFrequencyChanged,
  });

  final ReminderFrequency selectedFrequency;
  final ValueChanged<ReminderFrequency> onFrequencyChanged;

  @override
  Widget build(BuildContext context) {
    return AppSegmentedControl<ReminderFrequency>(
      segments: [
        ButtonSegment<ReminderFrequency>(
          value: ReminderFrequency.daily,
          label: Text(context.l10n.reminderFrequencyDailyLabel),
          icon: const Icon(Icons.today_rounded),
        ),
        ButtonSegment<ReminderFrequency>(
          value: ReminderFrequency.weekdays,
          label: Text(context.l10n.reminderFrequencyWeekdaysLabel),
          icon: const Icon(Icons.work_outline_rounded),
        ),
        ButtonSegment<ReminderFrequency>(
          value: ReminderFrequency.custom,
          label: Text(context.l10n.reminderFrequencyCustomLabel),
          icon: const Icon(Icons.tune_rounded),
        ),
      ],
      selected: {selectedFrequency},
      onSelectionChanged: (selection) {
        if (selection.isEmpty) {
          return;
        }
        onFrequencyChanged(selection.first);
      },
    );
  }
}
