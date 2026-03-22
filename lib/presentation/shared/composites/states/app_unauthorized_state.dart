import 'package:flutter/material.dart';
import 'package:memora/l10n/l10n.dart';
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
      title: context.l10n.accessRequiredTitle,
      message: message ?? context.l10n.signInMessage,
      primaryActionLabel: actionLabel ?? context.l10n.signInLabel,
      onPrimaryAction: onActionPressed,
      maxWidth: maxWidth,
    );
  }
}
