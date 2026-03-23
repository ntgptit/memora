import 'package:dio/dio.dart';
import 'package:memora/data/models/flashcard_model.dart';
import 'package:memora/data/models/flashcard_page_model.dart';
import 'package:retrofit/retrofit.dart';

part 'flashcard_api.g.dart';

@RestApi()
abstract class FlashcardApi {
  factory FlashcardApi(Dio dio, {String? baseUrl}) = _FlashcardApi;

  @GET('/api/v1/decks/{deckId}/flashcards')
  Future<FlashcardPageModel> getFlashcards(
    @Path('deckId') int deckId, {
    @Query('searchQuery') String? searchQuery,
    @Query('sortBy') String? sortBy,
    @Query('sortType') String? sortType,
    @Query('page') int? page,
    @Query('size') int? size,
  });

  @POST('/api/v1/decks/{deckId}/flashcards')
  Future<FlashcardModel> createFlashcard(
    @Path('deckId') int deckId,
    @Body() Map<String, Object?> body,
  );

  @PUT('/api/v1/decks/{deckId}/flashcards/{flashcardId}')
  Future<FlashcardModel> updateFlashcard(
    @Path('deckId') int deckId,
    @Path('flashcardId') int flashcardId,
    @Body() Map<String, Object?> body,
  );

  @DELETE('/api/v1/decks/{deckId}/flashcards/{flashcardId}')
  Future<void> deleteFlashcard(
    @Path('deckId') int deckId,
    @Path('flashcardId') int flashcardId,
  );
}
