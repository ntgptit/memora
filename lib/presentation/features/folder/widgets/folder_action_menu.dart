import 'package:flutter/material.dart';
import 'package:memora/l10n/l10n.dart';

enum _FolderAction { rename, edit, delete }

class FolderActionMenu extends StatelessWidget {
  const FolderActionMenu({
    super.key,
    required this.onRename,
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onRename;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_FolderAction>(
      tooltip: context.l10n.folderActionsTooltip,
      onSelected: (action) {
        if (action == _FolderAction.rename) {
          onRename();
          return;
        }
        if (action == _FolderAction.edit) {
          onEdit();
          return;
        }
        onDelete();
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _FolderAction.rename,
          child: Text(context.l10n.folderRenameAction),
        ),
        PopupMenuItem(
          value: _FolderAction.edit,
          child: Text(context.l10n.folderEditAction),
        ),
        PopupMenuItem(
          value: _FolderAction.delete,
          child: Text(context.l10n.folderDeleteAction),
        ),
      ],
    );
  }
}
