package com.memora.app.entity;

import com.memora.app.entity.common.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;

@Getter
@Setter
@Entity
@Table(name = "deck_review_settings", schema = "memora")
@SuperBuilder
@NoArgsConstructor
public class DeckReviewSettingsEntity extends AuditableEntity {

    @Column(name = "deck_id", nullable = false)
    private Long deckId;

    @Column(name = "review_profile_id", nullable = false)
    private Long reviewProfileId;

    @Column(name = "new_cards_per_day", nullable = false)
    private Integer newCardsPerDay;

    @Column(name = "reviews_per_day", nullable = false)
    private Integer reviewsPerDay;

    @Column(name = "bury_siblings", nullable = false)
    private boolean burySiblings;

    @Column(name = "leech_threshold", nullable = false)
    private Integer leechThreshold;

    @Column(name = "suspend_leech_cards", nullable = false)
    private boolean suspendLeechCards;
}
