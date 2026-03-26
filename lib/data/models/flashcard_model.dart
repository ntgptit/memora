import 'package:json_annotation/json_annotation.dart';
import 'package:memora/data/models/audit_model.dart';

part 'flashcard_model.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class FlashcardModel {
  const FlashcardModel({
    required this.id,
    required this.deckId,
    required this.frontText,
    required this.backText,
    required this.isBookmarked,
    required this.audit,
    this.frontLangCode,
    this.backLangCode,
    this.pronunciation,
    this.note,
  });

  final int id;
  final int deckId;
  @JsonKey(name: 'term')
  final String frontText;
  @JsonKey(name: 'meaning')
  final String backText;
  final String? frontLangCode;
  final String? backLangCode;
  final String? pronunciation;
  final String? note;
  @JsonKey(name: 'bookmarked')
  final bool isBookmarked;
  final AuditModel? audit;

  factory FlashcardModel.fromJson(Map<String, dynamic> json) =>
      _$FlashcardModelFromJson(json);

  Map<String, dynamic> toJson() => _$FlashcardModelToJson(this);
}
