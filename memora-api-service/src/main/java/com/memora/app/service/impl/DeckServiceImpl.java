package com.memora.app.service.impl;

import java.time.OffsetDateTime;
import java.util.List;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.CreateDeckRequest;
import com.memora.app.dto.DeckDto;
import com.memora.app.dto.UpdateDeckRequest;
import com.memora.app.entity.DeckEntity;
import com.memora.app.entity.FlashcardEntity;
import com.memora.app.entity.FolderEntity;
import com.memora.app.exception.ConflictException;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.mapper.DeckMapper;
import com.memora.app.repository.DeckRepository;
import com.memora.app.repository.DeckReviewSettingsRepository;
import com.memora.app.repository.FlashcardLanguageRepository;
import com.memora.app.repository.FlashcardRepository;
import com.memora.app.repository.FolderRepository;
import com.memora.app.service.DeckService;
import com.memora.app.util.ServiceValidationUtils;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DeckServiceImpl implements DeckService {

    private final DeckRepository deckRepository;
    private final DeckReviewSettingsRepository deckReviewSettingsRepository;
    private final FlashcardLanguageRepository flashcardLanguageRepository;
    private final FlashcardRepository flashcardRepository;
    private final FolderRepository folderRepository;

    @Override
    @Transactional
    public DeckDto createDeck(final CreateDeckRequest request) {
        final FolderEntity folder = getActiveFolder(request.folderId());
        final String name = ServiceValidationUtils.normalizeRequiredText(request.name(), ApiMessageKey.NAME_REQUIRED);

        assertDeckNameAvailable(folder.getId(), name, null);

        final DeckEntity entity = new DeckEntity();
        entity.setUserId(folder.getUserId());
        entity.setFolderId(folder.getId());
        entity.setName(name);
        entity.setDescription(ServiceValidationUtils.normalizeOptionalText(request.description()));
        return DeckMapper.toDto(deckRepository.save(entity));
    }

    @Override
    @Transactional(readOnly = true)
    public DeckDto getDeck(final Long deckId) {
        return DeckMapper.toDto(getActiveDeck(deckId));
    }

    @Override
    @Transactional(readOnly = true)
    public List<DeckDto> getDecks(final Long userId, final Long folderId) {
        if (userId != null && folderId != null) {
            return deckRepository.findAllByUserIdAndFolderIdAndDeletedAtIsNullOrderByIdAsc(
                    ServiceValidationUtils.requirePositiveId(userId, ApiMessageKey.USER_ID_POSITIVE),
                    ServiceValidationUtils.requirePositiveId(folderId, ApiMessageKey.FOLDER_ID_POSITIVE)
                )
                .stream()
                .map(DeckMapper::toDto)
                .toList();
        }

        if (userId != null) {
            return deckRepository.findAllByUserIdAndDeletedAtIsNullOrderByIdAsc(
                    ServiceValidationUtils.requirePositiveId(userId, ApiMessageKey.USER_ID_POSITIVE)
                )
                .stream()
                .map(DeckMapper::toDto)
                .toList();
        }

        if (folderId != null) {
            return deckRepository.findAllByFolderIdAndDeletedAtIsNullOrderByIdAsc(
                    ServiceValidationUtils.requirePositiveId(folderId, ApiMessageKey.FOLDER_ID_POSITIVE)
                )
                .stream()
                .map(DeckMapper::toDto)
                .toList();
        }

        return deckRepository.findAllByDeletedAtIsNullOrderByIdAsc()
            .stream()
            .map(DeckMapper::toDto)
            .toList();
    }

    @Override
    @Transactional
    public DeckDto updateDeck(final Long deckId, final UpdateDeckRequest request) {
        final DeckEntity entity = getActiveDeck(deckId);
        final FolderEntity folder = getActiveFolder(request.folderId());
        final String name = ServiceValidationUtils.normalizeRequiredText(request.name(), ApiMessageKey.NAME_REQUIRED);

        assertDeckNameAvailable(folder.getId(), name, entity.getId());

        entity.setUserId(folder.getUserId());
        entity.setFolderId(folder.getId());
        entity.setName(name);
        entity.setDescription(ServiceValidationUtils.normalizeOptionalText(request.description()));
        return DeckMapper.toDto(deckRepository.save(entity));
    }

    @Override
    @Transactional
    public void deleteDeck(final Long deckId) {
        final DeckEntity entity = getActiveDeck(deckId);
        final List<FlashcardEntity> flashcards = flashcardRepository.findAllByDeckIdAndDeletedAtIsNullOrderByIdAsc(entity.getId());

        deckReviewSettingsRepository.removeByDeckId(entity.getId());

        for (final FlashcardEntity flashcard : flashcards) {
            flashcardLanguageRepository.removeByFlashcardId(flashcard.getId());
            flashcard.setDeletedAt(OffsetDateTime.now());
            flashcardRepository.save(flashcard);
        }

        entity.setDeletedAt(OffsetDateTime.now());
        deckRepository.save(entity);
    }

    private DeckEntity getActiveDeck(final Long deckId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(deckId, ApiMessageKey.DECK_ID_POSITIVE);
        return deckRepository.findByIdAndDeletedAtIsNull(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.DECK_NOT_FOUND, validatedId));
    }

    private FolderEntity getActiveFolder(final Long folderId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(folderId, ApiMessageKey.FOLDER_ID_POSITIVE);
        return folderRepository.findByIdAndDeletedAtIsNull(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.FOLDER_NOT_FOUND, validatedId));
    }

    private void assertDeckNameAvailable(final Long folderId, final String name, final Long deckId) {
        final boolean alreadyExists = deckId == null
            ? deckRepository.existsByFolderIdAndNameIgnoreCaseAndDeletedAtIsNull(folderId, name)
            : deckRepository.existsByFolderIdAndNameIgnoreCaseAndDeletedAtIsNullAndIdNot(folderId, name, deckId);

        if (alreadyExists) {
            throw new ConflictException(ApiMessageKey.DECK_NAME_EXISTS);
        }
    }
}
