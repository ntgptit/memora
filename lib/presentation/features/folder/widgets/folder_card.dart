import 'package:flutter/material.dart';
import 'package:memora/domain/entities/folder.dart';
import 'package:memora/presentation/features/folder/widgets/folder_list_item.dart';

class FolderCard extends StatelessWidget {
  const FolderCard({
    super.key,
    required this.folder,
    this.onTap,
    this.onRename,
    this.onEdit,
    this.onDelete,
  });

  final Folder folder;
  final VoidCallback? onTap;
  final VoidCallback? onRename;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return FolderListItem(
      folder: folder,
      onTap: onTap,
      onRename: onRename,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }
}
