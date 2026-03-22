import 'package:flutter/material.dart';
import 'package:memora/core/config/app_strings.dart';
import 'package:memora/presentation/shared/composites/navigation/app_page_header.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_icon_button.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';
import 'package:memora/presentation/shared/primitives/displays/app_tag.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_title_text.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.focusLabel,
    required this.dueDeckCount,
    required this.dueCardCount,
    this.onRefresh,
  });

  final String title;
  final String subtitle;
  final String focusLabel;
  final int dueDeckCount;
  final int dueCardCount;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return AppPageHeader(
      title: AppTitleText(text: title),
      subtitle: AppBodyText(text: subtitle, isSecondary: true),
      actions: [
        AppIconButton(
          icon: const Icon(Icons.refresh_rounded),
          tooltip: AppStrings.dashboardRefreshTooltip,
          onPressed: onRefresh,
        ),
      ],
      bottom: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          AppTag(
            label: AppStrings.dashboardFocusChipLabel(focusLabel),
            icon: const Icon(Icons.auto_awesome_rounded, size: 14),
          ),
          AppChip(
            label: Text(
              AppStrings.dashboardDueDeckChipLabel(dueDeckCount.toString()),
            ),
          ),
          AppChip(
            label: Text(
              AppStrings.dashboardDueCardChipLabel(dueCardCount.toString()),
            ),
          ),
        ],
      ),
    );
  }
}
