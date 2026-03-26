import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/app/app_route_data.dart';
import 'package:memora/presentation/features/flashcard/providers/flashcard_filter_provider.dart';
import 'package:memora/presentation/features/flashcard/providers/flashcard_provider.dart';
import 'package:memora/presentation/features/flashcard/providers/flashcard_state.dart';
import 'package:memora/presentation/features/flashcard/widgets/flashcard_error_view.dart';
import 'package:memora/presentation/features/flashcard/widgets/flashcard_list_view.dart';
import 'package:memora/presentation/features/flashcard/widgets/flashcard_loading_view.dart';
import 'package:memora/presentation/features/flashcard/screens/flashcard_workspace_actions.dart';

class FlashcardListScreen extends ConsumerStatefulWidget {
  const FlashcardListScreen({
    super.key,
    required this.folderId,
    required this.deckId,
  });

  final int folderId;
  final int deckId;

  @override
  ConsumerState<FlashcardListScreen> createState() =>
      _FlashcardListScreenState();
}

class _FlashcardListScreenState extends ConsumerState<FlashcardListScreen> {
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
    final asyncState = ref.watch(flashcardControllerProvider(_routeContext));

    return asyncState.when(
      loading: () => const FlashcardLoadingView(),
      error: (error, stackTrace) => FlashcardErrorView(
        message: error.toString(),
        onRetry: () => ref.refresh(flashcardControllerProvider(_routeContext)),
      ),
      data: (state) => FlashcardListView(
        state: state,
        searchController: _searchController,
        searchFocusNode: _searchFocusNode,
        onRefresh: ref
            .read(flashcardControllerProvider(_routeContext).notifier)
            .refresh,
        onLoadMore: ref
            .read(flashcardControllerProvider(_routeContext).notifier)
            .loadMore,
        onSearchChanged: ref
            .read(flashcardFilterControllerProvider.notifier)
            .setSearchQuery,
        onClearSearch: () {
          _searchController.clear();
          ref.read(flashcardFilterControllerProvider.notifier).clearSearch();
        },
        onSortByChanged: ref
            .read(flashcardFilterControllerProvider.notifier)
            .setSortBy,
        onToggleSortDirection: ref
            .read(flashcardFilterControllerProvider.notifier)
            .toggleSortDirection,
        onOpenDecks: () =>
            FolderDecksRouteData(folderId: widget.folderId).go(context),
        onCreateFlashcard: () => openFlashcardCreateSheet(
          context: context,
          ref: ref,
          routeContext: _routeContext,
        ),
        onEditFlashcard: (flashcard) => openFlashcardEditSheet(
          context: context,
          ref: ref,
          routeContext: _routeContext,
          flashcard: flashcard,
        ),
        onDeleteFlashcard: (flashcard) => openFlashcardDeleteDialog(
          context: context,
          ref: ref,
          routeContext: _routeContext,
          flashcard: flashcard,
        ),
        onOpenFlashcard: (flashcard) => openFlashcardDetailSheet(
          context: context,
          flashcard: flashcard,
          onEdit: () {
            context.pop();
            openFlashcardEditSheet(
              context: context,
              ref: ref,
              routeContext: _routeContext,
              flashcard: flashcard,
            );
          },
          onDelete: () {
            context.pop();
            openFlashcardDeleteDialog(
              context: context,
              ref: ref,
              routeContext: _routeContext,
              flashcard: flashcard,
            );
          },
        ),
      ),
    );
  }

  FlashcardRouteContext get _routeContext =>
      FlashcardRouteContext(folderId: widget.folderId, deckId: widget.deckId);
}
