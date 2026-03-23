import 'dart:async';

import 'package:memora/core/config/app_limits.dart';
import 'package:memora/core/di/repository_providers.dart';
import 'package:memora/core/errors/error_mapper.dart';
import 'package:memora/domain/repositories/deck_repository.dart';
import 'package:memora/domain/repositories/flashcard_repository.dart';
import 'package:memora/presentation/features/flashcard/providers/flashcard_filter_provider.dart';
import 'package:memora/presentation/features/flashcard/providers/flashcard_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flashcard_provider.g.dart';

@Riverpod(keepAlive: false)
class FlashcardController extends _$FlashcardController {
  FlashcardRepository get _flashcardRepository =>
      ref.read(flashcardRepositoryProvider);
  DeckRepository get _deckRepository => ref.read(deckRepositoryProvider);

  FlashcardRouteContext? _routeContext;

  @override
  FutureOr<FlashcardState> build(FlashcardRouteContext routeContext) async {
    _routeContext = routeContext;
    final filter = ref.watch(flashcardFilterControllerProvider);
    return _loadState(routeContext: routeContext, filter: filter);
  }

  Future<void> refresh() async {
    await _reload();
  }

  Future<void> loadMore() async {
    final currentState = state.asData?.value;
    final routeContext = _routeContext;
    if (currentState == null || routeContext == null) {
      return;
    }
    if (currentState.isLoadingMore || !currentState.hasNext) {
      return;
    }

    final filter = ref.read(flashcardFilterControllerProvider);
    state = AsyncData(currentState.copyWith(isLoadingMore: true));

    try {
      final page = await _flashcardRepository.getFlashcards(
        deckId: routeContext.deckId,
        searchQuery: filter.searchQuery.isEmpty ? null : filter.searchQuery,
        sortBy: filter.sortBy,
        sortDirection: filter.sortDirection,
        page: currentState.page + 1,
        size: currentState.size,
      );

      state = AsyncData(
        currentState.copyWith(
          flashcards: [...currentState.flashcards, ...page.items],
          page: page.page,
          size: page.size,
          totalElements: page.totalElements,
          totalPages: page.totalPages,
          hasNext: page.hasNext,
          hasPrevious: page.hasPrevious,
          isLoadingMore: false,
        ),
      );
    } catch (error, stackTrace) {
      final failure = ErrorMapper.map(error, stackTrace: stackTrace);
      state = AsyncData(
        currentState.copyWith(
          isLoadingMore: false,
          errorMessage: failure.message,
        ),
      );
    }
  }

  Future<void> createFlashcard({
    required String frontText,
    required String backText,
    String? frontLangCode,
    String? backLangCode,
  }) async {
    final routeContext = _requireRouteContext();
    await _runMutation(() async {
      await _flashcardRepository.createFlashcard(
        deckId: routeContext.deckId,
        frontText: frontText,
        backText: backText,
        frontLangCode: frontLangCode,
        backLangCode: backLangCode,
      );
    });
  }

  Future<void> updateFlashcard({
    required int flashcardId,
    required String frontText,
    required String backText,
    String? frontLangCode,
    String? backLangCode,
  }) async {
    final routeContext = _requireRouteContext();
    await _runMutation(() async {
      await _flashcardRepository.updateFlashcard(
        deckId: routeContext.deckId,
        flashcardId: flashcardId,
        frontText: frontText,
        backText: backText,
        frontLangCode: frontLangCode,
        backLangCode: backLangCode,
      );
    });
  }

  Future<void> deleteFlashcard(int flashcardId) async {
    final routeContext = _requireRouteContext();
    await _runMutation(() async {
      await _flashcardRepository.deleteFlashcard(
        deckId: routeContext.deckId,
        flashcardId: flashcardId,
      );
    });
  }

  FlashcardRouteContext _requireRouteContext() {
    final routeContext = _routeContext;
    if (routeContext == null) {
      throw StateError('FlashcardController routeContext is not initialized.');
    }
    return routeContext;
  }

  Future<FlashcardState> _loadState({
    required FlashcardRouteContext routeContext,
    required FlashcardFilterState filter,
    String? errorMessage,
  }) async {
    final currentDeck = await _deckRepository.getDeck(
      folderId: routeContext.folderId,
      deckId: routeContext.deckId,
    );
    final page = await _flashcardRepository.getFlashcards(
      deckId: routeContext.deckId,
      searchQuery: filter.searchQuery.isEmpty ? null : filter.searchQuery,
      sortBy: filter.sortBy,
      sortDirection: filter.sortDirection,
      page: 0,
      size: AppLimits.defaultPageSize,
    );

    return FlashcardState(
      currentDeck: currentDeck,
      flashcards: page.items,
      searchQuery: filter.searchQuery,
      sortBy: filter.sortBy,
      sortDirection: filter.sortDirection,
      page: page.page,
      size: page.size,
      totalElements: page.totalElements,
      totalPages: page.totalPages,
      hasNext: page.hasNext,
      hasPrevious: page.hasPrevious,
      isLoadingMore: false,
      errorMessage: errorMessage,
    );
  }

  Future<void> _reload({String? errorMessage}) async {
    final routeContext = _requireRouteContext();
    final filter = ref.read(flashcardFilterControllerProvider);
    state = const AsyncLoading<FlashcardState>();
    state = await AsyncValue.guard(
      () => _loadState(
        routeContext: routeContext,
        filter: filter,
        errorMessage: errorMessage,
      ),
    );
  }

  Future<void> _runMutation(Future<void> Function() action) async {
    try {
      await action();
      await _reload();
    } catch (error, stackTrace) {
      final failure = ErrorMapper.map(error, stackTrace: stackTrace);
      await _reload(errorMessage: failure.message);
    }
  }
}
