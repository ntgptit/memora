package com.memora.app.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.memora.app.entity.DeckReviewSettingsEntity;

public interface DeckReviewSettingsRepository extends JpaRepository<DeckReviewSettingsEntity, Long> {

    @Override
    Optional<DeckReviewSettingsEntity> findById(Long deckReviewSettingsId);

    Optional<DeckReviewSettingsEntity> findByDeckId(Long deckId);

    boolean existsByDeckId(Long deckId);

    boolean existsByDeckIdAndIdNot(Long deckId, Long deckReviewSettingsId);

    long removeById(Long deckReviewSettingsId);

    long removeByDeckId(Long deckId);
}
