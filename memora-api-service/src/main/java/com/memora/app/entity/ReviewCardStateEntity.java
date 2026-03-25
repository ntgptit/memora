package com.memora.app.entity;

import com.memora.app.entity.common.AuditableEntity;
import java.time.OffsetDateTime;

import com.memora.app.enums.review.ReviewOutcome;
import com.memora.app.enums.review.ReviewStateStatus;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "review_card_states", schema = "memora")
@NoArgsConstructor
public class ReviewCardStateEntity extends AuditableEntity {

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "flashcard_id", nullable = false)
    private Long flashcardId;

    @Column(name = "review_profile_id", nullable = false)
    private Long reviewProfileId;

    @Enumerated(EnumType.STRING)
    @Column(name = "state_status", nullable = false, length = 20)
    private ReviewStateStatus stateStatus;

    @Column(name = "current_box_number", nullable = false)
    private Integer currentBoxNumber;

    @Column(name = "due_at", nullable = false)
    private OffsetDateTime dueAt;

    @Column(name = "last_reviewed_at")
    private OffsetDateTime lastReviewedAt;

    @Enumerated(EnumType.STRING)
    @Column(name = "last_outcome", length = 20)
    private ReviewOutcome lastOutcome;

    @Column(name = "success_streak", nullable = false)
    private Integer successStreak;

    @Column(name = "lapse_count", nullable = false)
    private Integer lapseCount;

    @Column(name = "review_count", nullable = false)
    private Integer reviewCount;

    @Column(name = "suspended_at")
    private OffsetDateTime suspendedAt;
}
