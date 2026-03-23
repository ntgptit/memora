import 'package:flutter/material.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/reminder/providers/reminder_state.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';

class ReminderDaySelector extends StatelessWidget {
  const ReminderDaySelector({
    super.key,
    required this.selectedDays,
    required this.onDayToggled,
  });

  final Set<ReminderWeekday> selectedDays;
  final ValueChanged<ReminderWeekday> onDayToggled;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final day in ReminderWeekday.values)
          AppChip(
            label: Text(_label(context, day)),
            selected: selectedDays.contains(day),
            onSelected: (_) => onDayToggled(day),
          ),
      ],
    );
  }

  String _label(BuildContext context, ReminderWeekday day) {
    switch (day) {
      case ReminderWeekday.monday:
        return context.l10n.reminderWeekdayMonday;
      case ReminderWeekday.tuesday:
        return context.l10n.reminderWeekdayTuesday;
      case ReminderWeekday.wednesday:
        return context.l10n.reminderWeekdayWednesday;
      case ReminderWeekday.thursday:
        return context.l10n.reminderWeekdayThursday;
      case ReminderWeekday.friday:
        return context.l10n.reminderWeekdayFriday;
      case ReminderWeekday.saturday:
        return context.l10n.reminderWeekdaySaturday;
      case ReminderWeekday.sunday:
        return context.l10n.reminderWeekdaySunday;
    }
  }
}
