package com.memora.app.repository;

import java.util.List;
import java.util.Optional;

import com.memora.app.entity.DeckEntity;

import org.springframework.data.jpa.repository.JpaRepository;

public interface DeckRepository extends JpaRepository<DeckEntity, Long> {

    Optional<DeckEntity> findByIdAndDeletedAtIsNull(Long deckId);

    List<DeckEntity> findAllByDeletedAtIsNullOrderByIdAsc();

    List<DeckEntity> findAllByUserIdAndDeletedAtIsNullOrderByIdAsc(Long userId);

    List<DeckEntity> findAllByFolderIdAndDeletedAtIsNullOrderByIdAsc(Long folderId);

    List<DeckEntity> findAllByUserIdAndFolderIdAndDeletedAtIsNullOrderByIdAsc(Long userId, Long folderId);

    boolean existsByFolderIdAndNameIgnoreCaseAndDeletedAtIsNull(Long folderId, String name);

    boolean existsByFolderIdAndNameIgnoreCaseAndDeletedAtIsNullAndIdNot(Long folderId, String deckName, Long deckId);

    boolean existsByFolderIdAndDeletedAtIsNull(Long folderId);
}
