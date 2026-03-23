import 'package:flutter/material.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/shared/composites/cards/app_info_card.dart';

class RecallAnswerView extends StatelessWidget {
  const RecallAnswerView({
    super.key,
    required this.item,
    required this.answerRevealed,
  });

  final StudySessionItem item;
  final bool answerRevealed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppInfoCard(
      title: answerRevealed
          ? l10n.studyRecallAnswerTitle
          : l10n.studyRecallAnswerHiddenTitle,
      subtitle: answerRevealed
          ? item.answer
          : l10n.studyRecallAnswerHiddenSubtitle,
      leading: Icon(
        answerRevealed
            ? Icons.visibility_rounded
            : Icons.visibility_off_rounded,
      ),
      child: answerRevealed && item.note != null ? Text(item.note!) : null,
    );
  }
}
