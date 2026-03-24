import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/app/app_routes.dart';
import 'package:memora/core/config/app_icons.dart';
import 'package:memora/core/enums/dialog_type.dart';
import 'package:memora/core/enums/snackbar_type.dart';
import 'package:memora/domain/entities/deck.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/deck/providers/deck_filter_provider.dart';
import 'package:memora/presentation/features/deck/providers/deck_provider.dart';
import 'package:memora/presentation/features/deck/screens/deck_form_screen.dart';
import 'package:memora/presentation/features/deck/widgets/deck_list_view.dart';
import 'package:memora/presentation/shared/composites/dialogs/app_confirm_dialog.dart';
import 'package:memora/presentation/shared/composites/states/app_empty_state.dart';
import 'package:memora/presentation/shared/layouts/app_list_page_layout.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_banner.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_circular_loader.dart';

class DeckListScreen extends ConsumerStatefulWidget {
  const DeckListScreen({super.key, this.folderId});

  final int? folderId;

  @override
  ConsumerState<DeckListScreen> createState() => _DeckListScreenState();
}

class _DeckListScreenState extends ConsumerState<DeckListScreen> {
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
    if (widget.folderId == null) {
      return _buildShellEntry(context);
    }

    final asyncState = ref.watch(deckControllerProvider(widget.folderId!));

    return asyncState.when(
      loading: () => _buildLoading(context),
      error: (error, stackTrace) => _buildError(context, error.toString()),
      data: (state) => DeckListView(
        state: state,
        searchController: _searchController,
        searchFocusNode: _searchFocusNode,
        onRefresh: ref
            .read(deckControllerProvider(widget.folderId!).notifier)
            .refresh,
        onSearchChanged: ref
            .read(deckFilterControllerProvider.notifier)
            .setSearchQuery,
        onClearSearch: () {
          _searchController.clear();
          ref.read(deckFilterControllerProvider.notifier).clearSearch();
        },
        onSortByChanged: ref
            .read(deckFilterControllerProvider.notifier)
            .setSortBy,
        onToggleSortDirection: ref
            .read(deckFilterControllerProvider.notifier)
            .toggleSortDirection,
        onOpenHome: () => context.go(AppRoutes.folders),
        onOpenFolder: (folder) => context.go(AppRoutes.folderDetail(folder.id)),
        onCreateDeck: _openCreateDeckSheet,
        onEditDeck: _openEditDeckSheet,
        onDeleteDeck: _openDeleteDeckDialog,
        folderId: widget.folderId!,
      ),
    );
  }

  Widget _buildShellEntry(BuildContext context) {
    return AppListPageLayout(
      title: Text(context.l10n.decksTitle),
      subtitle: Text(context.l10n.deckShellSubtitle),
      body: AppEmptyState(
        title: context.l10n.deckShellTitle,
        message: context.l10n.deckShellMessage,
        icon: const Icon(AppIcons.decks),
        actions: [
          AppPrimaryButton(
            text: context.l10n.deckShellBrowseFoldersAction,
            onPressed: () => context.go(AppRoutes.folders),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return AppListPageLayout(
      title: Text(context.l10n.decksTitle),
      subtitle: Text(context.l10n.deckScreenSubtitle),
      body: const Center(child: AppCircularLoader()),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return AppListPageLayout(
      title: Text(context.l10n.decksTitle),
      subtitle: Text(context.l10n.deckScreenSubtitle),
      body: Center(
        child: AppBanner(
          title: context.l10n.deckErrorBannerTitle,
          message: message,
          type: SnackbarType.error,
          actionLabel: context.l10n.retry,
          onActionPressed: () =>
              ref.refresh(deckControllerProvider(widget.folderId!)),
        ),
      ),
    );
  }

  Future<void> _openCreateDeckSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: DeckFormScreen(
            title: context.l10n.deckCreateAction,
            submitLabel: context.l10n.deckCreateAction,
            onSubmit: (name, description) {
              return ref
                  .read(deckControllerProvider(widget.folderId!).notifier)
                  .createDeck(name: name, description: description);
            },
          ),
        );
      },
    );
  }

  Future<void> _openEditDeckSheet(Deck deck) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: DeckFormScreen(
            title: context.l10n.deckEditAction,
            submitLabel: context.l10n.deckSaveAction,
            initialName: deck.name,
            initialDescription: deck.description,
            onSubmit: (name, description) {
              return ref
                  .read(deckControllerProvider(widget.folderId!).notifier)
                  .updateDeck(
                    deckId: deck.id,
                    name: name,
                    description: description,
                  );
            },
          ),
        );
      },
    );
  }

  Future<void> _openDeleteDeckDialog(Deck deck) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AppConfirmDialog(
        title: context.l10n.deckDeleteDialogTitle(deck.name),
        type: DialogType.warning,
        isDestructive: true,
        confirmLabel: context.l10n.deckDeleteAction,
        cancelLabel: context.l10n.deckCancelAction,
        content: Text(context.l10n.deckDeleteDialogMessage),
        onConfirm: () => context.pop(true),
        onCancel: () => context.pop(false),
      ),
    );

    if (confirmed != true) {
      return;
    }

    await ref
        .read(deckControllerProvider(widget.folderId!).notifier)
        .deleteDeck(deck.id);
  }
}
