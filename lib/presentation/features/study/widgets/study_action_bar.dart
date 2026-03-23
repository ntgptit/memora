import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/presentation/shared/composites/study/app_answer_result_banner.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_danger_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_outline_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_text_button.dart';

enum StudyActionButtonVariant { primary, secondary, text, danger }

class StudyActionButton {
  const StudyActionButton({
    required this.label,
    required this.onPressed,
    this.variant = StudyActionButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final StudyActionButtonVariant variant;
}

class StudyActionBar extends StatelessWidget {
  const StudyActionBar({
    super.key,
    required this.actions,
    this.feedback,
    this.padding,
  });

  final List<StudyActionButton> actions;
  final AppAnswerResultBanner? feedback;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (feedback != null) ...[
            feedback!,
            SizedBox(height: context.spacing.md),
          ],
          Wrap(
            spacing: context.spacing.sm,
            runSpacing: context.spacing.sm,
            children: [for (final action in actions) _buildAction(action)],
          ),
        ],
      ),
    );
  }

  Widget _buildAction(StudyActionButton action) {
    switch (action.variant) {
      case StudyActionButtonVariant.primary:
        return AppPrimaryButton(
          text: action.label,
          onPressed: action.onPressed,
        );
      case StudyActionButtonVariant.secondary:
        return AppOutlineButton(
          text: action.label,
          onPressed: action.onPressed,
        );
      case StudyActionButtonVariant.text:
        return AppTextButton(text: action.label, onPressed: action.onPressed);
      case StudyActionButtonVariant.danger:
        return AppDangerButton(text: action.label, onPressed: action.onPressed);
    }
  }
}
