package com.memora.app.service.impl;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Locale;
import java.util.Objects;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.request.deck.CreateDeckRequest;
import com.memora.app.dto.response.deck.DeckResponse;
import com.memora.app.dto.request.deck.UpdateDeckRequest;
import com.memora.app.entity.DeckEntity;
import com.memora.app.entity.FolderEntity;
import com.memora.app.enums.deck.DeckSortField;
import com.memora.app.exception.ConflictException;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.mapper.DeckMapper;
import com.memora.app.repository.DeckRepository;
import com.memora.app.repository.DeckReviewSettingsRepository;
import com.memora.app.repository.FlashcardLanguageRepository;
import com.memora.app.repository.FlashcardRepository;
import com.memora.app.repository.FolderRepository;
import com.memora.app.repository.specification.DeckSpecification;
import com.memora.app.security.CurrentAuthenticatedUserService;
import com.memora.app.service.DeckService;
import com.memora.app.util.ServiceValidationUtils;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DeckServiceImpl implements DeckService {

    private static final int DEFAULT_PAGE = 0;
    private static final int DEFAULT_SIZE = 20;
    private static final int MAX_PAGE_SIZE = 100;
    private static final Sort ID_ASC_SORT = Sort.by(Sort.Order.asc("id"));

    private final DeckRepository deckRepository;
    private final DeckReviewSettingsRepository deckReviewSettingsRepository;
    private final FlashcardLanguageRepository flashcardLanguageRepository;
    private final FlashcardRepository flashcardRepository;
    private final FolderRepository folderRepository;
    private final CurrentAuthenticatedUserService currentAuthenticatedUserService;
    private final DeckMapper deckMapper;

    @Override
    @Transactional
    public DeckResponse createDeck(final Long folderId, final CreateDeckRequest request) {
        final Long currentUserId = currentAuthenticatedUserService.getCurrentUser().userId();
        final FolderEntity folder = getActiveFolder(folderId, currentUserId);
        final String name = ServiceValidationUtils.normalizeRequiredText(request.name(), ApiMessageKey.NAME_REQUIRED);

        assertFolderCanContainDecks(folder);
        assertDeckNameAvailable(folder.getId(), name, null);

        final DeckEntity entity = new DeckEntity();
        entity.setUserId(folder.getUserId());
        entity.setFolderId(folder.getId());
        entity.setName(name);
        entity.setDescription(ServiceValidationUtils.normalizeOptionalText(request.description()));
        // Return the created deck snapshot for the active folder.
        return toResponse(deckRepository.save(entity)); 
    }

    @Override
    @Transactional(readOnly = true)
    public DeckResponse getDeck(final Long folderId, final Long deckId) {
        final Long currentUserId = currentAuthenticatedUserService.getCurrentUser().userId();
        getActiveFolder(folderId, currentUserId);
        // Return the requested deck inside the current folder scope.
        return toResponse(getActiveDeck(deckId, folderId));
    }

    @Override
    @Transactional(readOnly = true)
    public List<DeckResponse> getDecks(
        final Long folderId,
        final String searchQuery,
        final String sortBy,
        final String sortType,
        final Integer page,
        final Integer size
    ) {
        final Long currentUserId = currentAuthenticatedUserService.getCurrentUser().userId();
        final FolderEntity folder = getActiveFolder(folderId, currentUserId);

        final Pageable pageable = PageRequest.of(
            normalizePage(page),
            normalizeSize(size),
            buildSort(sortBy, sortType)
        );
        final Page<DeckEntity> resultPage = deckRepository.findAll(
            DeckSpecification.forFolderListing(folder.getId(), searchQuery),
            pageable
        );

        // Return the current page content after applying search and sort.
        return resultPage.map(this::toResponse).getContent();
    }

    @Override
    @Transactional
    public DeckResponse updateDeck(final Long folderId, final Long deckId, final UpdateDeckRequest request) {
        final Long currentUserId = currentAuthenticatedUserService.getCurrentUser().userId();
        final FolderEntity folder = getActiveFolder(folderId, currentUserId);
        final DeckEntity entity = getActiveDeck(deckId, folder.getId());
        final String name = ServiceValidationUtils.normalizeRequiredText(request.name(), ApiMessageKey.NAME_REQUIRED);

        assertFolderCanContainDecks(folder);
        assertDeckNameAvailable(folder.getId(), name, entity.getId());

        entity.setName(name);
        entity.setDescription(ServiceValidationUtils.normalizeOptionalText(request.description()));
        // Return the updated deck snapshot for the active folder.
        return toResponse(deckRepository.save(entity));
    }

    @Override
    @Transactional
    public void deleteDeck(final Long folderId, final Long deckId) {
        final Long currentUserId = currentAuthenticatedUserService.getCurrentUser().userId();
        getActiveFolder(folderId, currentUserId);
        deleteDeckTree(getActiveDeck(deckId, folderId), OffsetDateTime.now());
    }

    private DeckResponse toResponse(final DeckEntity entity) {
        // Map persistence fields to the API response and add derived values.
        return deckMapper.toDto(entity, flashcardRepository.countByDeckIdAndDeletedAtIsNull(entity.getId()));
    }

    private FolderEntity getActiveFolder(final Long folderId, final Long userId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(folderId, ApiMessageKey.FOLDER_ID_POSITIVE);
        // Return the active folder only when it belongs to the current user scope.
        return folderRepository.findByIdAndDeletedAtIsNull(validatedId)
            .filter(folder -> Objects.equals(folder.getUserId(), userId))
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.FOLDER_NOT_FOUND, validatedId));
    }

    private DeckEntity getActiveDeck(final Long deckId, final Long folderId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(deckId, ApiMessageKey.DECK_ID_POSITIVE);
        // Return the active deck only when it belongs to the requested folder.
        return deckRepository.findByIdAndFolderIdAndDeletedAtIsNull(validatedId, folderId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.DECK_NOT_FOUND, validatedId));
    }

    private void assertFolderCanContainDecks(final FolderEntity folder) {
        // Reject deck writes in folders that still contain child folders.
        if (folderRepository.existsByParentIdAndDeletedAtIsNull(folder.getId())) {
            // Stop the write when the folder is not a leaf in the tree.
            throw new ConflictException(ApiMessageKey.FOLDER_NOT_LEAF_FOR_DECK);
        }
    }

    private void assertDeckNameAvailable(final Long folderId, final String name, final Long deckId) {
        final boolean alreadyExists = deckId == null
            ? deckRepository.existsByFolderIdAndNameIgnoreCaseAndDeletedAtIsNull(folderId, name)
            : deckRepository.existsByFolderIdAndNameIgnoreCaseAndDeletedAtIsNullAndIdNot(folderId, name, deckId);

        // Reject duplicate deck names inside the same folder.
        if (alreadyExists) {
            // Stop the write when another active deck already uses the same name.
            throw new ConflictException(ApiMessageKey.DECK_NAME_EXISTS);
        }
    }

    private void deleteDeckTree(final DeckEntity deck, final OffsetDateTime deletedAt) {
        deckReviewSettingsRepository.removeByDeckId(deck.getId());

        // Soft-delete each active flashcard attached to the deck.
        for (final var flashcard : flashcardRepository.findAllByDeckIdAndDeletedAtIsNull(deck.getId(), ID_ASC_SORT)) {
            flashcardLanguageRepository.removeByFlashcardId(flashcard.getId());
            flashcard.setDeletedAt(deletedAt);
            flashcardRepository.save(flashcard);
        }

        deck.setDeletedAt(deletedAt);
        deckRepository.save(deck);
    }

    private Sort buildSort(final String sortBy, final String sortType) {
        final DeckSortField sortField = resolveSortField(sortBy);
        final Sort.Direction direction = resolveSortDirection(sortType);

        // Map contract sort fields to concrete entity properties.
        return switch (sortField) {
            case NAME -> Sort.by(new Sort.Order(direction, "name"), Sort.Order.asc("id"));
            case CREATED_AT -> Sort.by(new Sort.Order(direction, "createdAt"), Sort.Order.asc("id"));
            case UPDATED_AT -> Sort.by(new Sort.Order(direction, "updatedAt"), Sort.Order.asc("id"));
        };
    }

    private DeckSortField resolveSortField(final String sortBy) {
        // Default missing sort requests to the name field.
        if (sortBy == null) {
            // Return the default contract sort field.
            return DeckSortField.NAME;
        }

        try {
            // Return the requested sort field when the input is valid.
            return DeckSortField.valueOf(sortBy.toUpperCase(Locale.ROOT));
        } catch (final IllegalArgumentException exception) {
            // Fall back to a stable default when the client sends an unknown field.
            return DeckSortField.NAME;
        }
    }

    private Sort.Direction resolveSortDirection(final String sortType) {
        // Default missing sort direction requests to ascending order.
        if (sortType == null) {
            // Return the default contract sort direction.
            return Sort.Direction.ASC;
        }

        try {
            // Return the requested direction when the input is valid.
            return Sort.Direction.valueOf(sortType.toUpperCase(Locale.ROOT));
        } catch (final IllegalArgumentException exception) {
            // Fall back to ascending order when the client sends an unknown direction.
            return Sort.Direction.ASC;
        }
    }

    private int normalizePage(final Integer page) {
        // Clamp missing or negative page requests to the first page.
        if (page == null || page < 0) {
            // Return the default page index for invalid requests.
            return DEFAULT_PAGE;
        }
        // Return the validated page index.
        return page;
    }

    private int normalizeSize(final Integer size) {
        // Clamp missing or non-positive size requests to the default page size.
        if (size == null || size <= 0) {
            // Return the default page size for invalid requests.
            return DEFAULT_SIZE;
        }
        // Return the requested size while keeping it within the allowed cap.
        return Math.min(size, MAX_PAGE_SIZE);
    }
}



