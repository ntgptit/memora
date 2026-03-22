package com.memora.app.service.impl;

import java.time.OffsetDateTime;
import java.util.List;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.CreateFlashcardRequest;
import com.memora.app.dto.FlashcardDto;
import com.memora.app.dto.UpdateFlashcardRequest;
import com.memora.app.entity.DeckEntity;
import com.memora.app.entity.FlashcardEntity;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.mapper.FlashcardMapper;
import com.memora.app.repository.DeckRepository;
import com.memora.app.repository.FlashcardLanguageRepository;
import com.memora.app.repository.FlashcardRepository;
import com.memora.app.service.FlashcardService;
import com.memora.app.util.ServiceValidationUtils;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FlashcardServiceImpl implements FlashcardService {

    private final DeckRepository deckRepository;
    private final FlashcardLanguageRepository flashcardLanguageRepository;
    private final FlashcardRepository flashcardRepository;

    @Override
    @Transactional
    public FlashcardDto createFlashcard(final CreateFlashcardRequest request) {
        final DeckEntity deck = getActiveDeck(request.deckId());

        final FlashcardEntity entity = new FlashcardEntity();
        entity.setDeckId(deck.getId());
        entity.setTerm(ServiceValidationUtils.normalizeRequiredText(request.term(), ApiMessageKey.TERM_REQUIRED));
        entity.setMeaning(ServiceValidationUtils.normalizeRequiredText(request.meaning(), ApiMessageKey.MEANING_REQUIRED));
        entity.setNote(ServiceValidationUtils.normalizeOptionalText(request.note()));
        entity.setBookmarked(request.bookmarked());
        // Return the persisted flashcard.
        return FlashcardMapper.toDto(flashcardRepository.save(entity));
    }

    @Override
    @Transactional(readOnly = true)
    public FlashcardDto getFlashcard(final Long flashcardId) {
        // Return the requested active flashcard.
        return FlashcardMapper.toDto(getActiveFlashcard(flashcardId));
    }

    @Override
    @Transactional(readOnly = true)
    public List<FlashcardDto> getFlashcards(final Long deckId) {
        // Narrow the query when the caller requests flashcards for one deck.
        if (deckId != null) {
            // Return active flashcards for the requested deck.
            return flashcardRepository.findAllByDeckIdAndDeletedAtIsNullOrderByIdAsc(
                    ServiceValidationUtils.requirePositiveId(deckId, ApiMessageKey.DECK_ID_POSITIVE)
                )
                // Convert persisted flashcard rows into DTOs for the API layer.
                .stream()
                .map(FlashcardMapper::toDto)
                .toList();
        }

        // Return every active flashcard when no deck filter is provided.
        return flashcardRepository.findAllByDeletedAtIsNullOrderByIdAsc()
            // Convert persisted flashcard rows into DTOs for the API layer.
            .stream()
            .map(FlashcardMapper::toDto)
            .toList();
    }

    @Override
    @Transactional
    public FlashcardDto updateFlashcard(final Long flashcardId, final UpdateFlashcardRequest request) {
        final FlashcardEntity entity = getActiveFlashcard(flashcardId);
        final DeckEntity deck = getActiveDeck(request.deckId());

        entity.setDeckId(deck.getId());
        entity.setTerm(ServiceValidationUtils.normalizeRequiredText(request.term(), ApiMessageKey.TERM_REQUIRED));
        entity.setMeaning(ServiceValidationUtils.normalizeRequiredText(request.meaning(), ApiMessageKey.MEANING_REQUIRED));
        entity.setNote(ServiceValidationUtils.normalizeOptionalText(request.note()));
        entity.setBookmarked(request.bookmarked());
        // Return the updated flashcard snapshot.
        return FlashcardMapper.toDto(flashcardRepository.save(entity));
    }

    @Override
    @Transactional
    public void deleteFlashcard(final Long flashcardId) {
        final FlashcardEntity entity = getActiveFlashcard(flashcardId);
        flashcardLanguageRepository.removeByFlashcardId(entity.getId());
        entity.setDeletedAt(OffsetDateTime.now());
        flashcardRepository.save(entity);
    }

    private DeckEntity getActiveDeck(final Long deckId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(deckId, ApiMessageKey.DECK_ID_POSITIVE);
        // Return the active deck that owns the flashcard.
        return deckRepository.findByIdAndDeletedAtIsNull(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.DECK_NOT_FOUND, validatedId));
    }

    private FlashcardEntity getActiveFlashcard(final Long flashcardId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(
            flashcardId,
            ApiMessageKey.FLASHCARD_ID_POSITIVE
        );
        // Return the active flashcard or fail when the row is missing or soft-deleted.
        return flashcardRepository.findByIdAndDeletedAtIsNull(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.FLASHCARD_NOT_FOUND, validatedId));
    }
}
