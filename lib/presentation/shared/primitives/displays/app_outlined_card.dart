import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';

class AppOutlinedCard extends StatelessWidget {
  const AppOutlinedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      elevation: 0,
      color: context.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: context.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(context.radius.lg),
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(context.spacing.md),
        child: child,
      ),
    );
  }
}
