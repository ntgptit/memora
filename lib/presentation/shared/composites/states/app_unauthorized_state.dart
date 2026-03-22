import 'package:flutter/material.dart';
import 'package:memora/core/config/app_strings.dart';
import 'package:memora/presentation/shared/composites/states/app_error_state.dart';

class AppUnauthorizedState extends StatelessWidget {
  const AppUnauthorizedState({
    super.key,
    this.onActionPressed,
    this.actionLabel,
    this.message,
    this.maxWidth,
  });

  final VoidCallback? onActionPressed;
  final String? actionLabel;
  final String? message;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return AppErrorState(
      title: AppStrings.accessRequiredTitle,
      message: message ?? AppStrings.signInMessage,
      primaryActionLabel: actionLabel ?? AppStrings.signInLabel,
      onPrimaryAction: onActionPressed,
      maxWidth: maxWidth,
    );
  }
}
