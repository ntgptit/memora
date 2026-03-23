import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/shared/composites/cards/app_info_card.dart';
import 'package:memora/presentation/shared/primitives/displays/app_label.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_title_text.dart';

class ReviewFlashcardView extends StatelessWidget {
  const ReviewFlashcardView({super.key, required this.item});

  final StudySessionItem item;

  @override
  Widget build(BuildContext context) {
    return AppInfoCard(
      title: item.prompt,
      subtitle: item.answer,
      leading: const Icon(Icons.auto_stories_rounded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppLabel(text: item.instruction),
          if (item.note != null) ...[
            SizedBox(height: context.spacing.sm),
            AppBodyText(text: item.note!),
          ],
          if (item.pronunciation != null) ...[
            SizedBox(height: context.spacing.md),
            AppTitleText(
              text: item.pronunciation!,
              style: context.textTheme.titleMedium,
            ),
          ],
        ],
      ),
    );
  }
}
