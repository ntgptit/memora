import 'package:flutter/material.dart';
import 'package:memora/core/config/app_strings.dart';
import 'package:memora/core/theme/extensions/screen_context_ext.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';
import 'package:memora/presentation/shared/primitives/displays/app_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final textTheme = context.textTheme;
    final screenClassMessage = AppStrings.dashboardScreenClassMessage(
      context.screenClass.label,
    );
    final contentMaxWidthMessage = AppStrings.dashboardContentMaxWidthMessage(
      context.layout.contentMaxWidth.toStringAsFixed(0),
    );

    return AppScaffold(
      title: AppStrings.appName,
      body: ListView(
        children: [
          Text(
            AppStrings.dashboardFoundationTitle,
            style: textTheme.headlineMedium,
          ),
          SizedBox(height: spacing.md),
          Text(
            AppStrings.dashboardFoundationDescription,
            style: textTheme.bodyLarge,
          ),
          SizedBox(height: spacing.xl),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.dashboardRuntimeSnapshotTitle,
                  style: textTheme.titleLarge,
                ),
                SizedBox(height: spacing.md),
                Text(screenClassMessage),
                SizedBox(height: spacing.xs),
                Text(contentMaxWidthMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
