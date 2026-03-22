import 'package:flutter/material.dart';
import 'package:memora/presentation/shared/composites/states/app_error_state.dart';

class AppOfflineState extends StatelessWidget {
  const AppOfflineState({
    super.key,
    this.onRetry,
    this.retryLabel,
    this.message,
    this.maxWidth,
  });

  final VoidCallback? onRetry;
  final String? retryLabel;
  final String? message;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return AppErrorState(
      title: 'You are offline',
      message: message ?? 'Check your connection and try again.',
      primaryActionLabel: retryLabel ?? 'Retry',
      onPrimaryAction: onRetry,
      maxWidth: maxWidth,
    );
  }
}
