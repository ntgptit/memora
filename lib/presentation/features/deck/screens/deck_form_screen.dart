import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_outline_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/inputs/app_text_field.dart';

class DeckFormScreen extends StatefulWidget {
  const DeckFormScreen({
    super.key,
    required this.title,
    required this.submitLabel,
    required this.onSubmit,
    this.initialName,
    this.initialDescription,
  });

  final String title;
  final String submitLabel;
  final String? initialName;
  final String? initialDescription;
  final Future<void> Function(String name, String? description) onSubmit;

  @override
  State<DeckFormScreen> createState() => _DeckFormScreenState();
}

class _DeckFormScreenState extends State<DeckFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  String? _errorText;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _descriptionController = TextEditingController(
      text: widget.initialDescription ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
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
                  label: l10n.deckNameLabel,
                  isRequired: true,
                  controller: _nameController,
                ),
                SizedBox(height: context.spacing.md),
                AppTextField(
                  label: l10n.deckDescriptionLabel,
                  controller: _descriptionController,
                  maxLines: 4,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorText = context.l10n.deckNameRequiredMessage);
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    try {
      await widget.onSubmit(
        name,
        description.isEmpty ? null : description,
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
