import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/shared/composites/cards/app_info_card.dart';
import 'package:memora/presentation/shared/primitives/displays/app_label.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';

class GuessQuestionView extends StatelessWidget {
  const GuessQuestionView({super.key, required this.item});

  final StudySessionItem item;

  @override
  Widget build(BuildContext context) {
    return AppInfoCard(
      title: item.prompt,
      subtitle: item.instruction,
      leading: const Icon(Icons.ads_click_rounded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.note != null) AppBodyText(text: item.note!),
          if (item.pronunciation != null) ...[
            SizedBox(height: context.spacing.md),
            AppLabel(text: item.pronunciation!),
          ],
        ],
      ),
    );
  }
}
