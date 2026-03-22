import 'package:flutter/material.dart';
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
      title: 'Access required',
      message: message ?? 'Sign in to continue.',
      primaryActionLabel: actionLabel ?? 'Sign in',
      onPrimaryAction: onActionPressed,
      maxWidth: maxWidth,
    );
  }
}
