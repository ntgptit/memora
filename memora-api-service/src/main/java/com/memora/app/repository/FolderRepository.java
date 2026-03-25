package com.memora.app.repository;

import java.util.List;
import java.util.Optional;

import com.memora.app.entity.FolderEntity;

import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface FolderRepository extends JpaRepository<FolderEntity, Long>, JpaSpecificationExecutor<FolderEntity> {

    Optional<FolderEntity> findByIdAndDeletedAtIsNull(Long folderId);

    List<FolderEntity> findAllByDeletedAtIsNull(Sort sort);

    List<FolderEntity> findAllByUserIdAndDeletedAtIsNull(Long userId, Sort sort);

    List<FolderEntity> findAllByParentIdAndDeletedAtIsNull(Long parentId, Sort sort);

    List<FolderEntity> findAllByUserIdAndParentIdAndDeletedAtIsNull(Long userId, Long parentId, Sort sort);

    boolean existsByUserIdAndParentIdAndNameIgnoreCaseAndDeletedAtIsNull(Long userId, Long parentId, String name);

    boolean existsByUserIdAndParentIdAndNameIgnoreCaseAndDeletedAtIsNullAndIdNot(
        Long userId,
        Long parentId,
        String name,
        Long folderId
    );

    boolean existsByParentIdAndDeletedAtIsNull(Long parentId);

    long countByParentIdAndDeletedAtIsNull(Long parentId);
}
