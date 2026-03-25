package com.memora.app.dto.response.flashcard;

import com.memora.app.dto.common.AuditDto;

public record FlashcardResponse(
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




