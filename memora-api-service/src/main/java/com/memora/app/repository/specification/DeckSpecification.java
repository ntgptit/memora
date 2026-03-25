package com.memora.app.repository.specification;

import java.util.Locale;

import com.memora.app.entity.DeckEntity;
import com.memora.app.util.ServiceValidationUtils;

import jakarta.persistence.criteria.Predicate;

import org.apache.commons.lang3.StringUtils;
import org.springframework.data.jpa.domain.Specification;

public final class DeckSpecification {

    private DeckSpecification() {
    }

    public static Specification<DeckEntity> forFolderListing(final Long folderId, final String searchQuery) {
        return Specification.allOf(
            isActive(),
            hasFolderId(folderId),
            hasSearchQuery(searchQuery)
        );
    }

    private static Specification<DeckEntity> isActive() {
        return (root, query, builder) -> builder.isNull(root.get("deletedAt"));
    }

    private static Specification<DeckEntity> hasFolderId(final Long folderId) {
        return (root, query, builder) -> builder.equal(root.get("folderId"), folderId);
    }

    private static Specification<DeckEntity> hasSearchQuery(final String searchQuery) {
        final String normalizedSearchQuery = ServiceValidationUtils.normalizeOptionalNullableText(searchQuery);
        if (normalizedSearchQuery == null) {
            return null;
        }

        return (root, query, builder) -> {
            final String likePattern = StringUtils.wrap(normalizedSearchQuery.toLowerCase(Locale.ROOT), "%");
            final Predicate namePredicate = builder.like(builder.lower(root.get("name")), likePattern);
            final Predicate descriptionPredicate = builder.like(builder.lower(root.get("description")), likePattern);
            return builder.or(namePredicate, descriptionPredicate);
        };
    }
}
