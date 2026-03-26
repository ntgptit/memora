import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/app/app_route_data.dart';
import 'package:memora/core/enums/dialog_type.dart';
import 'package:memora/core/enums/snackbar_type.dart';
import 'package:memora/domain/entities/folder.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/folder/providers/folder_filter_provider.dart';
import 'package:memora/presentation/features/folder/providers/folder_provider.dart';
import 'package:memora/presentation/features/folder/screens/folder_form_screen.dart';
import 'package:memora/presentation/features/folder/widgets/folder_list_view.dart';
import 'package:memora/presentation/shared/composites/dialogs/app_confirm_dialog.dart';
import 'package:memora/presentation/shared/layouts/app_list_page_layout.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_banner.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_circular_loader.dart';

class FolderListScreen extends ConsumerStatefulWidget {
  const FolderListScreen({super.key, this.folderId});

  final int? folderId;

  @override
  ConsumerState<FolderListScreen> createState() => _FolderListScreenState();
}

class _FolderListScreenState extends ConsumerState<FolderListScreen> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(folderControllerProvider(widget.folderId));

    return asyncState.when(
      loading: () => _buildLoading(context),
      error: (error, stackTrace) => _buildError(context, error.toString()),
      data: (state) => FolderListView(
        state: state,
        searchController: _searchController,
        searchFocusNode: _searchFocusNode,
        onRefresh: ref
            .read(folderControllerProvider(widget.folderId).notifier)
            .refresh,
        onSearchChanged: ref
            .read(folderFilterControllerProvider.notifier)
            .setSearchQuery,
        onClearSearch: () {
          _searchController.clear();
          ref.read(folderFilterControllerProvider.notifier).clearSearch();
        },
        onSortByChanged: ref
            .read(folderFilterControllerProvider.notifier)
            .setSortBy,
        onToggleSortDirection: ref
            .read(folderFilterControllerProvider.notifier)
            .toggleSortDirection,
        onOpenHome: () => const FoldersRouteData().go(context),
        onOpenFolder: _openFolder,
        onCreateFolder: _openCreateFolderSheet,
        onEditFolder: _openEditFolderSheet,
        onDeleteFolder: _openDeleteFolderDialog,
        onManageDecks: state.currentFolder?.isLeaf == true
            ? () => FolderDecksRouteData(
                folderId: state.currentFolder!.id,
              ).go(context)
            : null,
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return AppListPageLayout(
      title: Text(context.l10n.folderLibraryTitle),
      subtitle: Text(context.l10n.folderScreenSubtitle),
      body: const Center(child: AppCircularLoader()),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return AppListPageLayout(
      title: Text(context.l10n.folderLibraryTitle),
      subtitle: Text(context.l10n.folderScreenSubtitle),
      body: Center(
        child: AppBanner(
          title: context.l10n.folderErrorBannerTitle,
          message: message,
          type: SnackbarType.error,
          actionLabel: context.l10n.retry,
          onActionPressed: () =>
              ref.refresh(folderControllerProvider(widget.folderId)),
        ),
      ),
    );
  }

  void _openFolder(Folder folder) {
    if (folder.isLeaf) {
      FolderDecksRouteData(folderId: folder.id).go(context);
      return;
    }
    FolderDetailRouteData(folderId: folder.id).go(context);
  }

  Future<void> _openCreateFolderSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: FolderFormScreen(
            title: context.l10n.folderCreateAction,
            submitLabel: context.l10n.folderCreateAction,
            onSubmit: (name, description) {
              return ref
                  .read(folderControllerProvider(widget.folderId).notifier)
                  .createFolder(name: name, description: description);
            },
          ),
        );
      },
    );
  }

  Future<void> _openEditFolderSheet(Folder folder) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: FolderFormScreen(
            title: context.l10n.folderEditAction,
            submitLabel: context.l10n.folderSaveAction,
            initialName: folder.name,
            initialDescription: folder.description,
            onSubmit: (name, description) {
              return ref
                  .read(folderControllerProvider(widget.folderId).notifier)
                  .updateFolder(
                    targetFolderId: folder.id,
                    name: name,
                    description: description,
                  );
            },
          ),
        );
      },
    );
  }

  Future<void> _openDeleteFolderDialog(Folder folder) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AppConfirmDialog(
        title: context.l10n.folderDeleteDialogTitle(folder.name),
        type: DialogType.warning,
        isDestructive: true,
        confirmLabel: context.l10n.folderDeleteAction,
        cancelLabel: context.l10n.folderCancelAction,
        content: Text(context.l10n.folderDeleteDialogMessage),
        onConfirm: () => context.pop(true),
        onCancel: () => context.pop(false),
      ),
    );

    if (confirmed != true) {
      return;
    }

    await ref
        .read(folderControllerProvider(widget.folderId).notifier)
        .deleteFolder(folder.id);
  }
}
