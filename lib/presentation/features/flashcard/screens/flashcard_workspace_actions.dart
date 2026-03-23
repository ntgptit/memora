import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/core/enums/dialog_type.dart';
import 'package:memora/domain/entities/flashcard.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/flashcard/providers/flashcard_provider.dart';
import 'package:memora/presentation/features/flashcard/providers/flashcard_state.dart';
import 'package:memora/presentation/features/flashcard/screens/flashcard_detail_screen.dart';
import 'package:memora/presentation/features/flashcard/screens/flashcard_form_screen.dart';
import 'package:memora/presentation/shared/composites/dialogs/app_confirm_dialog.dart';

Future<void> openFlashcardCreateSheet({
  required BuildContext context,
  required WidgetRef ref,
  required FlashcardRouteContext routeContext,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return FlashcardFormScreen(
        title: context.l10n.flashcardCreateAction,
        submitLabel: context.l10n.flashcardCreateAction,
        onSubmit: (frontText, backText, frontLangCode, backLangCode) {
          return ref
              .read(flashcardControllerProvider(routeContext).notifier)
              .createFlashcard(
                frontText: frontText,
                backText: backText,
                frontLangCode: frontLangCode,
                backLangCode: backLangCode,
              );
        },
      );
    },
  );
}

Future<void> openFlashcardEditSheet({
  required BuildContext context,
  required WidgetRef ref,
  required FlashcardRouteContext routeContext,
  required Flashcard flashcard,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return FlashcardFormScreen(
        title: context.l10n.flashcardEditAction,
        submitLabel: context.l10n.flashcardSaveAction,
        initialFrontText: flashcard.frontText,
        initialBackText: flashcard.backText,
        initialFrontLangCode: flashcard.frontLangCode,
        initialBackLangCode: flashcard.backLangCode,
        onSubmit: (frontText, backText, frontLangCode, backLangCode) {
          return ref
              .read(flashcardControllerProvider(routeContext).notifier)
              .updateFlashcard(
                flashcardId: flashcard.id,
                frontText: frontText,
                backText: backText,
                frontLangCode: frontLangCode,
                backLangCode: backLangCode,
              );
        },
      );
    },
  );
}

Future<void> openFlashcardDeleteDialog({
  required BuildContext context,
  required WidgetRef ref,
  required FlashcardRouteContext routeContext,
  required Flashcard flashcard,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AppConfirmDialog(
      title: context.l10n.flashcardDeleteDialogTitle(flashcard.frontText),
      type: DialogType.warning,
      isDestructive: true,
      confirmLabel: context.l10n.flashcardDeleteAction,
      cancelLabel: context.l10n.flashcardCancelAction,
      content: Text(context.l10n.flashcardDeleteDialogMessage),
      onConfirm: () => context.pop(true),
      onCancel: () => context.pop(false),
    ),
  );

  if (confirmed != true) {
    return;
  }

  await ref
      .read(flashcardControllerProvider(routeContext).notifier)
      .deleteFlashcard(flashcard.id);
}

Future<void> openFlashcardDetailSheet({
  required BuildContext context,
  required Flashcard flashcard,
  required VoidCallback onEdit,
  required VoidCallback onDelete,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return FlashcardDetailScreen(
        flashcard: flashcard,
        onEdit: onEdit,
        onDelete: onDelete,
      );
    },
  );
}
