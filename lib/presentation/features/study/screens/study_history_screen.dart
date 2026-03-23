import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/study/providers/study_l10n.dart';
import 'package:memora/presentation/features/study/providers/study_result_provider.dart';
import 'package:memora/presentation/shared/composites/cards/app_action_card.dart';
import 'package:memora/presentation/shared/layouts/app_list_page_layout.dart';

class StudyHistoryScreen extends ConsumerWidget {
  const StudyHistoryScreen({super.key, this.onResumeSession});

  final ValueChanged<String>? onResumeSession;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(studyResultControllerProvider);
    final l10n = context.l10n;
    final formatter = DateFormat.yMMMd();
    return AppListPageLayout(
      title: Text(l10n.studyHistoryTitle),
      subtitle: Text(l10n.studyHistorySubtitle),
      body: ListView.separated(
        itemCount: result.recentSessions.length,
        itemBuilder: (context, index) {
          final entry = result.recentSessions[index];
          return AppActionCard(
            title: entry.deckTitle,
            subtitle: l10n.studyHistoryEntryDescription(
              entry.status.label(l10n),
              entry.primaryMode.label(l10n),
              formatter.format(entry.completedAt),
            ),
            leading: const Icon(Icons.history_rounded),
            primaryActionLabel: onResumeSession == null
                ? null
                : l10n.studyResumeAction,
            onPrimaryAction: onResumeSession == null
                ? null
                : () => onResumeSession!(entry.id),
          );
        },
        separatorBuilder: (context, index) =>
            SizedBox(height: context.spacing.lg),
      ),
    );
  }
}
