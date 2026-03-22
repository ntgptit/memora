import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/core/theme/tokens/opacity_tokens.dart';
import 'package:memora/presentation/shared/primitives/displays/app_icon.dart';

class AppSwipeListItem extends StatelessWidget {
  const AppSwipeListItem({
    super.key,
    required this.child,
    this.onDismissed,
    this.confirmDismiss,
    this.background,
    this.secondaryBackground,
    this.direction = DismissDirection.horizontal,
    this.dismissThresholds,
  });

  final Widget child;
  final DismissDirectionCallback? onDismissed;
  final ConfirmDismissCallback? confirmDismiss;
  final Widget? background;
  final Widget? secondaryBackground;
  final DismissDirection direction;
  final Map<DismissDirection, double>? dismissThresholds;

  @override
  Widget build(BuildContext context) {
    if (onDismissed == null) {
      return child;
    }

    return Dismissible(
      key: key ?? ValueKey<Object>(Object.hash(runtimeType, child.hashCode)),
      direction: direction,
      dismissThresholds: dismissThresholds ?? const <DismissDirection, double>{},
      confirmDismiss: confirmDismiss,
      onDismissed: onDismissed!,
      background: background ?? _buildBackground(context, alignment: Alignment.centerLeft),
      secondaryBackground: secondaryBackground ??
          _buildBackground(context, alignment: Alignment.centerRight),
      child: child,
    );
  }

  Widget _buildBackground(BuildContext context, {required Alignment alignment}) {
    return Container(
      alignment: alignment,
      color: context.colorScheme.error.withValues(
        alpha: AppOpacityTokens.subtle,
      ),
      padding: EdgeInsets.symmetric(horizontal: context.spacing.md),
      child: AppIcon(
        Icons.delete_rounded,
        color: context.colorScheme.error,
      ),
    );
  }
}
