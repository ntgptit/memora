package com.memora.app.dto;

public record DeckDto(
    Long id,
    Long folderId,
    String name,
    String description,
    Long flashcardCount,
    AuditDto audit
) {
}
