import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/shared/composites/lists/app_list_item.dart';

class GuessOptionList extends StatelessWidget {
  const GuessOptionList({
    super.key,
    required this.item,
    required this.selectedChoiceId,
    required this.feedback,
    required this.onSelectChoice,
  });

  final StudySessionItem item;
  final String? selectedChoiceId;
  final StudyModeFeedback? feedback;
  final ValueChanged<String> onSelectChoice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final choice in item.choices) ...[
          AppListItem(
            title: Text(choice.label),
            subtitle: choice.detail == null ? null : Text(choice.detail!),
            selected: selectedChoiceId == choice.id,
            trailing: _buildTrailing(choice.id),
            onTap: feedback == null ? () => onSelectChoice(choice.id) : null,
            backgroundColor: _backgroundColor(context, choice.id),
          ),
          if (choice != item.choices.last) SizedBox(height: context.spacing.sm),
        ],
      ],
    );
  }

  Widget? _buildTrailing(String choiceId) {
    if (feedback == null) {
      return null;
    }
    if (item.correctChoiceId == choiceId) {
      return const Icon(Icons.check_circle_rounded);
    }
    if (selectedChoiceId == choiceId && item.correctChoiceId != choiceId) {
      return const Icon(Icons.close_rounded);
    }
    return null;
  }

  Color? _backgroundColor(BuildContext context, String choiceId) {
    if (feedback == null) {
      return null;
    }
    if (item.correctChoiceId == choiceId) {
      return context.colorScheme.secondaryContainer;
    }
    if (selectedChoiceId == choiceId && item.correctChoiceId != choiceId) {
      return context.colorScheme.errorContainer;
    }
    return null;
  }
}
