package com.memora.app.dto.response.flashcard;

import java.util.List;

public record FlashcardPageResponse(
    List<FlashcardResponse> items,
    int page,
    int size,
    long totalElements,
    int totalPages,
    boolean hasNext,
    boolean hasPrevious
) {
}



