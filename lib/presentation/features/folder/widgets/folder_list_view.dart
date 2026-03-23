import 'package:flutter/material.dart';
import 'package:memora/core/enums/snackbar_type.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/domain/entities/folder.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/folder/providers/folder_state.dart';
import 'package:memora/presentation/features/folder/widgets/folder_breadcrumb.dart';
import 'package:memora/presentation/features/folder/widgets/folder_empty_view.dart';
import 'package:memora/presentation/features/folder/widgets/folder_tree_view.dart';
import 'package:memora/presentation/shared/composites/forms/app_search_bar.dart';
import 'package:memora/presentation/shared/composites/forms/app_sort_bar.dart';
import 'package:memora/presentation/shared/layouts/app_list_page_layout.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_fab_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_icon_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/displays/app_card.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_banner.dart';
import 'package:memora/presentation/shared/primitives/layout/app_spacing.dart';

class FolderListView extends StatelessWidget {
  const FolderListView({
    super.key,
    required this.state,
    required this.searchController,
    required this.searchFocusNode,
    required this.onRefresh,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onSortByChanged,
    required this.onToggleSortDirection,
    required this.onOpenHome,
    required this.onOpenFolder,
    required this.onCreateFolder,
    required this.onEditFolder,
    required this.onDeleteFolder,
    required this.onManageDecks,
  });

  final FolderState state;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final Future<void> Function() onRefresh;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<FolderSortField> onSortByChanged;
  final VoidCallback onToggleSortDirection;
  final VoidCallback onOpenHome;
  final ValueChanged<Folder> onOpenFolder;
  final VoidCallback onCreateFolder;
  final ValueChanged<Folder> onEditFolder;
  final ValueChanged<Folder> onDeleteFolder;
  final VoidCallback? onManageDecks;

  @override
  Widget build(BuildContext context) {
    return AppListPageLayout(
      title: Text(state.currentFolder?.name ?? context.l10n.folderLibraryTitle),
      subtitle: Text(
        state.currentFolder?.hasDescription == true
            ? state.currentFolder!.description
            : context.l10n.folderScreenSubtitle,
      ),
      breadcrumb: state.breadcrumbFolders.isEmpty
          ? null
          : FolderBreadcrumb(
              folders: state.breadcrumbFolders,
              onHomeTap: onOpenHome,
              onFolderTap: onOpenFolder,
            ),
      header: state.errorMessage == null
          ? null
          : AppBanner(
              title: context.l10n.folderErrorBannerTitle,
              message: state.errorMessage!,
              type: SnackbarType.error,
            ),
      filters: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSearchBar(
            controller: searchController,
            focusNode: searchFocusNode,
            hintText: context.l10n.folderSearchHint,
            onChanged: onSearchChanged,
            onSubmitted: onSearchChanged,
            onClear: onClearSearch,
          ),
          const AppSpacing(size: AppSpacingSize.sm),
          AppSortBar(
            title: Text(context.l10n.folderSortTitle),
            directionToggle: AppIconButton(
              tooltip: context.l10n.folderSortDirectionTooltip,
              onPressed: onToggleSortDirection,
              icon: Icon(
                state.sortDirection.isAscending
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
              ),
            ),
            sortOptions: [
              for (final sortBy in FolderSortField.values)
                AppChip(
                  label: Text(_folderSortLabel(context, sortBy)),
                  selected: sortBy == state.sortBy,
                  onSelected: (_) => onSortByChanged(sortBy),
                ),
            ],
          ),
          if (state.currentFolder?.isLeaf == true) ...[
            const AppSpacing(size: AppSpacingSize.sm),
            AppCard(
              child: Padding(
                padding: EdgeInsets.all(context.spacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(context.l10n.folderLeafHint),
                    ),
                    AppPrimaryButton(
                      text: context.l10n.manageDecksLabel,
                      onPressed: onManageDecks,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: state.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 320,
                    child: FolderEmptyView(
                      isRoot: state.isRoot,
                      onCreatePressed: onCreateFolder,
                    ),
                  ),
                ],
              )
            : FolderTreeView(
                folders: state.folders,
                onFolderTap: onOpenFolder,
                onFolderEdit: onEditFolder,
                onFolderDelete: onDeleteFolder,
              ),
      ),
      floatingActionButton: AppFabButton(
        icon: Icon(
          state.currentFolder?.isLeaf == true
              ? Icons.layers_rounded
              : Icons.create_new_folder_rounded,
        ),
        label: state.currentFolder?.isLeaf == true
            ? context.l10n.manageDecksLabel
            : context.l10n.folderCreateAction,
        tooltip: state.currentFolder?.isLeaf == true
            ? context.l10n.manageDecksLabel
            : context.l10n.folderCreateAction,
        heroTag: 'folder-fab-${state.currentFolder?.id ?? "root"}',
        onPressed: state.currentFolder?.isLeaf == true
            ? onManageDecks
            : onCreateFolder,
      ),
    );
  }

  String _folderSortLabel(BuildContext context, FolderSortField sortBy) {
    switch (sortBy) {
      case FolderSortField.name:
        return context.l10n.folderSortByName;
      case FolderSortField.createdAt:
        return context.l10n.folderSortByCreatedAt;
      case FolderSortField.updatedAt:
        return context.l10n.folderSortByUpdatedAt;
    }
  }
}
