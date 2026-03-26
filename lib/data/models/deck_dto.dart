import 'package:json_annotation/json_annotation.dart';
import 'package:memora/data/models/api_audit_dto.dart';

part 'deck_dto.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class DeckDto {
  const DeckDto({
    required this.id,
    required this.folderId,
    required this.name,
    required this.flashcardCount,
    required this.audit,
    this.description,
  });

  final int id;
  final int folderId;
  final String name;
  final String? description;
  final int flashcardCount;
  final ApiAuditDto audit;

  factory DeckDto.fromJson(Map<String, dynamic> json) =>
      _$DeckDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeckDtoToJson(this);
}
