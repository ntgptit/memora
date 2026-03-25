package com.memora.app.repository.specification;

import java.util.Locale;

import com.memora.app.entity.FolderEntity;
import com.memora.app.util.ServiceValidationUtils;

import jakarta.persistence.criteria.Predicate;

import org.apache.commons.lang3.StringUtils;
import org.springframework.data.jpa.domain.Specification;

public final class FolderSpecification {

    private FolderSpecification() {
    }

    public static Specification<FolderEntity> forListing(
        final Long userId,
        final Long parentId,
        final String searchQuery
    ) {
        return Specification.allOf(
            hasUserId(userId),
            hasParentId(parentId),
            hasSearchQuery(searchQuery)
        );
    }

    private static Specification<FolderEntity> hasUserId(final Long userId) {
        return (root, query, builder) -> builder.equal(root.get("userId"), userId);
    }

    private static Specification<FolderEntity> hasParentId(final Long parentId) {
        return (root, query, builder) -> parentId == null
            ? builder.isNull(root.get("parentId"))
            : builder.equal(root.get("parentId"), parentId);
    }

    private static Specification<FolderEntity> hasSearchQuery(final String searchQuery) {
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
