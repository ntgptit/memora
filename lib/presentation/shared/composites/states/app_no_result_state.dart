import 'package:flutter/material.dart';
import 'package:memora/core/config/app_strings.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/composites/states/app_empty_state.dart';
import 'package:memora/presentation/shared/primitives/displays/app_icon.dart';

class AppNoResultState extends StatelessWidget {
  const AppNoResultState({
    super.key,
    this.message,
    this.actionLabel,
    this.onActionPressed,
    this.maxWidth,
  });

  final String? message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: AppStrings.noResultsTitle,
      message: message ?? AppStrings.noResultsMessage,
      icon: const AppIcon(Icons.search_off_rounded),
      maxWidth: maxWidth,
      actions: [
        if (actionLabel != null && onActionPressed != null)
          AppPrimaryButton(text: actionLabel!, onPressed: onActionPressed),
      ],
    );
  }
}
