package com.memora.app.entity;

import com.memora.app.entity.common.AuditableEntity;
import com.memora.app.enums.flashcard.FlashcardSide;

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
@Table(name = "flashcard_languages", schema = "memora")
@NoArgsConstructor
public class FlashcardLanguageEntity extends AuditableEntity {

    @Column(name = "flashcard_id", nullable = false)
    private Long flashcardId;

    @Enumerated(EnumType.STRING)
    @Column(name = "side", nullable = false, length = 20)
    private FlashcardSide side;

    @Column(name = "language_code", nullable = false, length = 16)
    private String languageCode;

    @Column(name = "pronunciation", nullable = false, length = 400)
    private String pronunciation;
}
