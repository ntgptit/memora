import 'package:flutter/material.dart';
import 'package:memora/presentation/features/flashcard/widgets/flashcard_editor_form.dart';

class FlashcardFormScreen extends StatelessWidget {
  const FlashcardFormScreen({
    super.key,
    required this.title,
    required this.submitLabel,
    required this.onSubmit,
    this.initialFrontText,
    this.initialBackText,
    this.initialFrontLangCode,
    this.initialBackLangCode,
  });

  final String title;
  final String submitLabel;
  final String? initialFrontText;
  final String? initialBackText;
  final String? initialFrontLangCode;
  final String? initialBackLangCode;
  final Future<void> Function(
    String frontText,
    String backText,
    String? frontLangCode,
    String? backLangCode,
  )
  onSubmit;

  @override
  Widget build(BuildContext context) {
    return FlashcardEditorForm(
      title: title,
      submitLabel: submitLabel,
      initialFrontText: initialFrontText,
      initialBackText: initialBackText,
      initialFrontLangCode: initialFrontLangCode,
      initialBackLangCode: initialBackLangCode,
      onSubmit: onSubmit,
    );
  }
}
