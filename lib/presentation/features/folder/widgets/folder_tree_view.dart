import 'package:flutter/material.dart';
import 'package:memora/domain/entities/folder.dart';
import 'package:memora/presentation/features/folder/widgets/folder_card.dart';
import 'package:memora/presentation/shared/primitives/layout/app_spacing.dart';

class FolderTreeView extends StatelessWidget {
  const FolderTreeView({
    super.key,
    required this.folders,
    required this.onFolderTap,
    required this.onFolderEdit,
    required this.onFolderDelete,
  });

  final List<Folder> folders;
  final ValueChanged<Folder> onFolderTap;
  final ValueChanged<Folder> onFolderEdit;
  final ValueChanged<Folder> onFolderDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: folders.length,
      separatorBuilder: (context, index) =>
          const AppSpacing(size: AppSpacingSize.sm),
      itemBuilder: (context, index) {
        final folder = folders[index];
        return FolderCard(
          folder: folder,
          onTap: () => onFolderTap(folder),
          onEdit: () => onFolderEdit(folder),
          onDelete: () => onFolderDelete(folder),
        );
      },
    );
  }
}
