package com.memora.app.repository;

import java.util.List;
import java.util.Optional;

import com.memora.app.entity.FolderEntity;

import org.springframework.data.jpa.repository.JpaRepository;

public interface FolderRepository extends JpaRepository<FolderEntity, Long> {

    Optional<FolderEntity> findByIdAndDeletedAtIsNull(Long folderId);

    List<FolderEntity> findAllByDeletedAtIsNullOrderByIdAsc();

    List<FolderEntity> findAllByUserIdAndDeletedAtIsNullOrderByIdAsc(Long userId);

    List<FolderEntity> findAllByParentIdAndDeletedAtIsNullOrderByIdAsc(Long parentId);

    List<FolderEntity> findAllByUserIdAndParentIdAndDeletedAtIsNullOrderByIdAsc(Long userId, Long parentId);

    boolean existsByUserIdAndParentIdAndNameIgnoreCaseAndDeletedAtIsNull(Long userId, Long parentId, String name);

    boolean existsByUserIdAndParentIdAndNameIgnoreCaseAndDeletedAtIsNullAndIdNot(
        Long userId,
        Long parentId,
        String name,
        Long folderId
    );

    boolean existsByParentIdAndDeletedAtIsNull(Long parentId);
}
