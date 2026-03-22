import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_circular_loader.dart';
import 'package:memora/presentation/shared/primitives/displays/app_label.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';

class AppLoadingState extends StatelessWidget {
  const AppLoadingState({
    super.key,
    this.message = 'Loading',
    this.subtitle,
    this.loader,
    this.maxWidth,
    this.padding,
  });

  final String message;
  final String? subtitle;
  final Widget? loader;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? 320),
        child: Padding(
          padding: padding ?? EdgeInsets.all(context.spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              loader ?? const AppCircularLoader(),
              SizedBox(height: context.spacing.md),
              AppLabel(text: message, textAlign: TextAlign.center),
              if (subtitle != null) ...[
                SizedBox(height: context.spacing.xxs),
                AppBodyText(text: subtitle!, textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
