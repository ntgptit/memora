import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/study/providers/study_l10n.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/shared/composites/lists/app_list_item.dart';
import 'package:memora/presentation/shared/primitives/displays/app_badge.dart';
import 'package:memora/presentation/shared/primitives/displays/app_icon.dart';
import 'package:memora/presentation/shared/primitives/displays/app_label.dart';

class StudyModeStepper extends StatelessWidget {
  const StudyModeStepper({
    super.key,
    required this.modePlan,
    this.onSelectMode,
  });

  final List<StudyModePlanEntry> modePlan;
  final ValueChanged<StudyMode>? onSelectMode;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppLabel(text: l10n.studyModeSequenceTitle),
        SizedBox(height: context.spacing.sm),
        for (final entry in modePlan) ...[
          Builder(
            builder: (context) {
              final stepLabel = '${modePlan.indexOf(entry) + 1}';
              return AppListItem(
                title: Text(entry.mode.label(l10n)),
                subtitle: Text(
                  l10n.studyModeProgressLabel(
                    entry.completedItems,
                    entry.totalItems,
                  ),
                ),
                selected: entry.isCurrent,
                leading: AppBadge(
                  label: Text(stepLabel),
                  child: AppIcon(entry.mode.icon),
                ),
                trailing: entry.retryItems == 0
                    ? null
                    : AppLabel(
                        text: l10n.studyRetryCountLabel(entry.retryItems),
                        color: context.colorScheme.error,
                      ),
                onTap: onSelectMode == null
                    ? null
                    : () => onSelectMode!(entry.mode),
              );
            },
          ),
          if (entry != modePlan.last) SizedBox(height: context.spacing.sm),
        ],
      ],
    );
  }
}
