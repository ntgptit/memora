package com.memora.app.service;

import com.memora.app.dto.CreateFlashcardRequest;
import com.memora.app.dto.FlashcardDto;
import com.memora.app.dto.FlashcardPageResponse;
import com.memora.app.dto.UpdateFlashcardRequest;

public interface FlashcardService {

    FlashcardDto createFlashcard(Long deckId, CreateFlashcardRequest request);

    FlashcardPageResponse getFlashcards(
        Long deckId,
        String searchQuery,
        String sortBy,
        String sortType,
        Integer page,
        Integer size
    );

    FlashcardDto updateFlashcard(Long deckId, Long flashcardId, UpdateFlashcardRequest request);

    void deleteFlashcard(Long deckId, Long flashcardId);
}
