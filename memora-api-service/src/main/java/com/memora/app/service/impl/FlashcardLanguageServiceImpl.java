package com.memora.app.service.impl;

import java.util.Locale;
import java.util.List;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.CreateFlashcardLanguageRequest;
import com.memora.app.dto.FlashcardLanguageDto;
import com.memora.app.dto.UpdateFlashcardLanguageRequest;
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
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FlashcardLanguageServiceImpl implements FlashcardLanguageService {

    private final FlashcardLanguageRepository flashcardLanguageRepository;
    private final FlashcardRepository flashcardRepository;

    @Override
    @Transactional
    public FlashcardLanguageDto createFlashcardLanguage(final CreateFlashcardLanguageRequest request) {
        final FlashcardEntity flashcard = getActiveFlashcard(request.flashcardId());
        assertSideAvailable(flashcard.getId(), request.side(), null);

        final FlashcardLanguageEntity entity = new FlashcardLanguageEntity();
        entity.setFlashcardId(flashcard.getId());
        entity.setSide(request.side());
        entity.setLanguageCode(normalizeLanguageCode(request.languageCode()));
        entity.setPronunciation(ServiceValidationUtils.normalizeOptionalText(request.pronunciation()));
        // Return the persisted flashcard language metadata.
        return FlashcardLanguageMapper.toDto(flashcardLanguageRepository.save(entity));
    }

    @Override
    @Transactional(readOnly = true)
    public FlashcardLanguageDto getFlashcardLanguage(final Long flashcardLanguageId) {
        // Return the requested flashcard language row.
        return FlashcardLanguageMapper.toDto(getFlashcardLanguageEntity(flashcardLanguageId));
    }

    @Override
    @Transactional(readOnly = true)
    public List<FlashcardLanguageDto> getFlashcardLanguages(final Long flashcardId) {
        // Narrow the query when the caller requests languages for one flashcard.
        if (flashcardId != null) {
            // Return languages that belong to the requested flashcard.
            return flashcardLanguageRepository.findAllByFlashcardIdOrderByIdAsc(
                    ServiceValidationUtils.requirePositiveId(flashcardId, ApiMessageKey.FLASHCARD_ID_POSITIVE)
                )
                // Convert persisted language rows into DTOs for the API layer.
                .stream()
                .map(FlashcardLanguageMapper::toDto)
                .toList();
        }

        // Return every flashcard language row when no filter is provided.
        return flashcardLanguageRepository.findAllByOrderByIdAsc()
            // Convert persisted language rows into DTOs for the API layer.
            .stream()
            .map(FlashcardLanguageMapper::toDto)
            .toList();
    }

    @Override
    @Transactional
    public FlashcardLanguageDto updateFlashcardLanguage(
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
        return FlashcardLanguageMapper.toDto(flashcardLanguageRepository.save(entity));
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
        final com.memora.app.enums.FlashcardSide side,
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
