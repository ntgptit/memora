import 'package:flutter/material.dart';
import 'package:memora/presentation/shared/composites/lists/app_list_item.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppListItem(
      onTap: onTap,
      leading: leading,
      trailing: trailing,
      title: Text(title),
      subtitle: subtitle == null
          ? null
          : AppBodyText(
              text: subtitle!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              isSecondary: true,
            ),
    );
  }
}
