package com.memora.app.dto.response.deck;

import com.memora.app.dto.common.AuditDto;

public record DeckResponse(
    Long id,
    Long folderId,
    String name,
    String description,
    Long flashcardCount,
    AuditDto audit
) {
}




