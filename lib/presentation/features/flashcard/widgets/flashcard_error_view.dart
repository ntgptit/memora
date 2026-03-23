import 'package:flutter/material.dart';
import 'package:memora/core/enums/snackbar_type.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/layouts/app_list_page_layout.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_banner.dart';

class FlashcardErrorView extends StatelessWidget {
  const FlashcardErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AppListPageLayout(
      title: Text(context.l10n.flashcardsTitle),
      subtitle: Text(context.l10n.flashcardScreenSubtitle),
      body: Center(
        child: AppBanner(
          title: context.l10n.flashcardErrorBannerTitle,
          message: message,
          type: SnackbarType.error,
          actionLabel: context.l10n.retry,
          onActionPressed: onRetry,
        ),
      ),
    );
  }
}
