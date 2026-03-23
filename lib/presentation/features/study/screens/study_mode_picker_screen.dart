import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/study/providers/study_l10n.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/features/study/providers/study_setup_provider.dart';
import 'package:memora/presentation/features/study/widgets/study_mode_stepper.dart';
import 'package:memora/presentation/shared/composites/cards/app_action_card.dart';
import 'package:memora/presentation/shared/layouts/app_list_page_layout.dart';

class StudyModePickerScreen extends ConsumerWidget {
  const StudyModePickerScreen({super.key, this.onModeSelected});

  final ValueChanged<StudyMode>? onModeSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studySetupControllerProvider);
    final controller = ref.read(studySetupControllerProvider.notifier);
    final l10n = context.l10n;
    return AppListPageLayout(
      title: Text(l10n.studyModePickerTitle),
      subtitle: Text(l10n.studyModePickerSubtitle),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StudyModeStepper(
              modePlan: state.modePlan,
              onSelectMode: (mode) {
                controller.highlightMode(mode);
                onModeSelected?.call(mode);
              },
            ),
            SizedBox(height: context.spacing.xl),
            for (final entry in state.modePlan) ...[
              AppActionCard(
                title: entry.mode.label(l10n),
                subtitle: entry.mode.description(l10n),
                leading: Icon(entry.mode.icon),
                primaryActionLabel: entry.isCurrent
                    ? l10n.studyModePickerSelectedAction
                    : l10n.studyModePickerChooseAction,
                onPrimaryAction: () {
                  controller.highlightMode(entry.mode);
                  onModeSelected?.call(entry.mode);
                },
              ),
              if (entry != state.modePlan.last)
                SizedBox(height: context.spacing.lg),
            ],
          ],
        ),
      ),
    );
  }
}
