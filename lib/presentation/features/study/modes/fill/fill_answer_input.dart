import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/shared/composites/cards/app_info_card.dart';
import 'package:memora/presentation/shared/primitives/inputs/app_text_field.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';

class FillAnswerInput extends StatefulWidget {
  const FillAnswerInput({
    super.key,
    required this.item,
    required this.answer,
    required this.answerRevealed,
    required this.onChanged,
  });

  final StudySessionItem item;
  final String answer;
  final bool answerRevealed;
  final ValueChanged<String> onChanged;

  @override
  State<FillAnswerInput> createState() => _FillAnswerInputState();
}

class _FillAnswerInputState extends State<FillAnswerInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.answer);
  }

  @override
  void didUpdateWidget(covariant FillAnswerInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.answer != widget.answer &&
        _controller.text != widget.answer) {
      _controller.text = widget.answer;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppInfoCard(
      title: l10n.studyFillInputTitle,
      subtitle: l10n.studyFillInputSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _controller,
            hintText: widget.item.inputPlaceholder,
            maxLines: 2,
            onChanged: widget.onChanged,
          ),
          if (widget.answerRevealed) ...[
            SizedBox(height: context.spacing.md),
            AppBodyText(text: l10n.studyFillAnswerReveal(widget.item.answer)),
          ],
        ],
      ),
    );
  }
}
