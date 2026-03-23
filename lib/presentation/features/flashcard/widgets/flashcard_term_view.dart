import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_title_text.dart';

class FlashcardTermView extends StatelessWidget {
  const FlashcardTermView({
    super.key,
    required this.frontText,
    this.frontLangCode,
    this.pronunciation,
  });

  final String frontText;
  final String? frontLangCode;
  final String? pronunciation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (frontLangCode != null && frontLangCode!.trim().isNotEmpty) ...[
          AppChip(label: Text(frontLangCode!.trim().toUpperCase())),
          SizedBox(height: context.spacing.sm),
        ],
        AppTitleText(
          text: frontText,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        if (pronunciation != null && pronunciation!.trim().isNotEmpty) ...[
          SizedBox(height: context.spacing.sm),
          AppBodyText(text: pronunciation!, isSecondary: true),
        ],
      ],
    );
  }
}
