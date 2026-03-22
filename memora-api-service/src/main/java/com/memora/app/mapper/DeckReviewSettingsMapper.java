package com.memora.app.mapper;

import com.memora.app.dto.DeckReviewSettingsDto;
import com.memora.app.entity.DeckReviewSettingsEntity;

import lombok.experimental.UtilityClass;

@UtilityClass
public class DeckReviewSettingsMapper {

    public DeckReviewSettingsDto toDto(final DeckReviewSettingsEntity entity) {
        if (entity == null) {
            return null;
        }
        return new DeckReviewSettingsDto(
            entity.getId(),
            entity.getDeckId(),
            entity.getReviewProfileId(),
            entity.getNewCardsPerDay(),
            entity.getReviewsPerDay(),
            entity.isBurySiblings(),
            entity.getLeechThreshold(),
            entity.isSuspendLeechCards(),
            entity.getCreatedAt(),
            entity.getUpdatedAt(),
            entity.getVersion()
        );
    }

    public DeckReviewSettingsEntity toEntity(final DeckReviewSettingsDto dto) {
        if (dto == null) {
            return null;
        }
        final DeckReviewSettingsEntity entity = new DeckReviewSettingsEntity();
        entity.setId(dto.id());
        entity.setDeckId(dto.deckId());
        entity.setReviewProfileId(dto.reviewProfileId());
        entity.setNewCardsPerDay(dto.newCardsPerDay());
        entity.setReviewsPerDay(dto.reviewsPerDay());
        entity.setBurySiblings(dto.burySiblings());
        entity.setLeechThreshold(dto.leechThreshold());
        entity.setSuspendLeechCards(dto.suspendLeechCards());
        entity.setCreatedAt(dto.createdAt());
        entity.setUpdatedAt(dto.updatedAt());
        entity.setVersion(dto.version());
        return entity;
    }
}
