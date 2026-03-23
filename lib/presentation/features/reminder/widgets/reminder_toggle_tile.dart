import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/presentation/shared/primitives/selections/app_switch.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';

class ReminderToggleTile extends StatelessWidget {
  const ReminderToggleTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.textTheme.titleMedium),
              SizedBox(height: context.spacing.xxs),
              AppBodyText(text: subtitle, isSecondary: true),
            ],
          ),
        ),
        SizedBox(width: context.spacing.md),
        AppSwitch(value: value, onChanged: onChanged),
      ],
    );
  }
}
