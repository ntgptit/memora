package com.memora.app.dto.response.flashcard;

import com.memora.app.dto.common.AuditDto;

public record FlashcardResponse(
    Long id,
    Long deckId,
    String term,
    String meaning,
    String frontLangCode,
    String backLangCode,
    String pronunciation,
    String note,
    boolean bookmarked,
    AuditDto audit
) {
}




