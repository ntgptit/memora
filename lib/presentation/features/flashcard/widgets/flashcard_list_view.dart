import 'package:flutter/material.dart';
import 'package:memora/core/enums/snackbar_type.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/domain/entities/flashcard.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/flashcard/providers/flashcard_state.dart';
import 'package:memora/presentation/features/flashcard/widgets/flashcard_empty_view.dart';
import 'package:memora/presentation/features/flashcard/widgets/flashcard_list_item.dart';
import 'package:memora/presentation/features/flashcard/widgets/flashcard_sort_label.dart';
import 'package:memora/presentation/features/flashcard/widgets/flashcard_workspace_header.dart';
import 'package:memora/presentation/shared/composites/forms/app_search_bar.dart';
import 'package:memora/presentation/shared/composites/forms/app_sort_bar.dart';
import 'package:memora/presentation/shared/layouts/app_list_page_layout.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_fab_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_icon_button.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_banner.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_circular_loader.dart';
import 'package:memora/presentation/shared/primitives/layout/app_spacing.dart';

class FlashcardListView extends StatelessWidget {
  const FlashcardListView({
    super.key,
    required this.state,
    required this.searchController,
    required this.searchFocusNode,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onSortByChanged,
    required this.onToggleSortDirection,
    required this.onOpenDecks,
    required this.onCreateFlashcard,
    required this.onEditFlashcard,
    required this.onDeleteFlashcard,
    required this.onOpenFlashcard,
  });

  final FlashcardState state;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<FlashcardSortField> onSortByChanged;
  final VoidCallback onToggleSortDirection;
  final VoidCallback onOpenDecks;
  final VoidCallback onCreateFlashcard;
  final ValueChanged<Flashcard> onEditFlashcard;
  final ValueChanged<Flashcard> onDeleteFlashcard;
  final ValueChanged<Flashcard> onOpenFlashcard;

  @override
  Widget build(BuildContext context) {
    return AppListPageLayout(
      title: Text(state.currentDeck.name),
      subtitle: Text(
        state.currentDeck.hasDescription
            ? state.currentDeck.description
            : context.l10n.flashcardScreenSubtitle,
      ),
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.errorMessage != null) ...[
            AppBanner(
              title: context.l10n.flashcardErrorBannerTitle,
              message: state.errorMessage!,
              type: SnackbarType.error,
            ),
            SizedBox(height: context.spacing.lg),
          ],
          FlashcardWorkspaceHeader(
            state: state,
            onOpenDecks: onOpenDecks,
            onCreateFlashcard: onCreateFlashcard,
          ),
        ],
      ),
      filters: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSearchBar(
            controller: searchController,
            focusNode: searchFocusNode,
            hintText: context.l10n.flashcardSearchHint,
            onChanged: onSearchChanged,
            onSubmitted: onSearchChanged,
            onClear: onClearSearch,
          ),
          const AppSpacing(size: AppSpacingSize.sm),
          AppSortBar(
            title: Text(context.l10n.flashcardSortTitle),
            directionToggle: AppIconButton(
              tooltip: context.l10n.flashcardSortDirectionTooltip,
              onPressed: onToggleSortDirection,
              icon: Icon(
                state.sortDirection.isAscending
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
              ),
            ),
            sortOptions: [
              for (final sortBy in FlashcardSortField.values)
                AppChip(
                  label: Text(flashcardSortLabel(context, sortBy)),
                  selected: sortBy == state.sortBy,
                  onSelected: (_) => onSortByChanged(sortBy),
                ),
            ],
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.axis == Axis.vertical &&
              notification.metrics.extentAfter < 240 &&
              state.canLoadMore) {
            onLoadMore();
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: state.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 320,
                      child: FlashcardEmptyView(
                        isSearching: state.searchQuery.isNotEmpty,
                        onCreatePressed: onCreateFlashcard,
                      ),
                    ),
                  ],
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount:
                      state.flashcards.length + (state.isLoadingMore ? 1 : 0),
                  separatorBuilder: (context, index) =>
                      const AppSpacing(size: AppSpacingSize.sm),
                  itemBuilder: (context, index) {
                    if (index >= state.flashcards.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: AppCircularLoader()),
                      );
                    }

                    final flashcard = state.flashcards[index];
                    return FlashcardListItem(
                      flashcard: flashcard,
                      onTap: () => onOpenFlashcard(flashcard),
                      onEdit: () => onEditFlashcard(flashcard),
                      onDelete: () => onDeleteFlashcard(flashcard),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: AppFabButton(
        icon: const Icon(Icons.add_rounded),
        label: context.l10n.flashcardCreateAction,
        tooltip: context.l10n.flashcardCreateAction,
        heroTag: 'flashcard-fab-${state.currentDeck.id}',
        onPressed: onCreateFlashcard,
      ),
    );
  }
}
