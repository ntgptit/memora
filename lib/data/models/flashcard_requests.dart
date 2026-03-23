import 'package:flutter/foundation.dart';

@immutable
class CreateFlashcardRequest {
  const CreateFlashcardRequest({
    required this.frontText,
    required this.backText,
    this.frontLangCode,
    this.backLangCode,
  });

  final String frontText;
  final String backText;
  final String? frontLangCode;
  final String? backLangCode;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'frontText': frontText,
      'backText': backText,
      'frontLangCode': frontLangCode,
      'backLangCode': backLangCode,
    };
  }
}

@immutable
class UpdateFlashcardRequest {
  const UpdateFlashcardRequest({
    required this.frontText,
    required this.backText,
    this.frontLangCode,
    this.backLangCode,
  });

  final String frontText;
  final String backText;
  final String? frontLangCode;
  final String? backLangCode;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'frontText': frontText,
      'backText': backText,
      'frontLangCode': frontLangCode,
      'backLangCode': backLangCode,
    };
  }
}
