package com.memora.app.service;

import java.util.List;

import com.memora.app.dto.request.flashcard_language.CreateFlashcardLanguageRequest;
import com.memora.app.dto.response.flashcard_language.FlashcardLanguageResponse;
import com.memora.app.dto.request.flashcard_language.UpdateFlashcardLanguageRequest;

public interface FlashcardLanguageService {

    FlashcardLanguageResponse createFlashcardLanguage(CreateFlashcardLanguageRequest request);

    FlashcardLanguageResponse getFlashcardLanguage(Long flashcardLanguageId);

    List<FlashcardLanguageResponse> getFlashcardLanguages(Long flashcardId);

    FlashcardLanguageResponse updateFlashcardLanguage(Long flashcardLanguageId, UpdateFlashcardLanguageRequest request);

    void deleteFlashcardLanguage(Long flashcardLanguageId);
}



