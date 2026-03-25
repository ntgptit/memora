package com.memora.app.repository.specification;

import java.util.Locale;

import com.memora.app.entity.FlashcardEntity;
import com.memora.app.util.ServiceValidationUtils;

import jakarta.persistence.criteria.Predicate;

import org.apache.commons.lang3.StringUtils;
import org.springframework.data.jpa.domain.Specification;

public final class FlashcardSpecification {

    private FlashcardSpecification() {
    }

    public static Specification<FlashcardEntity> forDeckListing(final Long deckId, final String searchQuery) {
        return Specification.allOf(
            isActive(),
            hasDeckId(deckId),
            hasSearchQuery(searchQuery)
        );
    }

    private static Specification<FlashcardEntity> isActive() {
        return (root, query, builder) -> builder.isNull(root.get("deletedAt"));
    }

    private static Specification<FlashcardEntity> hasDeckId(final Long deckId) {
        return (root, query, builder) -> builder.equal(root.get("deckId"), deckId);
    }

    private static Specification<FlashcardEntity> hasSearchQuery(final String searchQuery) {
        final String normalizedSearchQuery = ServiceValidationUtils.normalizeOptionalNullableText(searchQuery);
        if (normalizedSearchQuery == null) {
            return null;
        }

        return (root, query, builder) -> {
            final String likePattern = StringUtils.wrap(normalizedSearchQuery.toLowerCase(Locale.ROOT), "%");
            final Predicate frontPredicate = builder.like(builder.lower(root.get("term")), likePattern);
            final Predicate backPredicate = builder.like(builder.lower(root.get("meaning")), likePattern);
            final Predicate notePredicate = builder.like(builder.lower(root.get("note")), likePattern);
            return builder.or(frontPredicate, backPredicate, notePredicate);
        };
    }
}
