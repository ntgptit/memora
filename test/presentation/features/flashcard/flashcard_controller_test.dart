import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/di/repository_providers.dart';
import 'package:memora/core/enums/sort_direction.dart';
import 'package:memora/domain/entities/deck.dart';
import 'package:memora/domain/entities/flashcard.dart';
import 'package:memora/domain/repositories/deck_repository.dart';
import 'package:memora/domain/repositories/flashcard_repository.dart';
import 'package:memora/presentation/features/flashcard/providers/flashcard_provider.dart';
import 'package:memora/presentation/features/flashcard/providers/flashcard_state.dart';

void main() {
  test(
    'Flashcard controller loads initial page and appends next page',
    () async {
      final deckRepository = _FakeDeckRepository(
        deck: const Deck(
          id: 10,
          folderId: 1,
          name: 'Sample deck',
          description: 'Deck description',
          flashcardCount: 2,
        ),
      );
      final flashcardRepository = _FakeFlashcardRepository(
        pages: {
          0: const FlashcardPage(
            items: [
              Flashcard(
                id: 1,
                deckId: 10,
                frontText: 'Front 1',
                backText: 'Back 1',
                frontLangCode: null,
                backLangCode: null,
                pronunciation: null,
                note: null,
                isBookmarked: false,
              ),
            ],
            page: 0,
            size: 20,
            totalElements: 2,
            totalPages: 2,
            hasNext: true,
            hasPrevious: false,
          ),
          1: const FlashcardPage(
            items: [
              Flashcard(
                id: 2,
                deckId: 10,
                frontText: 'Front 2',
                backText: 'Back 2',
                frontLangCode: null,
                backLangCode: null,
                pronunciation: null,
                note: null,
                isBookmarked: true,
              ),
            ],
            page: 1,
            size: 20,
            totalElements: 2,
            totalPages: 2,
            hasNext: false,
            hasPrevious: true,
          ),
        },
      );

      final container = ProviderContainer(
        overrides: [
          deckRepositoryProvider.overrideWithValue(deckRepository),
          flashcardRepositoryProvider.overrideWithValue(flashcardRepository),
        ],
      );
      addTearDown(container.dispose);

      const routeContext = FlashcardRouteContext(folderId: 1, deckId: 10);
      final initialState = await container.read(
        flashcardControllerProvider(routeContext).future,
      );

      expect(initialState.currentDeck.name, 'Sample deck');
      expect(initialState.flashcards, hasLength(1));
      expect(initialState.hasNext, isTrue);

      await container
          .read(flashcardControllerProvider(routeContext).notifier)
          .loadMore();

      final loadedState = container
          .read(flashcardControllerProvider(routeContext))
          .value!;
      expect(loadedState.flashcards, hasLength(2));
      expect(loadedState.flashcards.last.frontText, 'Front 2');
      expect(loadedState.hasNext, isFalse);
    },
  );
}

class _FakeDeckRepository implements DeckRepository {
  const _FakeDeckRepository({required this.deck});

  final Deck deck;

  @override
  Future<Deck> createDeck({
    required int folderId,
    required String name,
    String? description,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteDeck({required int folderId, required int deckId}) {
    throw UnimplementedError();
  }

  @override
  Future<Deck> getDeck({required int folderId, required int deckId}) async {
    return deck;
  }

  @override
  Future<List<Deck>> getDecks({
    required int folderId,
    String? searchQuery,
    DeckSortField sortBy = DeckSortField.name,
    SortDirection sortDirection = SortDirection.asc,
    int page = 0,
    int size = 20,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Deck> updateDeck({
    required int folderId,
    required int deckId,
    required String name,
    String? description,
  }) {
    throw UnimplementedError();
  }
}

class _FakeFlashcardRepository implements FlashcardRepository {
  const _FakeFlashcardRepository({required this.pages});

  final Map<int, FlashcardPage> pages;

  @override
  Future<Flashcard> createFlashcard({
    required int deckId,
    required String frontText,
    required String backText,
    String? frontLangCode,
    String? backLangCode,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteFlashcard({
    required int deckId,
    required int flashcardId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<FlashcardPage> getFlashcards({
    required int deckId,
    String? searchQuery,
    FlashcardSortField sortBy = FlashcardSortField.updatedAt,
    SortDirection sortDirection = SortDirection.desc,
    int page = 0,
    int size = 20,
  }) async {
    return pages[page]!;
  }

  @override
  Future<Flashcard> updateFlashcard({
    required int deckId,
    required int flashcardId,
    required String frontText,
    required String backText,
    String? frontLangCode,
    String? backLangCode,
  }) {
    throw UnimplementedError();
  }
}
