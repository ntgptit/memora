import 'package:json_annotation/json_annotation.dart';

part 'flashcard_requests.g.dart';

@JsonSerializable(includeIfNull: false)
class CreateFlashcardRequest {
  const CreateFlashcardRequest({
    required this.frontText,
    required this.backText,
    this.frontLangCode,
    this.backLangCode,
  });

  @JsonKey(name: 'term')
  final String frontText;
  @JsonKey(name: 'meaning')
  final String backText;
  final String? frontLangCode;
  final String? backLangCode;

  factory CreateFlashcardRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateFlashcardRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFlashcardRequestToJson(this);
}

@JsonSerializable(includeIfNull: false)
class UpdateFlashcardRequest {
  const UpdateFlashcardRequest({
    required this.frontText,
    required this.backText,
    this.frontLangCode,
    this.backLangCode,
  });

  @JsonKey(name: 'term')
  final String frontText;
  @JsonKey(name: 'meaning')
  final String backText;
  final String? frontLangCode;
  final String? backLangCode;

  factory UpdateFlashcardRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateFlashcardRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateFlashcardRequestToJson(this);
}
