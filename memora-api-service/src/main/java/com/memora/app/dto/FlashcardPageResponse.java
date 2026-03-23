package com.memora.app.dto;

import java.util.List;

public record FlashcardPageResponse(
    List<FlashcardDto> items,
    int page,
    int size,
    long totalElements,
    int totalPages,
    boolean hasNext,
    boolean hasPrevious
) {
}
