package com.memora.app.entity;

import java.time.OffsetDateTime;

import com.fasterxml.jackson.databind.JsonNode;
import com.memora.app.enums.ReviewEventType;
import com.memora.app.enums.ReviewOutcome;
import com.memora.app.enums.ReviewStateStatus;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

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
@Table(name = "review_events", schema = "memora")
@NoArgsConstructor
public class ReviewEventEntity extends CreatedOnlyEntity {

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "flashcard_id", nullable = false)
    private Long flashcardId;

    @Column(name = "review_profile_id", nullable = false)
    private Long reviewProfileId;

    @Column(name = "study_attempt_id")
    private Long studyAttemptId;

    @Enumerated(EnumType.STRING)
    @Column(name = "event_type", nullable = false, length = 30)
    private ReviewEventType eventType;

    @Enumerated(EnumType.STRING)
    @Column(name = "state_status_before", length = 20)
    private ReviewStateStatus stateStatusBefore;

    @Enumerated(EnumType.STRING)
    @Column(name = "state_status_after", nullable = false, length = 20)
    private ReviewStateStatus stateStatusAfter;

    @Column(name = "box_before")
    private Integer boxBefore;

    @Column(name = "box_after", nullable = false)
    private Integer boxAfter;

    @Column(name = "due_at_before")
    private OffsetDateTime dueAtBefore;

    @Column(name = "due_at_after", nullable = false)
    private OffsetDateTime dueAtAfter;

    @Enumerated(EnumType.STRING)
    @Column(name = "review_outcome", length = 20)
    private ReviewOutcome reviewOutcome;

    @Column(name = "interval_seconds_applied")
    private Long intervalSecondsApplied;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "algorithm_snapshot_json", nullable = false, columnDefinition = "jsonb")
    private JsonNode algorithmSnapshotJson;
}
