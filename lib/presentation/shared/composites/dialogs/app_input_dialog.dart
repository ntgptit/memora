import 'package:flutter/material.dart';
import 'package:memora/core/enums/dialog_type.dart';
import 'package:memora/presentation/shared/composites/dialogs/app_alert_dialog.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_outline_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/inputs/app_text_field.dart';

class AppInputDialog extends StatefulWidget {
  const AppInputDialog({
    super.key,
    required this.title,
    required this.onSubmitted,
    this.content,
    this.initialValue,
    this.hintText,
    this.confirmLabel = 'Save',
    this.cancelLabel = 'Cancel',
    this.type = DialogType.info,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String title;
  final Widget? content;
  final String? initialValue;
  final String? hintText;
  final String confirmLabel;
  final String cancelLabel;
  final DialogType type;
  final TextInputType? keyboardType;
  final int? maxLines;
  final ValueChanged<String> onSubmitted;

  @override
  State<AppInputDialog> createState() => _AppInputDialogState();
}

class _AppInputDialogState extends State<AppInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppAlertDialog(
      title: widget.title,
      type: widget.type,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.content != null) ...[
            widget.content!,
            const SizedBox(height: 16),
          ],
          AppTextField(
            controller: _controller,
            hintText: widget.hintText,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            onSubmitted: (_) => _submit(),
            onEditingComplete: _submit,
          ),
        ],
      ),
      actions: [
        AppOutlineButton(
          text: widget.cancelLabel,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        AppPrimaryButton(
          text: widget.confirmLabel,
          onPressed: _submit,
        ),
      ],
    );
  }

  void _submit() {
    Navigator.of(context).pop();
    widget.onSubmitted(_controller.text);
  }
}
