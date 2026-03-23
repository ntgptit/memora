import 'package:memora/data/models/deck_model.dart';
import 'package:memora/domain/entities/deck.dart';

abstract final class DeckMapper {
  static Deck toEntity(DeckModel model) {
    return Deck(
      id: model.id,
      folderId: model.folderId,
      name: model.name,
      description: model.description,
      flashcardCount: model.flashcardCount,
    );
  }
}
