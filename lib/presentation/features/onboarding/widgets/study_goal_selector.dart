import 'package:flutter/material.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/onboarding/providers/onboarding_state.dart';
import 'package:memora/presentation/shared/primitives/selections/app_segmented_control.dart';

class StudyGoalSelector extends StatelessWidget {
  const StudyGoalSelector({
    super.key,
    required this.selectedGoal,
    required this.onGoalSelected,
  });

  final StudyGoalPreset selectedGoal;
  final ValueChanged<StudyGoalPreset> onGoalSelected;

  @override
  Widget build(BuildContext context) {
    return AppSegmentedControl<StudyGoalPreset>(
      segments: [
        ButtonSegment<StudyGoalPreset>(
          value: StudyGoalPreset.steady,
          icon: const Icon(Icons.spa_rounded),
          label: Text(context.l10n.onboardingGoalSteadyLabel),
        ),
        ButtonSegment<StudyGoalPreset>(
          value: StudyGoalPreset.focused,
          icon: const Icon(Icons.local_fire_department_rounded),
          label: Text(context.l10n.onboardingGoalFocusedLabel),
        ),
        ButtonSegment<StudyGoalPreset>(
          value: StudyGoalPreset.intensive,
          icon: const Icon(Icons.bolt_rounded),
          label: Text(context.l10n.onboardingGoalIntensiveLabel),
        ),
      ],
      selected: {selectedGoal},
      onSelectionChanged: (selection) {
        if (selection.isEmpty) {
          return;
        }
        onGoalSelected(selection.first);
      },
    );
  }
}
