import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.expand = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expand ? double.infinity : null,
      height: context.component.buttonHeight,
      child: FilledButton(onPressed: onPressed, child: Text(text)),
    );
  }
}
