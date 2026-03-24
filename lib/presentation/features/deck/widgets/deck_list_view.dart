import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/app/app_routes.dart';
import 'package:memora/core/enums/snackbar_type.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/domain/entities/deck.dart';
import 'package:memora/domain/entities/folder.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/deck/providers/deck_state.dart';
import 'package:memora/presentation/features/deck/widgets/deck_card.dart';
import 'package:memora/presentation/features/deck/widgets/deck_empty_view.dart';
import 'package:memora/presentation/features/deck/widgets/deck_filter_bar.dart';
import 'package:memora/presentation/features/deck/widgets/deck_header.dart';
import 'package:memora/presentation/shared/layouts/app_list_page_layout.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_fab_button.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_banner.dart';
import 'package:memora/presentation/shared/primitives/layout/app_spacing.dart';

class DeckListView extends StatelessWidget {
  const DeckListView({
    super.key,
    required this.state,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onSortByChanged,
    required this.onToggleSortDirection,
    required this.onOpenHome,
    required this.onOpenFolder,
    required this.onCreateDeck,
    required this.onEditDeck,
    required this.onDeleteDeck,
    required this.onRefresh,
    required this.folderId,
  });

  final DeckState state;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<DeckSortField> onSortByChanged;
  final VoidCallback onToggleSortDirection;
  final VoidCallback onOpenHome;
  final ValueChanged<Folder> onOpenFolder;
  final VoidCallback onCreateDeck;
  final ValueChanged<Deck> onEditDeck;
  final ValueChanged<Deck> onDeleteDeck;
  final Future<void> Function() onRefresh;
  final int folderId;

  @override
  Widget build(BuildContext context) {
    return AppListPageLayout(
      title: Text(state.currentFolder.name),
      subtitle: Text(
        state.currentFolder.hasDescription
            ? state.currentFolder.description
            : context.l10n.deckScreenSubtitle,
      ),
      breadcrumb: DeckHeader(
        currentFolder: state.currentFolder,
        breadcrumbFolders: state.breadcrumbFolders,
        onHomeTap: onOpenHome,
        onFolderTap: (folder) {
          if (folder.id == state.currentFolder.id) {
            return;
          }
          onOpenFolder(folder);
        },
      ),
      header: state.errorMessage == null
          ? null
          : AppBanner(
              title: context.l10n.deckErrorBannerTitle,
              message: state.errorMessage!,
              type: SnackbarType.error,
            ),
      filters: DeckFilterBar(
        searchController: searchController,
        focusNode: searchFocusNode,
        sortBy: state.sortBy,
        isAscending: state.sortDirection.isAscending,
        onSearchChanged: onSearchChanged,
        onClearSearch: onClearSearch,
        onSortByChanged: onSortByChanged,
        onToggleSortDirection: onToggleSortDirection,
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: state.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: context.component.emptyStateMinHeight,
                    child: DeckEmptyView(onCreatePressed: onCreateDeck),
                  ),
                ],
              )
            : ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.decks.length,
                separatorBuilder: (context, index) =>
                    const AppSpacing(size: AppSpacingSize.sm),
                itemBuilder: (context, index) {
                  final deck = state.decks[index];
                  return DeckCard(
                    deck: deck,
                    onTap: () => context.go(
                      AppRoutes.deckDetail(folderId: folderId, deckId: deck.id),
                    ),
                    onEdit: () => onEditDeck(deck),
                    onDelete: () => onDeleteDeck(deck),
                  );
                },
              ),
      ),
      floatingActionButton: AppFabButton(
        icon: const Icon(Icons.add_card_rounded),
        label: context.l10n.deckCreateAction,
        tooltip: context.l10n.deckCreateAction,
        heroTag: 'deck-fab-$folderId',
        onPressed: onCreateDeck,
      ),
    );
  }
}
