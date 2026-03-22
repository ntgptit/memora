package com.memora.app.service.impl;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Objects;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.CreateFolderRequest;
import com.memora.app.dto.FolderDto;
import com.memora.app.dto.UpdateFolderRequest;
import com.memora.app.entity.FolderEntity;
import com.memora.app.entity.UserAccountEntity;
import com.memora.app.exception.ConflictException;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.mapper.FolderMapper;
import com.memora.app.repository.DeckRepository;
import com.memora.app.repository.FolderRepository;
import com.memora.app.repository.UserAccountRepository;
import com.memora.app.service.FolderService;
import com.memora.app.util.ServiceValidationUtils;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FolderServiceImpl implements FolderService {

    private final DeckRepository deckRepository;
    private final FolderRepository folderRepository;
    private final UserAccountRepository userAccountRepository;

    @Override
    @Transactional
    public FolderDto createFolder(final CreateFolderRequest request) {
        final UserAccountEntity userAccount = getActiveUserAccount(request.userId());
        final FolderEntity parentFolder = getOptionalParentFolder(request.parentId(), userAccount.getId(), null);
        final String name = ServiceValidationUtils.normalizeRequiredText(request.name(), ApiMessageKey.NAME_REQUIRED);

        assertFolderNameAvailable(userAccount.getId(), request.parentId(), name, null);

        final FolderEntity entity = new FolderEntity();
        entity.setUserId(userAccount.getId());
        entity.setParentId(request.parentId());
        entity.setName(name);
        entity.setDescription(ServiceValidationUtils.normalizeOptionalText(request.description()));
        entity.setDepth(resolveDepth(parentFolder));
        // Return the persisted folder.
        return FolderMapper.toDto(folderRepository.save(entity));
    }

    @Override
    @Transactional(readOnly = true)
    public FolderDto getFolder(final Long folderId) {
        // Return the requested active folder.
        return FolderMapper.toDto(getActiveFolder(folderId));
    }

    @Override
    @Transactional(readOnly = true)
    public List<FolderDto> getFolders(final Long userId, final Long parentId) {
        // Prefer the narrowest query when both owner and parent filters are present.
        if (userId != null && parentId != null) {
            // Return folders that belong to the requested user under the requested parent.
            return folderRepository.findAllByUserIdAndParentIdAndDeletedAtIsNullOrderByIdAsc(
                    ServiceValidationUtils.requirePositiveId(userId, ApiMessageKey.USER_ID_POSITIVE),
                    ServiceValidationUtils.requirePositiveId(parentId, ApiMessageKey.PARENT_ID_POSITIVE)
                )
                // Convert persisted folder rows into DTOs for the API layer.
                .stream()
                .map(FolderMapper::toDto)
                .toList();
        }

        // Fall back to an owner-only query when only the user filter is provided.
        if (userId != null) {
            // Return every active folder for the requested user.
            return folderRepository.findAllByUserIdAndDeletedAtIsNullOrderByIdAsc(
                    ServiceValidationUtils.requirePositiveId(userId, ApiMessageKey.USER_ID_POSITIVE)
                )
                // Convert persisted folder rows into DTOs for the API layer.
                .stream()
                .map(FolderMapper::toDto)
                .toList();
        }

        // Fall back to a parent-only query when only the parent filter is provided.
        if (parentId != null) {
            // Return every active child folder under the requested parent.
            return folderRepository.findAllByParentIdAndDeletedAtIsNullOrderByIdAsc(
                    ServiceValidationUtils.requirePositiveId(parentId, ApiMessageKey.PARENT_ID_POSITIVE)
                )
                // Convert persisted folder rows into DTOs for the API layer.
                .stream()
                .map(FolderMapper::toDto)
                .toList();
        }

        // Return every active folder when no filter is provided.
        return folderRepository.findAllByDeletedAtIsNullOrderByIdAsc()
            // Convert persisted folder rows into DTOs for the API layer.
            .stream()
            .map(FolderMapper::toDto)
            .toList();
    }

    @Override
    @Transactional
    public FolderDto updateFolder(final Long folderId, final UpdateFolderRequest request) {
        final FolderEntity entity = getActiveFolder(folderId);
        final FolderEntity parentFolder = getOptionalParentFolder(request.parentId(), entity.getUserId(), entity.getId());
        final String name = ServiceValidationUtils.normalizeRequiredText(request.name(), ApiMessageKey.NAME_REQUIRED);

        assertNoFolderCycle(entity.getId(), request.parentId());
        assertFolderNameAvailable(entity.getUserId(), request.parentId(), name, entity.getId());

        entity.setParentId(request.parentId());
        entity.setName(name);
        entity.setDescription(ServiceValidationUtils.normalizeOptionalText(request.description()));
        entity.setDepth(resolveDepth(parentFolder));
        final FolderEntity savedEntity = folderRepository.save(entity);
        updateChildDepths(savedEntity.getId(), savedEntity.getDepth());
        // Return the updated folder after child depths have been synchronized.
        return FolderMapper.toDto(savedEntity);
    }

    @Override
    @Transactional
    public void deleteFolder(final Long folderId) {
        final FolderEntity entity = getActiveFolder(folderId);

        // Block deletion while active child folders still exist.
        if (folderRepository.existsByParentIdAndDeletedAtIsNull(entity.getId())) {
            // Reject deletion when descendants would be orphaned.
            throw new ConflictException(ApiMessageKey.FOLDER_DELETE_HAS_CHILD_FOLDERS);
        }

        // Block deletion while active decks still depend on the folder.
        if (deckRepository.existsByFolderIdAndDeletedAtIsNull(entity.getId())) {
            // Reject deletion when the folder still contains active decks.
            throw new ConflictException(ApiMessageKey.FOLDER_DELETE_HAS_ACTIVE_DECKS);
        }

        entity.setDeletedAt(OffsetDateTime.now());
        folderRepository.save(entity);
    }

    private FolderEntity getActiveFolder(final Long folderId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(folderId, ApiMessageKey.FOLDER_ID_POSITIVE);
        // Return the active folder or fail when the row is missing or soft-deleted.
        return folderRepository.findByIdAndDeletedAtIsNull(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.FOLDER_NOT_FOUND, validatedId));
    }

    private UserAccountEntity getActiveUserAccount(final Long userId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(userId, ApiMessageKey.USER_ID_POSITIVE);
        // Return the active user that owns the folder tree.
        return userAccountRepository.findByIdAndDeletedAtIsNull(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.USER_ACCOUNT_NOT_FOUND, validatedId));
    }

    private FolderEntity getOptionalParentFolder(
        final Long parentId,
        final Long userId,
        final Long currentFolderId
    ) {
        // Return null when the folder is intended to live at the root level.
        if (parentId == null) {
            // Keep the folder at depth zero when no parent is provided.
            return null;
        }

        final FolderEntity parentFolder = getActiveFolder(parentId);

        // Reject parent folders that belong to another user.
        if (!Objects.equals(parentFolder.getUserId(), userId)) {
            // Stop cross-user folder parenting.
            throw new ConflictException(ApiMessageKey.FOLDER_PARENT_USER_MISMATCH);
        }

        // Reject a folder being assigned as its own direct parent.
        if (currentFolderId != null && Objects.equals(parentFolder.getId(), currentFolderId)) {
            // Stop immediate self-references in the folder tree.
            throw new ConflictException(ApiMessageKey.FOLDER_PARENT_SELF);
        }
        // Return the validated parent folder for depth calculation and persistence.
        return parentFolder;
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

    private void assertNoFolderCycle(final Long folderId, final Long parentId) {
        Long currentParentId = parentId;

        // Walk the parent chain to ensure the update does not create a cycle.
        while (currentParentId != null) {
            // Reject any ancestor chain that loops back to the current folder.
            if (Objects.equals(currentParentId, folderId)) {
                // Stop the update when the folder would become its own ancestor.
                throw new ConflictException(ApiMessageKey.FOLDER_CYCLE);
            }
            currentParentId = getActiveFolder(currentParentId).getParentId();
        }
    }

    private int resolveDepth(final FolderEntity parentFolder) {
        // Root folders always start at depth zero.
        if (parentFolder == null) {
            // Return the base depth for root folders.
            return 0;
        }
        // Return the next depth level under the resolved parent.
        return parentFolder.getDepth() + 1;
    }

    private void updateChildDepths(final Long parentFolderId, final Integer parentDepth) {
        final List<FolderEntity> childFolders = folderRepository.findAllByParentIdAndDeletedAtIsNullOrderByIdAsc(parentFolderId);

        // Cascade the new depth to each active child in the subtree.
        for (final FolderEntity childFolder : childFolders) {
            childFolder.setDepth(parentDepth + 1);
            final FolderEntity savedChildFolder = folderRepository.save(childFolder);
            updateChildDepths(savedChildFolder.getId(), savedChildFolder.getDepth());
        }
    }
}
