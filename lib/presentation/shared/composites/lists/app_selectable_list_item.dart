import 'package:flutter/material.dart';
import 'package:memora/presentation/shared/composites/lists/app_list_item.dart';
import 'package:memora/presentation/shared/primitives/selections/app_checkbox.dart';

enum AppSelectionControlPlacement { leading, trailing }

class AppSelectableListItem extends StatelessWidget {
  const AppSelectableListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.selected = false,
    this.onChanged,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.controlPlacement = AppSelectionControlPlacement.leading,
    this.compact = false,
  });

  final Widget title;
  final Widget? subtitle;
  final bool selected;
  final ValueChanged<bool>? onChanged;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;
  final AppSelectionControlPlacement controlPlacement;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final control = AppCheckbox(
      value: selected,
      onChanged: enabled ? (value) => onChanged?.call(value ?? false) : null,
    );

    return AppListItem(
      title: title,
      subtitle: subtitle,
      leading: controlPlacement == AppSelectionControlPlacement.leading
          ? _composeLeading(control)
          : leading,
      trailing: controlPlacement == AppSelectionControlPlacement.trailing
          ? _composeTrailing(control)
          : trailing,
      selected: selected,
      compact: compact,
      onTap: enabled ? () => onChanged?.call(!selected) : null,
    );
  }

  Widget _composeLeading(Widget control) {
    if (leading == null) {
      return control;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [control, const SizedBox(width: 8), leading!],
    );
  }

  Widget _composeTrailing(Widget control) {
    if (trailing == null) {
      return control;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [trailing!, const SizedBox(width: 8), control],
    );
  }
}
