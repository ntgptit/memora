import 'package:dio/dio.dart';
import 'package:memora/data/models/deck_requests.dart';
import 'package:memora/data/models/deck_model.dart';
import 'package:retrofit/retrofit.dart';

part 'deck_api.g.dart';

@RestApi()
abstract class DeckApi {
  factory DeckApi(Dio dio, {String? baseUrl}) = _DeckApi;

  @GET('/api/v1/folders/{folderId}/decks')
  Future<List<DeckModel>> getDecks(
    @Path('folderId') int folderId, {
    @Query('searchQuery') String? searchQuery,
    @Query('sortBy') String? sortBy,
    @Query('sortType') String? sortType,
    @Query('page') int? page,
    @Query('size') int? size,
  });

  @GET('/api/v1/folders/{folderId}/decks/{deckId}')
  Future<DeckModel> getDeck(
    @Path('folderId') int folderId,
    @Path('deckId') int deckId,
  );

  @POST('/api/v1/folders/{folderId}/decks')
  Future<DeckModel> createDeck(
    @Path('folderId') int folderId,
    @Body() CreateDeckRequest body,
  );

  @PUT('/api/v1/folders/{folderId}/decks/{deckId}')
  Future<DeckModel> updateDeck(
    @Path('folderId') int folderId,
    @Path('deckId') int deckId,
    @Body() UpdateDeckRequest body,
  );

  @DELETE('/api/v1/folders/{folderId}/decks/{deckId}')
  Future<void> deleteDeck(
    @Path('folderId') int folderId,
    @Path('deckId') int deckId,
  );
}
