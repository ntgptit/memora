package com.memora.app.entity;

import com.memora.app.entity.common.SoftDeletableAuditableEntity;
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
@Table(name = "flashcards", schema = "memora")
@SuperBuilder
@NoArgsConstructor
public class FlashcardEntity extends SoftDeletableAuditableEntity {

    @Column(name = "deck_id", nullable = false)
    private Long deckId;

    @Column(name = "term", nullable = false, length = 300)
    private String term;

    @Column(name = "meaning", nullable = false)
    private String meaning;

    @Column(name = "note", nullable = false)
    private String note;

    @Column(name = "is_bookmarked", nullable = false)
    private boolean bookmarked;
}
