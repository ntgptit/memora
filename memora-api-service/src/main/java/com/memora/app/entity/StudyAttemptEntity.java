package com.memora.app.entity;

import com.memora.app.enums.ReviewOutcome;
import com.memora.app.enums.StudyMode;

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
@Table(name = "study_attempts", schema = "memora")
@NoArgsConstructor
public class StudyAttemptEntity extends CreatedOnlyEntity {

    @Column(name = "study_session_id", nullable = false)
    private Long studySessionId;

    @Column(name = "flashcard_id", nullable = false)
    private Long flashcardId;

    @Enumerated(EnumType.STRING)
    @Column(name = "study_mode", nullable = false, length = 30)
    private StudyMode studyMode;

    @Enumerated(EnumType.STRING)
    @Column(name = "review_outcome", nullable = false, length = 20)
    private ReviewOutcome reviewOutcome;

    @Column(name = "submitted_answer")
    private String submittedAnswer;
}
