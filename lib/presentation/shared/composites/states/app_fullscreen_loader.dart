import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/presentation/shared/composites/states/app_loading_state.dart';

class AppFullscreenLoader extends StatelessWidget {
  const AppFullscreenLoader({
    super.key,
    this.child,
    this.message,
    this.subtitle,
    this.backgroundColor,
    this.scrimColor,
  });

  final Widget? child;
  final String? message;
  final String? subtitle;
  final Color? backgroundColor;
  final Color? scrimColor;

  @override
  Widget build(BuildContext context) {
    final loader = ColoredBox(
      color: backgroundColor ?? context.colorScheme.surface,
      child: AppLoadingState(message: message ?? 'Loading', subtitle: subtitle),
    );

    if (child == null) {
      return SizedBox.expand(child: loader);
    }

    return Stack(
      children: [
        child!,
        Positioned.fill(
          child: ColoredBox(
            color:
                scrimColor ??
                context.colorScheme.surface.withValues(alpha: 0.72),
            child: loader,
          ),
        ),
      ],
    );
  }
}
