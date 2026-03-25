package com.memora.app.service.impl;

import java.time.OffsetDateTime;
import java.util.Objects;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.request.flashcard.CreateFlashcardRequest;
import com.memora.app.dto.response.flashcard.FlashcardResponse;
import com.memora.app.dto.response.flashcard.FlashcardPageResponse;
import com.memora.app.dto.request.flashcard.UpdateFlashcardRequest;
import com.memora.app.entity.DeckEntity;
import com.memora.app.entity.FlashcardEntity;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.mapper.FlashcardMapper;
import com.memora.app.repository.DeckRepository;
import com.memora.app.repository.FlashcardLanguageRepository;
import com.memora.app.repository.FlashcardRepository;
import com.memora.app.repository.specification.FlashcardSpecification;
import com.memora.app.security.CurrentAuthenticatedUserService;
import com.memora.app.service.FlashcardService;
import com.memora.app.util.ServiceValidationUtils;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FlashcardServiceImpl implements FlashcardService {

    private final DeckRepository deckRepository;
    private final FlashcardLanguageRepository flashcardLanguageRepository;
    private final FlashcardRepository flashcardRepository;
    private final CurrentAuthenticatedUserService currentAuthenticatedUserService;
    private final FlashcardMapper flashcardMapper;

    @Override
    @Transactional
    public FlashcardResponse createFlashcard(final Long deckId, final CreateFlashcardRequest request) {
        final DeckEntity deck = getActiveDeck(deckId);

        final FlashcardEntity entity = new FlashcardEntity();
        entity.setDeckId(deck.getId());
        entity.setTerm(ServiceValidationUtils.normalizeRequiredText(
            request.frontText(),
            ApiMessageKey.FLASHCARD_FRONT_TEXT_REQUIRED
        ));
        entity.setMeaning(ServiceValidationUtils.normalizeRequiredText(
            request.backText(),
            ApiMessageKey.FLASHCARD_BACK_TEXT_REQUIRED
        ));
        entity.setNote("");
        entity.setBookmarked(false);

        final FlashcardEntity saved = flashcardRepository.save(entity);
        FlashcardQuerySupport.syncFlashcardLanguages(
            saved.getId(),
            request.frontLangCode(),
            request.backLangCode(),
            flashcardLanguageRepository
        );
        // Return the created flashcard snapshot after side-language synchronization.
        return FlashcardQuerySupport.toResponse(saved, flashcardLanguageRepository, flashcardMapper);
    }

    @Override
    @Transactional(readOnly = true)
    public FlashcardPageResponse getFlashcards(
        final Long deckId,
        final String searchQuery,
        final String sortBy,
        final String sortType,
        final Integer page,
        final Integer size
    ) {
        final DeckEntity deck = getActiveDeck(deckId);
        final Pageable pageable = PageRequest.of(
            FlashcardQuerySupport.normalizePage(page),
            FlashcardQuerySupport.normalizeSize(size),
            FlashcardQuerySupport.buildSort(sortBy, sortType)
        );
        final Page<FlashcardEntity> flashcards = flashcardRepository.findAll(
            FlashcardSpecification.forDeckListing(deck.getId(), searchQuery),
            pageable
        );
        final Page<FlashcardResponse> responsePage = flashcards.map(
            entity -> FlashcardQuerySupport.toResponse(entity, flashcardLanguageRepository, flashcardMapper)
        );
        // Return the paged response payload expected by the contract.
        return new FlashcardPageResponse(
            responsePage.getContent(),
            responsePage.getNumber(),
            responsePage.getSize(),
            responsePage.getTotalElements(),
            responsePage.getTotalPages(),
            responsePage.hasNext(),
            responsePage.hasPrevious()
        );
    }

    @Override
    @Transactional
    public FlashcardResponse updateFlashcard(
        final Long deckId,
        final Long flashcardId,
        final UpdateFlashcardRequest request
    ) {
        final DeckEntity deck = getActiveDeck(deckId);
        final FlashcardEntity entity = getActiveFlashcard(deck.getId(), flashcardId);

        entity.setTerm(ServiceValidationUtils.normalizeRequiredText(
            request.frontText(),
            ApiMessageKey.FLASHCARD_FRONT_TEXT_REQUIRED
        ));
        entity.setMeaning(ServiceValidationUtils.normalizeRequiredText(
            request.backText(),
            ApiMessageKey.FLASHCARD_BACK_TEXT_REQUIRED
        ));

        final FlashcardEntity saved = flashcardRepository.save(entity);
        FlashcardQuerySupport.syncFlashcardLanguages(
            saved.getId(),
            request.frontLangCode(),
            request.backLangCode(),
            flashcardLanguageRepository
        );
        // Return the updated flashcard snapshot after side-language synchronization.
        return FlashcardQuerySupport.toResponse(saved, flashcardLanguageRepository, flashcardMapper);
    }

    @Override
    @Transactional
    public void deleteFlashcard(final Long deckId, final Long flashcardId) {
        final DeckEntity deck = getActiveDeck(deckId);
        final FlashcardEntity entity = getActiveFlashcard(deck.getId(), flashcardId);
        flashcardLanguageRepository.removeByFlashcardId(entity.getId());
        entity.setDeletedAt(OffsetDateTime.now());
        // Persist the soft-delete marker after clearing dependent language rows.
        flashcardRepository.save(entity);
    }

    private DeckEntity getActiveDeck(final Long deckId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(deckId, ApiMessageKey.DECK_ID_POSITIVE);
        final Long currentUserId = currentAuthenticatedUserService.getCurrentUser().userId();
        // Return the active deck only when it belongs to the current workspace owner.
        return deckRepository.findByIdAndDeletedAtIsNull(validatedId)
            .filter(deck -> Objects.equals(deck.getUserId(), currentUserId))
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.DECK_NOT_FOUND, validatedId));
    }

    private FlashcardEntity getActiveFlashcard(final Long deckId, final Long flashcardId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(
            flashcardId,
            ApiMessageKey.FLASHCARD_ID_POSITIVE
        );
        // Return the active flashcard only when it belongs to the requested deck.
        return flashcardRepository.findByIdAndDeckIdAndDeletedAtIsNull(validatedId, deckId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.FLASHCARD_NOT_FOUND, validatedId));
    }

}



