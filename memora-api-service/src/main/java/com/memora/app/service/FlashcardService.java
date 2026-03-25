package com.memora.app.service;

import com.memora.app.dto.request.flashcard.CreateFlashcardRequest;
import com.memora.app.dto.response.flashcard.FlashcardResponse;
import com.memora.app.dto.response.flashcard.FlashcardPageResponse;
import com.memora.app.dto.request.flashcard.UpdateFlashcardRequest;

public interface FlashcardService {

    FlashcardResponse createFlashcard(Long deckId, CreateFlashcardRequest request);

    FlashcardPageResponse getFlashcards(
        Long deckId,
        String searchQuery,
        String sortBy,
        String sortType,
        Integer page,
        Integer size
    );

    FlashcardResponse updateFlashcard(Long deckId, Long flashcardId, UpdateFlashcardRequest request);

    void deleteFlashcard(Long deckId, Long flashcardId);
}



