import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/presentation/features/study/modes/review/review_flashcard_view.dart';
import 'package:memora/presentation/features/study/modes/review/review_mode_provider.dart';
import 'package:memora/presentation/features/study/modes/review/review_score_panel.dart';

class ReviewModeScreen extends ConsumerWidget {
  const ReviewModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reviewModeControllerProvider);
    if (state == null) {
      return const SizedBox.shrink();
    }

    final controller = ref.read(reviewModeControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReviewFlashcardView(item: state.item),
        SizedBox(height: context.spacing.lg),
        ReviewScorePanel(
          state: state,
          onRemembered: controller.markRemembered,
          onRetry: controller.retryItem,
          onNext: controller.goNext,
        ),
      ],
    );
  }
}
