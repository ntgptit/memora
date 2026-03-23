import 'package:flutter/material.dart';
import 'package:memora/domain/entities/folder.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/composites/navigation/app_breadcrumb.dart';

class FolderBreadcrumb extends StatelessWidget {
  const FolderBreadcrumb({
    super.key,
    required this.folders,
    this.onHomeTap,
    this.onFolderTap,
  });

  final List<Folder> folders;
  final VoidCallback? onHomeTap;
  final ValueChanged<Folder>? onFolderTap;

  @override
  Widget build(BuildContext context) {
    final items = <AppBreadcrumbItem>[
      AppBreadcrumbItem(
        label: context.l10n.folderRootBreadcrumbLabel,
        onTap: folders.isEmpty ? null : onHomeTap,
        isCurrent: folders.isEmpty,
      ),
    ];

    for (var index = 0; index < folders.length; index++) {
      final folder = folders[index];
      items.add(
        AppBreadcrumbItem(
          label: folder.name,
          onTap: index == folders.length - 1 || onFolderTap == null
              ? null
              : () => onFolderTap!(folder),
          isCurrent: index == folders.length - 1,
        ),
      );
    }

    return AppBreadcrumb(items: items);
  }
}
