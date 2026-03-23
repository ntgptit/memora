package com.memora.app.repository;

import java.util.List;
import java.util.Optional;

import com.memora.app.entity.FlashcardEntity;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface FlashcardRepository
    extends JpaRepository<FlashcardEntity, Long>, JpaSpecificationExecutor<FlashcardEntity> {

    Optional<FlashcardEntity> findByIdAndDeletedAtIsNull(Long flashcardId);

    Optional<FlashcardEntity> findByIdAndDeckIdAndDeletedAtIsNull(Long flashcardId, Long deckId);

    List<FlashcardEntity> findAllByDeletedAtIsNullOrderByIdAsc();

    List<FlashcardEntity> findAllByDeckIdAndDeletedAtIsNullOrderByIdAsc(Long deckId);

    boolean existsByDeckIdAndDeletedAtIsNull(Long deckId);

    long countByDeckIdAndDeletedAtIsNull(Long deckId);
}
