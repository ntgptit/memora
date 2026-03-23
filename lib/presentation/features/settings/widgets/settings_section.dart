import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/presentation/shared/primitives/displays/app_card.dart';
import 'package:memora/presentation/shared/primitives/displays/app_divider.dart';
import 'package:memora/presentation/shared/primitives/displays/app_label.dart';
import 'package:memora/presentation/shared/primitives/text/app_title_text.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTitleText(text: title, style: context.textTheme.titleMedium),
        if (subtitle != null) ...[
          SizedBox(height: context.spacing.xxs),
          AppLabel(text: subtitle!),
        ],
        SizedBox(height: context.spacing.sm),
        AppCard(
          padding: EdgeInsets.all(context.spacing.sm),
          child: Column(children: _withDividers(context)),
        ),
      ],
    );
  }

  List<Widget> _withDividers(BuildContext context) {
    final items = <Widget>[];
    for (var index = 0; index < children.length; index++) {
      items.add(children[index]);
      if (index != children.length - 1) {
        items.add(AppDivider(height: context.spacing.sm));
      }
    }
    return items;
  }
}
