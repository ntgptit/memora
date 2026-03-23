import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/onboarding/providers/onboarding_provider.dart';
import 'package:memora/presentation/features/onboarding/widgets/study_goal_selector.dart';
import 'package:memora/presentation/shared/composites/forms/app_form_section.dart';
import 'package:memora/presentation/shared/composites/forms/app_submit_bar.dart';
import 'package:memora/presentation/shared/layouts/app_form_page_layout.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_text_button.dart';
import 'package:memora/presentation/shared/primitives/inputs/app_number_field.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';

class StudyGoalSetupScreen extends ConsumerStatefulWidget {
  const StudyGoalSetupScreen({super.key});

  @override
  ConsumerState<StudyGoalSetupScreen> createState() {
    return _StudyGoalSetupScreenState();
  }
}

class _StudyGoalSetupScreenState extends ConsumerState<StudyGoalSetupScreen> {
  late final TextEditingController _dailyGoalController;
  late final TextEditingController _sessionLengthController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingControllerProvider);
    _dailyGoalController = TextEditingController(
      text: state.dailyGoalCards.toString(),
    );
    _sessionLengthController = TextEditingController(
      text: state.sessionLengthMinutes.toString(),
    );
  }

  @override
  void dispose() {
    _dailyGoalController.dispose();
    _sessionLengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return AppFormPageLayout(
      title: Text(context.l10n.onboardingGoalSetupTitle),
      subtitle: Text(context.l10n.onboardingGoalSetupSubtitle),
      header: state.isCompleted
          ? AppBodyText(
              text: context.l10n.onboardingGoalSetupCompletedMessage(
                state.dailyGoalCards,
                state.sessionLengthMinutes,
              ),
              isSecondary: true,
            )
          : null,
      sections: [
        AppFormSection(
          title: Text(context.l10n.onboardingGoalPresetSectionTitle),
          subtitle: Text(context.l10n.onboardingGoalPresetSectionSubtitle),
          child: StudyGoalSelector(
            selectedGoal: state.selectedGoal,
            onGoalSelected: (goal) {
              controller.setGoal(goal);
              final nextState = ref.read(onboardingControllerProvider);
              _dailyGoalController.text = nextState.dailyGoalCards.toString();
              _sessionLengthController.text = nextState.sessionLengthMinutes
                  .toString();
            },
          ),
        ),
        AppFormSection(
          title: Text(context.l10n.onboardingGoalNumbersSectionTitle),
          subtitle: Text(context.l10n.onboardingGoalNumbersSectionSubtitle),
          child: Column(
            children: [
              AppNumberField(
                label: context.l10n.onboardingDailyGoalFieldLabel,
                controller: _dailyGoalController,
                allowDecimal: false,
                onNumberChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  controller.setDailyGoalCards(value.round());
                },
              ),
              SizedBox(height: context.spacing.md),
              AppNumberField(
                label: context.l10n.onboardingSessionLengthFieldLabel,
                controller: _sessionLengthController,
                allowDecimal: false,
                onNumberChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  controller.setSessionLengthMinutes(value.round());
                },
              ),
            ],
          ),
        ),
      ],
      submitBar: AppSubmitBar(
        secondaryAction: AppTextButton(
          text: context.l10n.onboardingBackAction,
          onPressed: context.pop,
        ),
        primaryAction: AppPrimaryButton(
          text: context.l10n.onboardingFinishAction,
          onPressed: () {
            controller.complete();
          },
        ),
      ),
    );
  }
}
