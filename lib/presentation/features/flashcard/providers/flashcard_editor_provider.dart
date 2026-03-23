import 'package:flutter/foundation.dart';
import 'package:memora/domain/entities/flashcard.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flashcard_editor_provider.g.dart';

@immutable
class FlashcardEditorState {
  const FlashcardEditorState({
    required this.frontText,
    required this.backText,
    required this.frontLangCode,
    required this.backLangCode,
  });

  factory FlashcardEditorState.initial({Flashcard? flashcard}) {
    return FlashcardEditorState(
      frontText: flashcard?.frontText ?? '',
      backText: flashcard?.backText ?? '',
      frontLangCode: flashcard?.frontLangCode ?? '',
      backLangCode: flashcard?.backLangCode ?? '',
    );
  }

  final String frontText;
  final String backText;
  final String frontLangCode;
  final String backLangCode;

  FlashcardEditorState copyWith({
    String? frontText,
    String? backText,
    String? frontLangCode,
    String? backLangCode,
  }) {
    return FlashcardEditorState(
      frontText: frontText ?? this.frontText,
      backText: backText ?? this.backText,
      frontLangCode: frontLangCode ?? this.frontLangCode,
      backLangCode: backLangCode ?? this.backLangCode,
    );
  }
}

@Riverpod(keepAlive: false)
class FlashcardEditorController extends _$FlashcardEditorController {
  @override
  FlashcardEditorState build({Flashcard? flashcard}) {
    return FlashcardEditorState.initial(flashcard: flashcard);
  }

  void updateFrontText(String value) {
    state = state.copyWith(frontText: value);
  }

  void updateBackText(String value) {
    state = state.copyWith(backText: value);
  }

  void updateFrontLangCode(String value) {
    state = state.copyWith(frontLangCode: value);
  }

  void updateBackLangCode(String value) {
    state = state.copyWith(backLangCode: value);
  }
}
