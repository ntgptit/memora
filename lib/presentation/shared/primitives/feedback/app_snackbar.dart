import 'package:flutter/material.dart';
import 'package:memora/core/enums/snackbar_type.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';

class AppSnackbar extends StatelessWidget {
  const AppSnackbar({
    super.key,
    required this.message,
    this.title,
    this.type = SnackbarType.info,
    this.actionLabel,
    this.onActionPressed,
    this.leading,
  });

  final String message;
  final String? title;
  final SnackbarType type;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final tone = _tone(context);
    final icon = leading ??
        Icon(
          _iconFor(type),
          color: tone.foreground,
          size: context.iconSize.lg,
        );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(context.radius.lg),
        border: Border.all(color: tone.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.spacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            SizedBox(width: context.spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    Text(
                      title!,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: tone.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: context.spacing.xxs),
                  ],
                  Text(
                    message,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: tone.foreground.withValues(alpha: 0.92),
                    ),
                  ),
                ],
              ),
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              SizedBox(width: context.spacing.sm),
              TextButton(
                onPressed: onActionPressed,
                style: TextButton.styleFrom(foregroundColor: tone.foreground),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _Tone _tone(BuildContext context) {
    return switch (type) {
      SnackbarType.success => _Tone(
        background: context.appColors.successContainer,
        foreground: context.appColors.onSuccessContainer,
        border: context.appColors.success.withValues(alpha: 0.24),
      ),
      SnackbarType.error => _Tone(
        background: context.colorScheme.errorContainer,
        foreground: context.colorScheme.onErrorContainer,
        border: context.colorScheme.error.withValues(alpha: 0.24),
      ),
      SnackbarType.info => _Tone(
        background: context.appColors.infoContainer,
        foreground: context.appColors.onInfoContainer,
        border: context.appColors.info.withValues(alpha: 0.24),
      ),
      SnackbarType.warning => _Tone(
        background: context.appColors.warningContainer,
        foreground: context.appColors.onWarningContainer,
        border: context.appColors.warning.withValues(alpha: 0.24),
      ),
    };
  }

  IconData _iconFor(SnackbarType type) {
    return switch (type) {
      SnackbarType.success => Icons.check_circle_rounded,
      SnackbarType.error => Icons.error_rounded,
      SnackbarType.info => Icons.info_rounded,
      SnackbarType.warning => Icons.warning_rounded,
    };
  }
}

class _Tone {
  const _Tone({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}
