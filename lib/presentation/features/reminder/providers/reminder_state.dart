import 'package:flutter/material.dart';

enum ReminderFrequency { daily, weekdays, custom }

enum ReminderTimeSlotKind { morningReview, eveningReset, studyBlock }

enum ReminderWeekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

@immutable
class ReminderTimeSlot {
  const ReminderTimeSlot({
    required this.id,
    required this.time,
    required this.kind,
    this.enabled = true,
  });

  final String id;
  final TimeOfDay time;
  final ReminderTimeSlotKind kind;
  final bool enabled;

  ReminderTimeSlot copyWith({
    String? id,
    TimeOfDay? time,
    ReminderTimeSlotKind? kind,
    bool? enabled,
  }) {
    return ReminderTimeSlot(
      id: id ?? this.id,
      time: time ?? this.time,
      kind: kind ?? this.kind,
      enabled: enabled ?? this.enabled,
    );
  }
}

@immutable
class ReminderSuggestion {
  const ReminderSuggestion({
    required this.deckId,
    required this.deckName,
    required this.dueCount,
    required this.overdueCount,
  });

  final String deckId;
  final String deckName;
  final int dueCount;
  final int overdueCount;
}

@immutable
class ReminderState {
  const ReminderState({
    required this.enabled,
    required this.frequency,
    required this.selectedDays,
    required this.timeSlots,
    required this.dueCount,
    required this.overdueCount,
    required this.suggestion,
  });

  factory ReminderState.initial() {
    return ReminderState(
      enabled: true,
      frequency: ReminderFrequency.weekdays,
      selectedDays: const {
        ReminderWeekday.monday,
        ReminderWeekday.tuesday,
        ReminderWeekday.wednesday,
        ReminderWeekday.thursday,
        ReminderWeekday.friday,
      },
      timeSlots: const [
        ReminderTimeSlot(
          id: 'morning-review',
          time: TimeOfDay(hour: 8, minute: 30),
          kind: ReminderTimeSlotKind.morningReview,
        ),
        ReminderTimeSlot(
          id: 'evening-review',
          time: TimeOfDay(hour: 20, minute: 0),
          kind: ReminderTimeSlotKind.eveningReset,
        ),
      ],
      dueCount: 24,
      overdueCount: 6,
      suggestion: const ReminderSuggestion(
        deckId: 'verbs',
        deckName: 'Korean verbs',
        dueCount: 18,
        overdueCount: 5,
      ),
    );
  }

  final bool enabled;
  final ReminderFrequency frequency;
  final Set<ReminderWeekday> selectedDays;
  final List<ReminderTimeSlot> timeSlots;
  final int dueCount;
  final int overdueCount;
  final ReminderSuggestion suggestion;

  bool get usesCustomDays => frequency == ReminderFrequency.custom;

  List<ReminderTimeSlot> get activeTimeSlots {
    return timeSlots.where((slot) => slot.enabled).toList(growable: false);
  }

  ReminderState copyWith({
    bool? enabled,
    ReminderFrequency? frequency,
    Set<ReminderWeekday>? selectedDays,
    List<ReminderTimeSlot>? timeSlots,
    int? dueCount,
    int? overdueCount,
    ReminderSuggestion? suggestion,
  }) {
    return ReminderState(
      enabled: enabled ?? this.enabled,
      frequency: frequency ?? this.frequency,
      selectedDays: selectedDays ?? this.selectedDays,
      timeSlots: timeSlots ?? this.timeSlots,
      dueCount: dueCount ?? this.dueCount,
      overdueCount: overdueCount ?? this.overdueCount,
      suggestion: suggestion ?? this.suggestion,
    );
  }
}
