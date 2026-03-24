import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/study/providers/study_l10n.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/shared/composites/navigation/app_page_header.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_text_button.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_title_text.dart';

class StudyHeader extends StatelessWidget {
  const StudyHeader({
    super.key,
    required this.deck,
    required this.activeMode,
    required this.sessionType,
    required this.lifecycle,
    this.onOpenModePicker,
  });

  final StudyDeckSummary deck;
  final StudyMode activeMode;
  final StudySessionType sessionType;
  final StudySessionLifecycle lifecycle;
  final VoidCallback? onOpenModePicker;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppPageHeader(
      title: AppTitleText(text: deck.title),
      subtitle: AppBodyText(
        text: l10n.studyHeaderSubtitle(
          deck.folderLabel,
          sessionType.label(l10n),
        ),
      ),
      actions: [
        if (onOpenModePicker != null)
          AppTextButton(
            text: l10n.studyModePickerTitle,
            onPressed: onOpenModePicker,
          ),
      ],
      bottom: Wrap(
        spacing: context.spacing.xs,
        runSpacing: context.spacing.xs,
        children: [
          AppChip(label: Text(activeMode.label(l10n))),
          AppChip(label: Text(lifecycle.label(l10n))),
          AppChip(label: Text(l10n.studyDueCountLabel(deck.dueCards))),
        ],
      ),
    );
  }
}
