package com.memora.app.service.impl;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Objects;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.request.folder.CreateFolderRequest;
import com.memora.app.dto.response.folder.FolderResponse;
import com.memora.app.dto.request.folder.RenameFolderRequest;
import com.memora.app.dto.request.folder.UpdateFolderRequest;
import com.memora.app.entity.DeckEntity;
import com.memora.app.entity.FolderEntity;
import com.memora.app.exception.ConflictException;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.mapper.FolderMapper;
import com.memora.app.repository.DeckRepository;
import com.memora.app.repository.DeckReviewSettingsRepository;
import com.memora.app.repository.FlashcardLanguageRepository;
import com.memora.app.repository.FlashcardRepository;
import com.memora.app.repository.FolderRepository;
import com.memora.app.repository.specification.FolderSpecification;
import com.memora.app.security.CurrentAuthenticatedUserService;
import com.memora.app.service.FolderService;
import com.memora.app.util.ServiceValidationUtils;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FolderServiceImpl implements FolderService {

    private static final Sort ID_ASC_SORT = Sort.by(Sort.Order.asc("id"));

    private final DeckRepository deckRepository;
    private final DeckReviewSettingsRepository deckReviewSettingsRepository;
    private final FlashcardLanguageRepository flashcardLanguageRepository;
    private final FlashcardRepository flashcardRepository;
    private final FolderRepository folderRepository;
    private final CurrentAuthenticatedUserService currentAuthenticatedUserService;
    private final FolderMapper folderMapper;

    @Override
    @Transactional
    public FolderResponse createFolder(final CreateFolderRequest request) {
        final Long currentUserId = currentAuthenticatedUserService.getCurrentUser().userId();
        final String name = ServiceValidationUtils.normalizeRequiredText(request.name(), ApiMessageKey.NAME_REQUIRED);
        final FolderEntity parentFolder = getParentFolderOrNull(request.parentId(), currentUserId);

        assertFolderCanAcceptChildFolder(parentFolder);
        assertFolderNameAvailable(currentUserId, request.parentId(), name, null);

        final FolderEntity entity = new FolderEntity();
        entity.setUserId(currentUserId);
        entity.setParentId(parentFolder == null ? null : parentFolder.getId());
        entity.setName(name);
        entity.setDescription(ServiceValidationUtils.normalizeOptionalText(request.description()));
        entity.setDepth(parentFolder == null ? 0 : parentFolder.getDepth() + 1);
        // Return the persisted folder snapshot.
        return FolderQuerySupport.toResponse(folderRepository.save(entity), folderRepository, folderMapper);
    }

    @Override
    @Transactional(readOnly = true)
    public FolderResponse getFolder(final Long folderId) {
        final Long currentUserId = currentAuthenticatedUserService.getCurrentUser().userId();
        // Return the active folder snapshot for the current user scope.
        return FolderQuerySupport.toResponse(getActiveFolder(folderId, currentUserId), folderRepository, folderMapper);
    }

    @Override
    @Transactional(readOnly = true)
    public List<FolderResponse> getFolders(
        final Long parentId,
        final String searchQuery,
        final String sortBy,
        final String sortType,
        final Integer page,
        final Integer size
    ) {
        final Long currentUserId = currentAuthenticatedUserService.getCurrentUser().userId();
        final Long normalizedParentId = FolderQuerySupport.normalizeParentId(parentId);
        // Validate the parent folder before listing its children.
        if (normalizedParentId != null) {
            getActiveFolder(normalizedParentId, currentUserId);
        }

        final Pageable pageable = PageRequest.of(
            FolderQuerySupport.normalizePage(page),
            FolderQuerySupport.normalizeSize(size),
            FolderQuerySupport.buildSort(sortBy, sortType)
        );

        // Return the requested page content after applying search and sort rules.
        return folderRepository.findAll(
            FolderSpecification.forListing(currentUserId, normalizedParentId, searchQuery),
            pageable
        )
            .map(entity -> FolderQuerySupport.toResponse(entity, folderRepository, folderMapper))
            .getContent();
    }

    @Override
    @Transactional
    public FolderResponse renameFolder(final Long folderId, final RenameFolderRequest request) {
        final Long currentUserId = currentAuthenticatedUserService.getCurrentUser().userId();
        final FolderEntity entity = getActiveFolder(folderId, currentUserId);
        final String name = ServiceValidationUtils.normalizeRequiredText(request.name(), ApiMessageKey.NAME_REQUIRED);

        assertFolderNameAvailable(entity.getUserId(), entity.getParentId(), name, entity.getId());

        entity.setName(name);
        // Return the renamed folder snapshot.
        return FolderQuerySupport.toResponse(folderRepository.save(entity), folderRepository, folderMapper);
    }

    @Override
    @Transactional
    public FolderResponse updateFolder(final Long folderId, final UpdateFolderRequest request) {
        final Long currentUserId = currentAuthenticatedUserService.getCurrentUser().userId();
        final FolderEntity entity = getActiveFolder(folderId, currentUserId);
        final String name = ServiceValidationUtils.normalizeRequiredText(request.name(), ApiMessageKey.NAME_REQUIRED);

        assertFolderNameAvailable(entity.getUserId(), entity.getParentId(), name, entity.getId());

        entity.setName(name);
        entity.setDescription(ServiceValidationUtils.normalizeOptionalText(request.description()));
        // Return the updated folder snapshot.
        return FolderQuerySupport.toResponse(folderRepository.save(entity), folderRepository, folderMapper);
    }

    @Override
    @Transactional
    public void deleteFolder(final Long folderId) {
        final Long currentUserId = currentAuthenticatedUserService.getCurrentUser().userId();
        // Delete the requested folder tree in the active workspace.
        deleteFolderTree(getActiveFolder(folderId, currentUserId));
    }

    private FolderEntity getActiveFolder(final Long folderId, final Long userId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(folderId, ApiMessageKey.FOLDER_ID_POSITIVE);
        // Return the requested active folder only when it belongs to the current user scope.
        return folderRepository.findByIdAndDeletedAtIsNull(validatedId)
            .filter(folder -> Objects.equals(folder.getUserId(), userId))
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.FOLDER_NOT_FOUND, validatedId));
    }

    private FolderEntity getParentFolderOrNull(final Long folderId, final Long currentUserId) {
        // Keep root folders parentless.
        if (folderId == null) {
            // Return null when the folder is intended to live at the root level.
            return null;
        }
        // Resolve the parent folder for a nested folder create request.
        return getActiveFolder(folderId, currentUserId);
    }

    private void assertFolderCanAcceptChildFolder(final FolderEntity parentFolder) {
        // Root folders can always accept child folders.
        if (parentFolder == null) {
            // Skip the leaf-folder constraint at the top level.
            return;
        }
        // Reject creating a subfolder under a folder that already hosts decks.
        if (deckRepository.existsByFolderIdAndDeletedAtIsNull(parentFolder.getId())) {
            // Stop the write when the parent would violate the folder/deck exclusivity rule.
            throw new ConflictException(ApiMessageKey.FOLDER_PARENT_HAS_ACTIVE_DECKS);
        }
    }

    private void deleteFolderTree(final FolderEntity folder) {
        // Delete child folders before touching the current folder row.
        for (final FolderEntity childFolder : folderRepository.findAllByParentIdAndDeletedAtIsNull(folder.getId(), ID_ASC_SORT)) {
            deleteFolderTree(childFolder);
        }

        // Delete decks in the current folder before soft-deleting the folder itself.
        for (final DeckEntity deck : deckRepository.findAllByFolderIdAndDeletedAtIsNull(folder.getId(), ID_ASC_SORT)) {
            deleteDeckTree(deck);
        }

        folder.setDeletedAt(OffsetDateTime.now());
        // Persist the soft-delete marker on the current folder.
        folderRepository.save(folder);
    }

    private void deleteDeckTree(final DeckEntity deck) {
        // Remove deck-specific review settings before marking the deck deleted.
        deckReviewSettingsRepository.removeByDeckId(deck.getId());
        // Soft-delete each active flashcard attached to the deck.
        for (final var flashcard : flashcardRepository.findAllByDeckIdAndDeletedAtIsNull(deck.getId(), ID_ASC_SORT)) {
            flashcardLanguageRepository.removeByFlashcardId(flashcard.getId());
            flashcard.setDeletedAt(OffsetDateTime.now());
            flashcardRepository.save(flashcard);
        }

        deck.setDeletedAt(OffsetDateTime.now());
        // Persist the soft-delete marker on the deck.
        deckRepository.save(deck);
    }

    private void assertFolderNameAvailable(
        final Long userId,
        final Long parentId,
        final String name,
        final Long folderId
    ) {
        final boolean alreadyExists = folderId == null
            ? folderRepository.existsByUserIdAndParentIdAndNameIgnoreCaseAndDeletedAtIsNull(userId, parentId, name)
            : folderRepository.existsByUserIdAndParentIdAndNameIgnoreCaseAndDeletedAtIsNullAndIdNot(
                userId,
                parentId,
                name,
                folderId
            );
        // Reject duplicate sibling names for the same owner and parent.
        if (alreadyExists) {
            // Stop the write when another active sibling already uses the same name.
            throw new ConflictException(ApiMessageKey.FOLDER_NAME_EXISTS);
        }
    }
}



