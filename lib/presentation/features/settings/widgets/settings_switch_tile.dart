import 'package:flutter/material.dart';
import 'package:memora/presentation/features/settings/widgets/settings_tile.dart';
import 'package:memora/presentation/shared/primitives/selections/app_switch.dart';

class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.leading,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      onTap: () => onChanged(!value),
      trailing: AppSwitch(value: value, onChanged: onChanged),
    );
  }
}
