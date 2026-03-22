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
        // Return the persisted deck.
        return DeckMapper.toDto(deckRepository.save(entity));
    }

    @Override
    @Transactional(readOnly = true)
    public DeckDto getDeck(final Long deckId) {
        // Return the requested active deck.
        return DeckMapper.toDto(getActiveDeck(deckId));
    }

    @Override
    @Transactional(readOnly = true)
    public List<DeckDto> getDecks(final Long userId, final Long folderId) {
        // Prefer the narrowest query when both user and folder filters are present.
        if (userId != null && folderId != null) {
            // Return decks that belong to the requested user inside the requested folder.
            return deckRepository.findAllByUserIdAndFolderIdAndDeletedAtIsNullOrderByIdAsc(
                    ServiceValidationUtils.requirePositiveId(userId, ApiMessageKey.USER_ID_POSITIVE),
                    ServiceValidationUtils.requirePositiveId(folderId, ApiMessageKey.FOLDER_ID_POSITIVE)
                )
                // Convert persisted deck rows into DTOs for the API layer.
                .stream()
                .map(DeckMapper::toDto)
                .toList();
        }

        // Fall back to a user-only query when only the owner filter is provided.
        if (userId != null) {
            // Return every active deck for the requested user.
            return deckRepository.findAllByUserIdAndDeletedAtIsNullOrderByIdAsc(
                    ServiceValidationUtils.requirePositiveId(userId, ApiMessageKey.USER_ID_POSITIVE)
                )
                // Convert persisted deck rows into DTOs for the API layer.
                .stream()
                .map(DeckMapper::toDto)
                .toList();
        }

        // Fall back to a folder-only query when only the folder filter is provided.
        if (folderId != null) {
            // Return every active deck in the requested folder.
            return deckRepository.findAllByFolderIdAndDeletedAtIsNullOrderByIdAsc(
                    ServiceValidationUtils.requirePositiveId(folderId, ApiMessageKey.FOLDER_ID_POSITIVE)
                )
                // Convert persisted deck rows into DTOs for the API layer.
                .stream()
                .map(DeckMapper::toDto)
                .toList();
        }

        // Return every active deck when no filter is provided.
        return deckRepository.findAllByDeletedAtIsNullOrderByIdAsc()
            // Convert persisted deck rows into DTOs for the API layer.
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
        // Return the updated deck snapshot.
        return DeckMapper.toDto(deckRepository.save(entity));
    }

    @Override
    @Transactional
    public void deleteDeck(final Long deckId) {
        final DeckEntity entity = getActiveDeck(deckId);
        final List<FlashcardEntity> flashcards = flashcardRepository.findAllByDeckIdAndDeletedAtIsNullOrderByIdAsc(entity.getId());

        deckReviewSettingsRepository.removeByDeckId(entity.getId());

        // Soft-delete each flashcard after removing its dependent language rows.
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
        // Return the active deck or fail when the row is missing or soft-deleted.
        return deckRepository.findByIdAndDeletedAtIsNull(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.DECK_NOT_FOUND, validatedId));
    }

    private FolderEntity getActiveFolder(final Long folderId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(folderId, ApiMessageKey.FOLDER_ID_POSITIVE);
        // Return the active folder that will own the deck.
        return folderRepository.findByIdAndDeletedAtIsNull(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.FOLDER_NOT_FOUND, validatedId));
    }

    private void assertDeckNameAvailable(final Long folderId, final String name, final Long deckId) {
        final boolean alreadyExists = deckId == null
            ? deckRepository.existsByFolderIdAndNameIgnoreCaseAndDeletedAtIsNull(folderId, name)
            : deckRepository.existsByFolderIdAndNameIgnoreCaseAndDeletedAtIsNullAndIdNot(folderId, name, deckId);

        // Reject duplicate deck names within the same folder.
        if (alreadyExists) {
            // Stop the write when another active deck already uses the same name.
            throw new ConflictException(ApiMessageKey.DECK_NAME_EXISTS);
        }
    }
}
