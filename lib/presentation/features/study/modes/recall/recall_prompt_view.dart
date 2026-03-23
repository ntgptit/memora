import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/shared/composites/study/app_flashcard_face.dart';
import 'package:memora/presentation/shared/primitives/displays/app_label.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_title_text.dart';

class RecallPromptView extends StatelessWidget {
  const RecallPromptView({
    super.key,
    required this.item,
    required this.answerRevealed,
    this.onRevealRequested,
  });

  final StudySessionItem item;
  final bool answerRevealed;
  final VoidCallback? onRevealRequested;

  @override
  Widget build(BuildContext context) {
    return AppFlashcardFace(
      front: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppLabel(text: item.instruction),
          SizedBox(height: context.spacing.md),
          AppTitleText(text: item.prompt),
          if (item.note != null) ...[
            SizedBox(height: context.spacing.md),
            AppBodyText(text: item.note!),
          ],
        ],
      ),
      back: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppLabel(text: item.prompt),
          SizedBox(height: context.spacing.md),
          AppTitleText(text: item.answer),
          if (item.pronunciation != null) ...[
            SizedBox(height: context.spacing.sm),
            AppBodyText(text: item.pronunciation!),
          ],
          if (item.note != null) ...[
            SizedBox(height: context.spacing.sm),
            AppBodyText(text: item.note!),
          ],
        ],
      ),
      isRevealed: answerRevealed,
      onTap: answerRevealed ? null : onRevealRequested,
    );
  }
}
