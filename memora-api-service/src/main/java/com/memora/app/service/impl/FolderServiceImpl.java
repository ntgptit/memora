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
        return FolderMapper.toDto(folderRepository.save(entity));
    }

    @Override
    @Transactional(readOnly = true)
    public FolderDto getFolder(final Long folderId) {
        return FolderMapper.toDto(getActiveFolder(folderId));
    }

    @Override
    @Transactional(readOnly = true)
    public List<FolderDto> getFolders(final Long userId, final Long parentId) {
        if (userId != null && parentId != null) {
            return folderRepository.findAllByUserIdAndParentIdAndDeletedAtIsNullOrderByIdAsc(
                    ServiceValidationUtils.requirePositiveId(userId, ApiMessageKey.USER_ID_POSITIVE),
                    ServiceValidationUtils.requirePositiveId(parentId, ApiMessageKey.PARENT_ID_POSITIVE)
                )
                .stream()
                .map(FolderMapper::toDto)
                .toList();
        }

        if (userId != null) {
            return folderRepository.findAllByUserIdAndDeletedAtIsNullOrderByIdAsc(
                    ServiceValidationUtils.requirePositiveId(userId, ApiMessageKey.USER_ID_POSITIVE)
                )
                .stream()
                .map(FolderMapper::toDto)
                .toList();
        }

        if (parentId != null) {
            return folderRepository.findAllByParentIdAndDeletedAtIsNullOrderByIdAsc(
                    ServiceValidationUtils.requirePositiveId(parentId, ApiMessageKey.PARENT_ID_POSITIVE)
                )
                .stream()
                .map(FolderMapper::toDto)
                .toList();
        }

        return folderRepository.findAllByDeletedAtIsNullOrderByIdAsc()
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
        return FolderMapper.toDto(savedEntity);
    }

    @Override
    @Transactional
    public void deleteFolder(final Long folderId) {
        final FolderEntity entity = getActiveFolder(folderId);

        if (folderRepository.existsByParentIdAndDeletedAtIsNull(entity.getId())) {
            throw new ConflictException(ApiMessageKey.FOLDER_DELETE_HAS_CHILD_FOLDERS);
        }

        if (deckRepository.existsByFolderIdAndDeletedAtIsNull(entity.getId())) {
            throw new ConflictException(ApiMessageKey.FOLDER_DELETE_HAS_ACTIVE_DECKS);
        }

        entity.setDeletedAt(OffsetDateTime.now());
        folderRepository.save(entity);
    }

    private FolderEntity getActiveFolder(final Long folderId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(folderId, ApiMessageKey.FOLDER_ID_POSITIVE);
        return folderRepository.findByIdAndDeletedAtIsNull(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.FOLDER_NOT_FOUND, validatedId));
    }

    private UserAccountEntity getActiveUserAccount(final Long userId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(userId, ApiMessageKey.USER_ID_POSITIVE);
        return userAccountRepository.findByIdAndDeletedAtIsNull(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.USER_ACCOUNT_NOT_FOUND, validatedId));
    }

    private FolderEntity getOptionalParentFolder(
        final Long parentId,
        final Long userId,
        final Long currentFolderId
    ) {
        if (parentId == null) {
            return null;
        }

        final FolderEntity parentFolder = getActiveFolder(parentId);

        if (!Objects.equals(parentFolder.getUserId(), userId)) {
            throw new ConflictException(ApiMessageKey.FOLDER_PARENT_USER_MISMATCH);
        }

        if (currentFolderId != null && Objects.equals(parentFolder.getId(), currentFolderId)) {
            throw new ConflictException(ApiMessageKey.FOLDER_PARENT_SELF);
        }
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

        if (alreadyExists) {
            throw new ConflictException(ApiMessageKey.FOLDER_NAME_EXISTS);
        }
    }

    private void assertNoFolderCycle(final Long folderId, final Long parentId) {
        Long currentParentId = parentId;

        while (currentParentId != null) {
            if (Objects.equals(currentParentId, folderId)) {
                throw new ConflictException(ApiMessageKey.FOLDER_CYCLE);
            }
            currentParentId = getActiveFolder(currentParentId).getParentId();
        }
    }

    private int resolveDepth(final FolderEntity parentFolder) {
        if (parentFolder == null) {
            return 0;
        }
        return parentFolder.getDepth() + 1;
    }

    private void updateChildDepths(final Long parentFolderId, final Integer parentDepth) {
        final List<FolderEntity> childFolders = folderRepository.findAllByParentIdAndDeletedAtIsNullOrderByIdAsc(parentFolderId);

        for (final FolderEntity childFolder : childFolders) {
            childFolder.setDepth(parentDepth + 1);
            final FolderEntity savedChildFolder = folderRepository.save(childFolder);
            updateChildDepths(savedChildFolder.getId(), savedChildFolder.getDepth());
        }
    }
}
