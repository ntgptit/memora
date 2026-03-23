import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/di/repository_providers.dart';
import 'package:memora/core/enums/sort_direction.dart';
import 'package:memora/core/theme/app_theme.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/domain/entities/deck.dart';
import 'package:memora/domain/entities/flashcard.dart';
import 'package:memora/domain/repositories/deck_repository.dart';
import 'package:memora/domain/repositories/flashcard_repository.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/flashcard/screens/flashcard_list_screen.dart';

void main() {
  testWidgets('Flashcard list screen renders deck context and actions', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        deckRepositoryProvider.overrideWithValue(
          _FakeDeckRepository(
            deck: const Deck(
              id: 10,
              folderId: 1,
              name: 'Sample deck',
              description: 'Study terms',
              flashcardCount: 1,
            ),
          ),
        ),
        flashcardRepositoryProvider.overrideWithValue(
          const _FakeFlashcardRepository(
            page: FlashcardPage(
              items: [
                Flashcard(
                  id: 1,
                  deckId: 10,
                  frontText: 'Front side',
                  backText: 'Back side',
                  frontLangCode: 'en',
                  backLangCode: 'vi',
                  pronunciation: null,
                  note: null,
                  isBookmarked: true,
                ),
              ],
              page: 0,
              size: 20,
              totalElements: 1,
              totalPages: 1,
              hasNext: false,
              hasPrevious: false,
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light(
            screenInfo: ScreenInfo.fromSize(const Size(390, 844)),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const FlashcardListScreen(folderId: 1, deckId: 10),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sample deck'), findsWidgets);
    expect(find.text('Study terms'), findsOneWidget);
    expect(find.text('Front side'), findsWidgets);
    expect(find.text('Create flashcard'), findsWidgets);
  });
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
  const _FakeFlashcardRepository({required this.page});

  final FlashcardPage page;

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
    return this.page;
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
