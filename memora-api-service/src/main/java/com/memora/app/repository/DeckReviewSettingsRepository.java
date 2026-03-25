package com.memora.app.repository;

import java.util.List;
import java.util.Optional;

import com.memora.app.entity.DeckReviewSettingsEntity;

import org.springframework.data.jpa.repository.JpaRepository;

public interface DeckReviewSettingsRepository extends JpaRepository<DeckReviewSettingsEntity, Long> {

    Optional<DeckReviewSettingsEntity> findById(Long deckReviewSettingsId);

    Optional<DeckReviewSettingsEntity> findByDeckId(Long deckId);

    boolean existsByDeckId(Long deckId);

    boolean existsByDeckIdAndIdNot(Long deckId, Long deckReviewSettingsId);

    long removeById(Long deckReviewSettingsId);

    long removeByDeckId(Long deckId);
}
