package com.memora.app.repository;

import java.util.List;
import java.util.Optional;

import com.memora.app.entity.FlashcardLanguageEntity;
import com.memora.app.enums.FlashcardSide;

import org.springframework.data.jpa.repository.JpaRepository;

public interface FlashcardLanguageRepository extends JpaRepository<FlashcardLanguageEntity, Long> {

    Optional<FlashcardLanguageEntity> findById(Long flashcardLanguageId);

    List<FlashcardLanguageEntity> findAllByOrderByIdAsc();

    List<FlashcardLanguageEntity> findAllByFlashcardIdOrderByIdAsc(Long flashcardId);

    boolean existsByFlashcardIdAndSide(Long flashcardId, FlashcardSide side);

    boolean existsByFlashcardIdAndSideAndIdNot(Long flashcardId, FlashcardSide side, Long flashcardLanguageId);

    long removeById(Long flashcardLanguageId);

    long removeByFlashcardId(Long flashcardId);
}
