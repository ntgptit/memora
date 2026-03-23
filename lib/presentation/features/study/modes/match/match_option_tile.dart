import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/shared/composites/lists/app_list_item.dart';

class MatchOptionTile extends StatelessWidget {
  const MatchOptionTile({
    super.key,
    required this.option,
    required this.selected,
    required this.matched,
    required this.onTap,
  });

  final StudyMatchOption option;
  final bool selected;
  final bool matched;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppListItem(
      title: Text(option.label),
      subtitle: option.detail == null ? null : Text(option.detail!),
      selected: selected,
      backgroundColor: matched ? context.colorScheme.secondaryContainer : null,
      trailing: matched
          ? const Icon(Icons.check_circle_rounded)
          : (selected ? const Icon(Icons.touch_app_rounded) : null),
      onTap: onTap,
      compact: true,
    );
  }
}
