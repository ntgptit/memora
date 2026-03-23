import 'package:flutter/material.dart';
import 'package:memora/core/config/app_icons.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/composites/states/app_empty_state.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';

class FolderEmptyView extends StatelessWidget {
  const FolderEmptyView({
    super.key,
    required this.isRoot,
    this.onCreatePressed,
  });

  final bool isRoot;
  final VoidCallback? onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: isRoot
          ? context.l10n.folderRootEmptyTitle
          : context.l10n.folderLevelEmptyTitle,
      message: isRoot
          ? context.l10n.folderRootEmptyMessage
          : context.l10n.folderLevelEmptyMessage,
      icon: const Icon(AppIcons.folders, size: 48),
      actions: [
        if (onCreatePressed != null)
          AppPrimaryButton(
            text: context.l10n.folderCreateAction,
            onPressed: onCreatePressed,
          ),
      ],
    );
  }
}
