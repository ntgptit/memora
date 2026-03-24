import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/progress/providers/progress_state.dart';
import 'package:memora/presentation/shared/composites/cards/app_info_card.dart';
import 'package:memora/presentation/shared/composites/cards/app_stat_card.dart';
import 'package:memora/presentation/shared/primitives/displays/app_label.dart';
import 'package:memora/presentation/shared/primitives/displays/app_progress_bar.dart';

const double _progressChartStatCardWidth = 168;

class ProgressChartSection extends StatelessWidget {
  const ProgressChartSection({super.key, required this.state});

  final ProgressState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppInfoCard(
      title: l10n.progressChartTitle,
      subtitle: l10n.progressChartSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final bucket in state.boxDistribution) ...[
            _BucketRow(bucket: bucket),
            SizedBox(height: context.spacing.sm),
          ],
          Wrap(
            spacing: context.spacing.md,
            runSpacing: context.spacing.md,
            children: [
              SizedBox(
                width: _progressChartStatCardWidth,
                child: AppStatCard(
                  label: l10n.progressPassedAttemptsLabel,
                  value: state.passedAttempts.toString(),
                ),
              ),
              SizedBox(
                width: _progressChartStatCardWidth,
                child: AppStatCard(
                  label: l10n.progressFailedAttemptsLabel,
                  value: state.failedAttempts.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BucketRow extends StatelessWidget {
  const _BucketRow({required this.bucket});

  final ProgressDistributionBucket bucket;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: AppLabel(text: bucket.label)),
            AppLabel(text: bucket.count.toString()),
          ],
        ),
        SizedBox(height: context.spacing.xs),
        AppProgressBar(value: bucket.value.clamp(0, 1)),
      ],
    );
  }
}
