package com.memora.app.repository;

import java.util.List;
import java.util.Optional;

import com.memora.app.entity.DeckEntity;

import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface DeckRepository extends JpaRepository<DeckEntity, Long>, JpaSpecificationExecutor<DeckEntity> {

    Optional<DeckEntity> findByIdAndDeletedAtIsNull(Long deckId);

    Optional<DeckEntity> findByIdAndFolderIdAndDeletedAtIsNull(Long deckId, Long folderId);

    List<DeckEntity> findAllByDeletedAtIsNull(Sort sort);

    List<DeckEntity> findAllByUserIdAndDeletedAtIsNull(Long userId, Sort sort);

    List<DeckEntity> findAllByFolderIdAndDeletedAtIsNull(Long folderId, Sort sort);

    List<DeckEntity> findAllByUserIdAndFolderIdAndDeletedAtIsNull(Long userId, Long folderId, Sort sort);

    boolean existsByFolderIdAndNameIgnoreCaseAndDeletedAtIsNull(Long folderId, String name);

    boolean existsByFolderIdAndNameIgnoreCaseAndDeletedAtIsNullAndIdNot(Long folderId, String deckName, Long deckId);

    boolean existsByFolderIdAndDeletedAtIsNull(Long folderId);

    long countByFolderIdAndDeletedAtIsNull(Long folderId);
}
