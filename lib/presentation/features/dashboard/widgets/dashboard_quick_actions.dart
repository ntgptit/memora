import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/dashboard/providers/dashboard_l10n.dart';
import 'package:memora/presentation/features/dashboard/providers/dashboard_state.dart';
import 'package:memora/presentation/shared/composites/cards/app_action_card.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({
    super.key,
    required this.actions,
    required this.focusLabel,
    required this.onApplyAction,
    required this.onDeferAction,
  });

  final List<DashboardQuickActionItem> actions;
  final String focusLabel;
  final ValueChanged<String> onApplyAction;
  final ValueChanged<String> onDeferAction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.dashboardQuickActionsTitle,
                    style: context.textTheme.titleLarge,
                  ),
                  SizedBox(height: context.spacing.xxs),
                  Text(
                    l10n.dashboardQuickActionsSubtitle,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: context.spacing.sm),
            AppChip(label: Text(l10n.dashboardFocusChipLabel(focusLabel))),
          ],
        ),
        SizedBox(height: context.spacing.md),
        if (actions.isEmpty)
          AppActionCard(
            title: l10n.dashboardQuickActionsEmptyTitle,
            subtitle: l10n.dashboardQuickActionsEmptySubtitle,
            leading: const Icon(Icons.check_circle_outline_rounded),
          )
        else ...[
          for (var index = 0; index < actions.length; index++) ...[
            if (index > 0) SizedBox(height: context.spacing.md),
            AppActionCard(
              title: actions[index].type.title(l10n),
              subtitle: actions[index].type.subtitle(l10n),
              leading: Icon(actions[index].icon),
              trailing: AppChip(
                label: Text(actions[index].type.focus.label(l10n)),
              ),
              primaryActionLabel: actions[index].type.primaryActionLabel(l10n),
              secondaryActionLabel: actions[index].type.secondaryActionLabel(
                l10n,
              ),
              onPrimaryAction: () => onApplyAction(actions[index].id),
              onSecondaryAction: () => onDeferAction(actions[index].id),
            ),
          ],
        ],
      ],
    );
  }
}
