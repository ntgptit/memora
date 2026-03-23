import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/core/config/app_limits.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_outline_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/inputs/app_text_field.dart';

class FlashcardEditorForm extends StatefulWidget {
  const FlashcardEditorForm({
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
  State<FlashcardEditorForm> createState() => _FlashcardEditorFormState();
}

class _FlashcardEditorFormState extends State<FlashcardEditorForm> {
  late final TextEditingController _frontTextController;
  late final TextEditingController _backTextController;
  late final TextEditingController _frontLangController;
  late final TextEditingController _backLangController;
  String? _errorText;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _frontTextController = TextEditingController(
      text: widget.initialFrontText ?? '',
    );
    _backTextController = TextEditingController(
      text: widget.initialBackText ?? '',
    );
    _frontLangController = TextEditingController(
      text: widget.initialFrontLangCode ?? '',
    );
    _backLangController = TextEditingController(
      text: widget.initialBackLangCode ?? '',
    );
  }

  @override
  void dispose() {
    _frontTextController.dispose();
    _backTextController.dispose();
    _frontLangController.dispose();
    _backLangController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: context.colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.spacing.lg),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.title, style: context.textTheme.titleLarge),
                SizedBox(height: context.spacing.md),
                AppTextField(
                  label: l10n.flashcardFrontFieldLabel,
                  isRequired: true,
                  controller: _frontTextController,
                  maxLength: AppLimits.maxFlashcardFrontLength,
                  maxLines: 4,
                ),
                SizedBox(height: context.spacing.md),
                AppTextField(
                  label: l10n.flashcardBackFieldLabel,
                  isRequired: true,
                  controller: _backTextController,
                  maxLength: AppLimits.maxFlashcardBackLength,
                  maxLines: 6,
                ),
                SizedBox(height: context.spacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: l10n.flashcardFrontLangFieldLabel,
                        controller: _frontLangController,
                      ),
                    ),
                    SizedBox(width: context.spacing.sm),
                    Expanded(
                      child: AppTextField(
                        label: l10n.flashcardBackLangFieldLabel,
                        controller: _backLangController,
                      ),
                    ),
                  ],
                ),
                if (_errorText != null) ...[
                  SizedBox(height: context.spacing.md),
                  Text(
                    _errorText!,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.error,
                    ),
                  ),
                ],
                SizedBox(height: context.spacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: AppOutlineButton(
                        text: l10n.cancelLabel,
                        onPressed: _isSubmitting ? null : () => context.pop(),
                      ),
                    ),
                    SizedBox(width: context.spacing.sm),
                    Expanded(
                      child: AppPrimaryButton(
                        text: widget.submitLabel,
                        onPressed: _isSubmitting ? null : _submit,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.viewInsetsOf(context).bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final frontText = _frontTextController.text.trim();
    final backText = _backTextController.text.trim();
    final frontLangCode = _frontLangController.text.trim();
    final backLangCode = _backLangController.text.trim();

    if (frontText.isEmpty) {
      setState(() => _errorText = context.l10n.flashcardFrontRequiredMessage);
      return;
    }
    if (backText.isEmpty) {
      setState(() => _errorText = context.l10n.flashcardBackRequiredMessage);
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    try {
      await widget.onSubmit(
        frontText,
        backText,
        frontLangCode.isEmpty ? null : frontLangCode,
        backLangCode.isEmpty ? null : backLangCode,
      );
      if (mounted) {
        context.pop();
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSubmitting = false;
        _errorText = error.toString();
      });
      return;
    }

    if (mounted) {
      setState(() => _isSubmitting = false);
    }
  }
}
