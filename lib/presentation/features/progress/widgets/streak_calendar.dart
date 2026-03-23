import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/progress/providers/progress_state.dart';
import 'package:memora/presentation/shared/composites/cards/app_info_card.dart';

class StreakCalendar extends StatelessWidget {
  const StreakCalendar({super.key, required this.streakDays});

  final List<ProgressStreakDay> streakDays;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppInfoCard(
      title: l10n.progressCalendarTitle,
      subtitle: l10n.progressCalendarSubtitle,
      child: Wrap(
        spacing: context.spacing.sm,
        runSpacing: context.spacing.sm,
        children: [
          for (final day in streakDays)
            SizedBox(
              width: 44,
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: day.completed
                          ? context.colorScheme.primaryContainer
                          : context.colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(context.radius.md),
                      border: Border.all(
                        color: day.isToday
                            ? context.colorScheme.primary
                            : context.colorScheme.outlineVariant,
                        width: day.isToday ? 2 : 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      day.label,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: day.completed
                            ? context.colorScheme.onPrimaryContainer
                            : context.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: context.spacing.xxs),
                  Icon(
                    day.completed ? Icons.check_rounded : Icons.close_rounded,
                    size: 16,
                    color: day.completed
                        ? context.colorScheme.primary
                        : context.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
