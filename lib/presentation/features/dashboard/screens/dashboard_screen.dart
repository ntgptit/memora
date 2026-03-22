import 'package:flutter/material.dart';
import 'package:memora/core/config/app_strings.dart';
import 'package:memora/core/theme/extensions/screen_context_ext.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final textTheme = context.textTheme;

    return AppScaffold(
      title: AppStrings.appName,
      body: ListView(
        children: [
          Text(
            'Dashboard foundation',
            style: textTheme.headlineMedium,
          ),
          SizedBox(height: spacing.md),
          Text(
            'Architecture scaffold is ready for app, core, presentation, data, domain, and l10n.',
            style: textTheme.bodyLarge,
          ),
          SizedBox(height: spacing.xl),
          Card(
            child: Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Runtime snapshot',
                    style: textTheme.titleLarge,
                  ),
                  SizedBox(height: spacing.md),
                  Text('Screen class: ${context.screenClass.label}'),
                  SizedBox(height: spacing.xs),
                  Text(
                    'Content max width: ${context.layout.contentMaxWidth.toStringAsFixed(0)}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
