package com.memora.app.entity;

import com.memora.app.entity.common.AuditableEntity;
import com.memora.app.enums.review.ReviewOutcome;

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
@Table(name = "study_session_items", schema = "memora")
@NoArgsConstructor
public class StudySessionItemEntity extends AuditableEntity {

    @Column(name = "study_session_id", nullable = false)
    private Long studySessionId;

    @Column(name = "flashcard_id", nullable = false)
    private Long flashcardId;

    @Column(name = "sequence_index", nullable = false)
    private Integer sequenceIndex;

    @Column(name = "term_snapshot", nullable = false)
    private String termSnapshot;

    @Column(name = "meaning_snapshot", nullable = false)
    private String meaningSnapshot;

    @Column(name = "note_snapshot", nullable = false)
    private String noteSnapshot;

    @Column(name = "term_pronunciation_snapshot", nullable = false)
    private String termPronunciationSnapshot;

    @Column(name = "meaning_pronunciation_snapshot", nullable = false)
    private String meaningPronunciationSnapshot;

    @Enumerated(EnumType.STRING)
    @Column(name = "last_outcome", length = 20)
    private ReviewOutcome lastOutcome;

    @Column(name = "current_mode_completed", nullable = false)
    private boolean currentModeCompleted;

    @Column(name = "retry_pending", nullable = false)
    private boolean retryPending;

    @Column(name = "incorrect_attempt_count", nullable = false)
    private Integer incorrectAttemptCount;
}
