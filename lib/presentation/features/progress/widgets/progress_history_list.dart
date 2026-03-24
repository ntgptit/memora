import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/progress/providers/progress_state.dart';
import 'package:memora/presentation/shared/composites/cards/app_info_card.dart';
import 'package:memora/presentation/shared/composites/lists/app_list_item.dart';
import 'package:memora/presentation/shared/primitives/displays/app_icon.dart';

class ProgressHistoryList extends StatelessWidget {
  const ProgressHistoryList({super.key, required this.state});

  final ProgressState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppInfoCard(
      title: l10n.progressHistoryTitle,
      subtitle: l10n.progressHistorySubtitle,
      child: Column(
        children: [
          for (final entry in state.history) ...[
            AppListItem(
              title: Text(entry.title),
              subtitle: Text(entry.subtitle),
              leading: AppIcon(
                entry.isPositive
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                color: entry.isPositive
                    ? context.colorScheme.primary
                    : context.colorScheme.error,
              ),
              trailing: Text(
                entry.timestampLabel,
                style: context.textTheme.labelMedium,
              ),
            ),
            SizedBox(height: context.spacing.sm),
          ],
        ],
      ),
    );
  }
}
