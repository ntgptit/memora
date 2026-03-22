import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_title_text.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.child,
    this.actions = const [],
    this.maxWidth,
    this.padding,
  });

  final String title;
  final String? message;
  final Widget? icon;
  final Widget? child;
  final List<Widget> actions;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? 520),
        child: Padding(
          padding: padding ?? EdgeInsets.all(context.spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                SizedBox(height: context.spacing.md),
              ],
              AppTitleText(text: title, textAlign: TextAlign.center),
              if (message != null) ...[
                SizedBox(height: context.spacing.xs),
                AppBodyText(text: message!, textAlign: TextAlign.center),
              ],
              if (child != null) ...[
                SizedBox(height: context.spacing.md),
                child!,
              ],
              if (actions.isNotEmpty) ...[
                SizedBox(height: context.spacing.md),
                Wrap(
                  spacing: context.spacing.sm,
                  runSpacing: context.spacing.sm,
                  alignment: WrapAlignment.center,
                  children: actions,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
