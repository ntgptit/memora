import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_title_text.dart';

class FlashcardMeaningView extends StatelessWidget {
  const FlashcardMeaningView({
    super.key,
    required this.backText,
    this.backLangCode,
    this.note,
    this.isBookmarked = false,
  });

  final String backText;
  final String? backLangCode;
  final String? note;
  final bool isBookmarked;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (backLangCode != null && backLangCode!.trim().isNotEmpty) ...[
          AppChip(label: Text(backLangCode!.trim().toUpperCase())),
          SizedBox(height: context.spacing.sm),
        ],
        AppTitleText(
          text: backText,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
        if (note != null && note!.trim().isNotEmpty) ...[
          SizedBox(height: context.spacing.sm),
          AppBodyText(text: note!, isSecondary: true),
        ],
        if (isBookmarked) ...[
          SizedBox(height: context.spacing.sm),
          AppChip(label: Text(context.l10n.flashcardPinnedLabel)),
        ],
      ],
    );
  }
}
