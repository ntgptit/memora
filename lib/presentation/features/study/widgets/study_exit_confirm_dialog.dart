import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/core/enums/dialog_type.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/composites/dialogs/app_confirm_dialog.dart';

class StudyExitConfirmDialog extends StatelessWidget {
  const StudyExitConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppConfirmDialog(
      title: l10n.studyExitDialogTitle,
      type: DialogType.warning,
      confirmLabel: l10n.studyExitConfirmAction,
      cancelLabel: l10n.studyExitCancelAction,
      content: Text(l10n.studyExitDialogMessage),
      onConfirm: () => context.pop(true),
      onCancel: () => context.pop(false),
    );
  }
}
