package com.memora.app.service;

import java.util.List;

import com.memora.app.dto.CreateFlashcardRequest;
import com.memora.app.dto.FlashcardDto;
import com.memora.app.dto.UpdateFlashcardRequest;

public interface FlashcardService {

    FlashcardDto createFlashcard(CreateFlashcardRequest request);

    FlashcardDto getFlashcard(Long flashcardId);

    List<FlashcardDto> getFlashcards(Long deckId);

    FlashcardDto updateFlashcard(Long flashcardId, UpdateFlashcardRequest request);

    void deleteFlashcard(Long flashcardId);
}
