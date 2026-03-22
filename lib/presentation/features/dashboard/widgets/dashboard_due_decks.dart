import 'package:flutter/material.dart';
import 'package:memora/core/config/app_strings.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/presentation/features/dashboard/providers/dashboard_state.dart';
import 'package:memora/presentation/shared/composites/cards/app_action_card.dart';

class DashboardDueDecks extends StatelessWidget {
  const DashboardDueDecks({
    super.key,
    required this.decks,
    required this.onStartDeck,
    required this.onSnoozeDeck,
  });

  final List<DashboardDueDeckItem> decks;
  final ValueChanged<String> onStartDeck;
  final ValueChanged<String> onSnoozeDeck;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.dashboardDueDecksTitle,
          style: context.textTheme.titleLarge,
        ),
        SizedBox(height: context.spacing.xxs),
        Text(
          AppStrings.dashboardDueDecksSubtitle,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: context.spacing.md),
        if (decks.isEmpty)
          AppActionCard(
            title: AppStrings.dashboardCompleteFocusLabel,
            subtitle: AppStrings.dashboardNoDueDecksSubtitle,
            leading: const Icon(Icons.check_circle_rounded),
          )
        else ...[
          for (var index = 0; index < decks.length; index++) ...[
            if (index > 0) SizedBox(height: context.spacing.md),
            AppActionCard(
              title: decks[index].title,
              subtitle: AppStrings.dashboardDeckStatusMessage(
                decks[index].folderName,
                decks[index].modeLabel,
                (decks[index].masteryProgress * 100).round().toString(),
              ),
              leading: Icon(
                decks[index].isPriority
                    ? Icons.priority_high_rounded
                    : Icons.auto_stories_rounded,
              ),
              trailing: _DuePill(
                label: AppStrings.dashboardDueCountLabel(
                  decks[index].dueCardCount.toString(),
                ),
                isPriority: decks[index].isPriority,
              ),
              primaryActionLabel: AppStrings.dashboardStartActionLabel,
              secondaryActionLabel: AppStrings.dashboardLaterActionLabel,
              onPrimaryAction: () => onStartDeck(decks[index].id),
              onSecondaryAction: () => onSnoozeDeck(decks[index].id),
            ),
          ],
        ],
      ],
    );
  }
}

class _DuePill extends StatelessWidget {
  const _DuePill({required this.label, required this.isPriority});

  final String label;
  final bool isPriority;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.sm,
        vertical: context.spacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isPriority
            ? context.colorScheme.errorContainer
            : context.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(context.radius.pill),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: isPriority
              ? context.colorScheme.onErrorContainer
              : context.colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
