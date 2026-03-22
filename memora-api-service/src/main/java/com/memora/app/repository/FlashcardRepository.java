package com.memora.app.repository;

import java.util.List;
import java.util.Optional;

import com.memora.app.entity.FlashcardEntity;

import org.springframework.data.jpa.repository.JpaRepository;

public interface FlashcardRepository extends JpaRepository<FlashcardEntity, Long> {

    Optional<FlashcardEntity> findByIdAndDeletedAtIsNull(Long flashcardId);

    List<FlashcardEntity> findAllByDeletedAtIsNullOrderByIdAsc();

    List<FlashcardEntity> findAllByDeckIdAndDeletedAtIsNullOrderByIdAsc(Long deckId);

    boolean existsByDeckIdAndDeletedAtIsNull(Long deckId);
}
