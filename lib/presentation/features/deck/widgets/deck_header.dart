import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/domain/entities/folder.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/folder/widgets/folder_breadcrumb.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_title_text.dart';

class DeckHeader extends StatelessWidget {
  const DeckHeader({
    super.key,
    required this.currentFolder,
    required this.breadcrumbFolders,
    this.onHomeTap,
    this.onFolderTap,
  });

  final Folder currentFolder;
  final List<Folder> breadcrumbFolders;
  final VoidCallback? onHomeTap;
  final ValueChanged<Folder>? onFolderTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FolderBreadcrumb(
          folders: breadcrumbFolders,
          onHomeTap: onHomeTap,
          onFolderTap: onFolderTap,
        ),
        SizedBox(height: context.spacing.sm),
        AppTitleText(text: currentFolder.name),
        SizedBox(height: context.spacing.xxs),
        AppBodyText(
          text: currentFolder.hasDescription
              ? currentFolder.description
              : context.l10n.deckScreenSubtitle,
        ),
      ],
    );
  }
}
