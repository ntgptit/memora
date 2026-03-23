import 'package:flutter/material.dart';
import 'package:memora/presentation/features/reminder/providers/reminder_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reminder_provider.g.dart';

@Riverpod(keepAlive: true)
class ReminderController extends _$ReminderController {
  @override
  ReminderState build() {
    return ReminderState.initial();
  }

  void toggleEnabled(bool value) {
    state = state.copyWith(enabled: value);
  }

  void setFrequency(ReminderFrequency frequency) {
    final selectedDays = switch (frequency) {
      ReminderFrequency.daily => ReminderWeekday.values.toSet(),
      ReminderFrequency.weekdays => {
        ReminderWeekday.monday,
        ReminderWeekday.tuesday,
        ReminderWeekday.wednesday,
        ReminderWeekday.thursday,
        ReminderWeekday.friday,
      },
      ReminderFrequency.custom =>
        state.selectedDays.isEmpty
            ? {
                ReminderWeekday.monday,
                ReminderWeekday.wednesday,
                ReminderWeekday.friday,
              }
            : state.selectedDays,
    };

    state = state.copyWith(frequency: frequency, selectedDays: selectedDays);
  }

  void toggleDay(ReminderWeekday day) {
    final nextDays = {...state.selectedDays};
    if (nextDays.remove(day)) {
      if (nextDays.isEmpty) {
        nextDays.add(day);
      }
      state = state.copyWith(selectedDays: nextDays);
      return;
    }

    nextDays.add(day);
    state = state.copyWith(selectedDays: nextDays);
  }

  void addTimeSlot(TimeOfDay time) {
    final nextSlots = [...state.timeSlots];
    nextSlots.add(
      ReminderTimeSlot(
        id: 'slot-${DateTime.now().microsecondsSinceEpoch}',
        time: time,
        kind: ReminderTimeSlotKind.studyBlock,
      ),
    );
    state = state.copyWith(timeSlots: _sortSlots(nextSlots));
  }

  void updateTimeSlot({required String slotId, required TimeOfDay time}) {
    final nextSlots = state.timeSlots
        .map((slot) => slot.id == slotId ? slot.copyWith(time: time) : slot)
        .toList(growable: false);

    state = state.copyWith(timeSlots: _sortSlots(nextSlots));
  }

  void toggleTimeSlot({required String slotId, required bool enabled}) {
    state = state.copyWith(
      timeSlots: state.timeSlots
          .map(
            (slot) =>
                slot.id == slotId ? slot.copyWith(enabled: enabled) : slot,
          )
          .toList(growable: false),
    );
  }

  void removeTimeSlot(String slotId) {
    final nextSlots = state.timeSlots
        .where((slot) => slot.id != slotId)
        .toList(growable: false);

    state = state.copyWith(
      timeSlots: nextSlots.isEmpty ? state.timeSlots : nextSlots,
    );
  }

  List<ReminderTimeSlot> _sortSlots(List<ReminderTimeSlot> slots) {
    final sortedSlots = [...slots];
    sortedSlots.sort((left, right) {
      final leftMinutes = (left.time.hour * 60) + left.time.minute;
      final rightMinutes = (right.time.hour * 60) + right.time.minute;
      return leftMinutes.compareTo(rightMinutes);
    });
    return sortedSlots;
  }
}
