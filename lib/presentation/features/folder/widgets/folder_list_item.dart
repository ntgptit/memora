import 'package:flutter/material.dart';
import 'package:memora/core/theme/tokens/tokens.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/domain/entities/folder.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/folder/widgets/folder_action_menu.dart';
import 'package:memora/presentation/shared/composites/lists/app_list_item.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';
import 'package:memora/presentation/shared/primitives/displays/app_counter_badge.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';

class FolderListItem extends StatelessWidget {
  const FolderListItem({
    super.key,
    required this.folder,
    this.onTap,
    this.onRename,
    required this.onEdit,
    required this.onDelete,
  });

  final Folder folder;
  final VoidCallback? onTap;
  final VoidCallback? onRename;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return AppListItem(
      onTap: onTap,
      leading: _FolderLeading(colorHex: folder.colorHex),
      title: Text(folder.name),
      subtitle: AppBodyText(
        text: folder.hasDescription
            ? folder.description
            : context.l10n.folderChildCountValue(folder.childFolderCount),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        isSecondary: true,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!folder.isLeaf)
            AppCounterBadge(
              count: folder.childFolderCount,
              child: const Icon(Icons.folder_rounded),
            )
          else
            AppChip(label: Text(context.l10n.folderLeafLabel)),
          SizedBox(width: context.spacing.xs),
          if (onRename != null && onEdit != null && onDelete != null)
            FolderActionMenu(
              onRename: onRename!,
              onEdit: onEdit!,
              onDelete: onDelete!,
            ),
        ],
      ),
    );
  }
}

class _FolderLeading extends StatelessWidget {
  const _FolderLeading({required this.colorHex});

  final String colorHex;

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(colorHex) ?? context.colorScheme.primary;
    return Container(
      width: context.component.listItemLeadingSize,
      height: context.component.listItemLeadingSize,
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppOpacityTokens.subtle),
        borderRadius: BorderRadius.circular(context.radius.md),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.folder_rounded, color: color),
    );
  }

  Color? _parseColor(String value) {
    final normalized = value.replaceAll('#', '');
    if (normalized.length != 6) {
      return null;
    }

    final parsed = int.tryParse(normalized, radix: 16);
    if (parsed == null) {
      return null;
    }

    return Color(0xFF000000 | parsed);
  }
}
