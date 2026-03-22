package com.memora.app.entity;

import com.fasterxml.jackson.databind.JsonNode;
import com.memora.app.enums.StudySessionState;
import com.memora.app.enums.StudySessionType;

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
@Table(name = "study_sessions", schema = "memora")
@NoArgsConstructor
public class StudySessionEntity extends AuditableEntity {

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "deck_id", nullable = false)
    private Long deckId;

    @Column(name = "review_profile_id")
    private Long reviewProfileId;

    @Enumerated(EnumType.STRING)
    @Column(name = "session_type", nullable = false, length = 20)
    private StudySessionType sessionType;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "mode_plan", nullable = false, columnDefinition = "jsonb")
    private JsonNode modePlan;

    @Column(name = "current_mode_index", nullable = false)
    private Integer currentModeIndex;

    @Enumerated(EnumType.STRING)
    @Column(name = "session_state", nullable = false, length = 20)
    private StudySessionState sessionState;

    @Column(name = "current_item_index", nullable = false)
    private Integer currentItemIndex;
}
