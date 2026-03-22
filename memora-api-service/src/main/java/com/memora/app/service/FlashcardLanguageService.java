package com.memora.app.service;

import java.util.List;

import com.memora.app.dto.CreateFlashcardLanguageRequest;
import com.memora.app.dto.FlashcardLanguageDto;
import com.memora.app.dto.UpdateFlashcardLanguageRequest;

public interface FlashcardLanguageService {

    FlashcardLanguageDto createFlashcardLanguage(CreateFlashcardLanguageRequest request);

    FlashcardLanguageDto getFlashcardLanguage(Long flashcardLanguageId);

    List<FlashcardLanguageDto> getFlashcardLanguages(Long flashcardId);

    FlashcardLanguageDto updateFlashcardLanguage(Long flashcardLanguageId, UpdateFlashcardLanguageRequest request);

    void deleteFlashcardLanguage(Long flashcardLanguageId);
}
