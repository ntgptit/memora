import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/shared/composites/cards/app_info_card.dart';
import 'package:memora/presentation/shared/primitives/displays/app_label.dart';

class FillQuestionView extends StatelessWidget {
  const FillQuestionView({super.key, required this.item});

  final StudySessionItem item;

  @override
  Widget build(BuildContext context) {
    return AppInfoCard(
      title: item.prompt,
      subtitle: item.instruction,
      leading: const Icon(Icons.keyboard_rounded),
      child: item.pronunciation == null
          ? null
          : Padding(
              padding: EdgeInsets.only(top: context.spacing.xs),
              child: AppLabel(text: item.pronunciation!),
            ),
    );
  }
}
