package com.memora.app.service.impl;

import java.util.Locale;
import java.util.List;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.request.flashcard_language.CreateFlashcardLanguageRequest;
import com.memora.app.dto.response.flashcard_language.FlashcardLanguageResponse;
import com.memora.app.dto.request.flashcard_language.UpdateFlashcardLanguageRequest;
import com.memora.app.entity.FlashcardEntity;
import com.memora.app.entity.FlashcardLanguageEntity;
import com.memora.app.exception.ConflictException;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.mapper.FlashcardLanguageMapper;
import com.memora.app.repository.FlashcardLanguageRepository;
import com.memora.app.repository.FlashcardRepository;
import com.memora.app.service.FlashcardLanguageService;
import com.memora.app.util.ServiceValidationUtils;

import org.apache.commons.lang3.StringUtils;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FlashcardLanguageServiceImpl implements FlashcardLanguageService {

    private static final Sort ID_ASC_SORT = Sort.by(Sort.Order.asc("id"));

    private final FlashcardLanguageRepository flashcardLanguageRepository;
    private final FlashcardRepository flashcardRepository;
    private final FlashcardLanguageMapper flashcardLanguageMapper;

    @Override
    @Transactional
    public FlashcardLanguageResponse createFlashcardLanguage(final CreateFlashcardLanguageRequest request) {
        final FlashcardEntity flashcard = getActiveFlashcard(request.flashcardId());
        assertSideAvailable(flashcard.getId(), request.side(), null);

        final FlashcardLanguageEntity entity = FlashcardLanguageEntity.builder()
            .flashcardId(flashcard.getId())
            .side(request.side())
            .languageCode(normalizeLanguageCode(request.languageCode()))
            .pronunciation(ServiceValidationUtils.normalizeOptionalText(request.pronunciation()))
            .build();
        // Return the persisted flashcard language metadata.
        return flashcardLanguageMapper.toDto(flashcardLanguageRepository.save(entity));
    }

    @Override
    @Transactional(readOnly = true)
    public FlashcardLanguageResponse getFlashcardLanguage(final Long flashcardLanguageId) {
        // Return the requested flashcard language row.
        return flashcardLanguageMapper.toDto(getFlashcardLanguageEntity(flashcardLanguageId));
    }

    @Override
    @Transactional(readOnly = true)
    public List<FlashcardLanguageResponse> getFlashcardLanguages(final Long flashcardId) {
        // Narrow the query when the caller requests languages for one flashcard.
        if (flashcardId != null) {
            // Return languages that belong to the requested flashcard.
            return flashcardLanguageRepository.findAllByFlashcardId(
                    ServiceValidationUtils.requirePositiveId(flashcardId, ApiMessageKey.FLASHCARD_ID_POSITIVE),
                    ID_ASC_SORT
                )
                // Convert persisted language rows into DTOs for the API layer.
                .stream()
                .map(flashcardLanguageMapper::toDto)
                .toList();
        }

        // Return every flashcard language row when no filter is provided.
        return flashcardLanguageRepository.findAll(ID_ASC_SORT)
            // Convert persisted language rows into DTOs for the API layer.
            .stream()
            .map(flashcardLanguageMapper::toDto)
            .toList();
    }

    @Override
    @Transactional
    public FlashcardLanguageResponse updateFlashcardLanguage(
        final Long flashcardLanguageId,
        final UpdateFlashcardLanguageRequest request
    ) {
        final FlashcardLanguageEntity entity = getFlashcardLanguageEntity(flashcardLanguageId);
        final FlashcardEntity flashcard = getActiveFlashcard(request.flashcardId());
        assertSideAvailable(flashcard.getId(), request.side(), entity.getId());

        entity.setFlashcardId(flashcard.getId());
        entity.setSide(request.side());
        entity.setLanguageCode(normalizeLanguageCode(request.languageCode()));
        entity.setPronunciation(ServiceValidationUtils.normalizeOptionalText(request.pronunciation()));
        // Return the updated flashcard language metadata.
        return flashcardLanguageMapper.toDto(flashcardLanguageRepository.save(entity));
    }

    @Override
    @Transactional
    public void deleteFlashcardLanguage(final Long flashcardLanguageId) {
        final FlashcardLanguageEntity entity = getFlashcardLanguageEntity(flashcardLanguageId);
        flashcardLanguageRepository.removeById(entity.getId());
    }

    private FlashcardEntity getActiveFlashcard(final Long flashcardId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(
            flashcardId,
            ApiMessageKey.FLASHCARD_ID_POSITIVE
        );
        // Return the active flashcard that owns the language row.
        return flashcardRepository.findByIdAndDeletedAtIsNull(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.FLASHCARD_NOT_FOUND, validatedId));
    }

    private FlashcardLanguageEntity getFlashcardLanguageEntity(final Long flashcardLanguageId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(
            flashcardLanguageId,
            ApiMessageKey.FLASHCARD_LANGUAGE_ID_POSITIVE
        );
        // Return the persisted flashcard language row or fail when it is missing.
        return flashcardLanguageRepository.findById(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.FLASHCARD_LANGUAGE_NOT_FOUND, validatedId));
    }

    private void assertSideAvailable(
        final Long flashcardId,
        final com.memora.app.enums.flashcard.FlashcardSide side,
        final Long flashcardLanguageId
    ) {
        final boolean alreadyExists = flashcardLanguageId == null
            ? flashcardLanguageRepository.existsByFlashcardIdAndSide(flashcardId, side)
            : flashcardLanguageRepository.existsByFlashcardIdAndSideAndIdNot(flashcardId, side, flashcardLanguageId);

        // Reject duplicate language metadata for the same flashcard side.
        if (alreadyExists) {
            // Stop the write when the side already has a language row.
            throw new ConflictException(ApiMessageKey.FLASHCARD_LANGUAGE_SIDE_EXISTS);
        }
    }

    private String normalizeLanguageCode(final String languageCode) {
        // Return a normalized language code that is stable for lookups and uniqueness checks.
        return StringUtils.lowerCase(
            ServiceValidationUtils.normalizeRequiredText(languageCode, ApiMessageKey.LANGUAGE_CODE_REQUIRED),
            Locale.ROOT
        );
    }
}



