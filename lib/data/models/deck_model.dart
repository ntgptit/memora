import 'package:json_annotation/json_annotation.dart';
import 'package:memora/data/models/audit_model.dart';

part 'deck_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DeckModel {
  const DeckModel({
    required this.id,
    required this.folderId,
    required this.name,
    required this.flashcardCount,
    this.description = '',
    this.audit,
  });

  final int id;
  final int folderId;
  final String name;
  @JsonKey(defaultValue: '')
  final String description;
  final int flashcardCount;
  final AuditModel? audit;

  factory DeckModel.fromJson(Map<String, dynamic> json) =>
      _$DeckModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeckModelToJson(this);
}
