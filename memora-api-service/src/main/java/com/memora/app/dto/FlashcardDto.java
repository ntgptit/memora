package com.memora.app.dto;

public record FlashcardDto(
    Long id,
    Long deckId,
    String frontText,
    String backText,
    String frontLangCode,
    String backLangCode,
    String pronunciation,
    String note,
    boolean isBookmarked,
    AuditDto audit
) {
}
