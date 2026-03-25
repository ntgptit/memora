package com.memora.app.service.impl;

import java.util.Locale;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.response.folder.FolderResponse;
import com.memora.app.entity.FolderEntity;
import com.memora.app.enums.folder.FolderSortField;
import com.memora.app.mapper.FolderMapper;
import com.memora.app.repository.FolderRepository;
import com.memora.app.util.FolderColorResolver;
import com.memora.app.util.ServiceValidationUtils;

import jakarta.persistence.criteria.Predicate;

import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;

final class FolderQuerySupport {

    private static final int DEFAULT_PAGE = 0;
    private static final int DEFAULT_SIZE = 20;

    private FolderQuerySupport() {
    }

    static FolderResponse toResponse(
        final FolderEntity entity,
        final FolderRepository folderRepository,
        final FolderMapper folderMapper
    ) {
        // Map persistence fields to the API response and add derived values.
        return folderMapper.toDto(
            entity,
            FolderColorResolver.resolve(entity.getId()),
            folderRepository.countByParentIdAndDeletedAtIsNull(entity.getId())
        );
    }

    static Long normalizeParentId(final Long parentId) {
        // Keep root folders parentless.
        if (parentId == null) {
            // Return null when no parent filter or assignment is requested.
            return null;
        }
        // Validate the parent identifier when the caller provides one.
        return ServiceValidationUtils.requirePositiveId(parentId, ApiMessageKey.PARENT_ID_POSITIVE);
    }

    static Specification<FolderEntity> hasUserId(final Long userId) {
        // Restrict folder queries to the current workspace owner.
        return (root, query, builder) -> builder.equal(root.get("userId"), userId);
    }

    static Specification<FolderEntity> hasParentId(final Long parentId) {
        // Match the requested parent folder or root-level folders.
        return (root, query, builder) -> parentId == null
            ? builder.isNull(root.get("parentId"))
            : builder.equal(root.get("parentId"), parentId);
    }

    static Specification<FolderEntity> hasSearchQuery(final String searchQuery) {
        final String normalizedSearchQuery = ServiceValidationUtils.normalizeOptionalNullableText(searchQuery);
        // Skip search filtering when the caller does not provide a query.
        if (normalizedSearchQuery == null) {
            // Return null so the surrounding specification chain remains unchanged.
            return null;
        }
        // Search folder names and descriptions with a case-insensitive contains filter.
        return (root, query, builder) -> {
            final String likePattern = "%" + normalizedSearchQuery.toLowerCase(Locale.ROOT) + "%";
            final Predicate namePredicate = builder.like(builder.lower(root.get("name")), likePattern);
            final Predicate descriptionPredicate = builder.like(builder.lower(root.get("description")), likePattern);
            // Return folders that match either searchable text column.
            return builder.or(namePredicate, descriptionPredicate);
        };
    }

    static Sort buildSort(final String sortBy, final String sortType) {
        final FolderSortField sortField = FolderSortField.valueOf(
            sortBy == null ? FolderSortField.NAME.name() : sortBy.toUpperCase(Locale.ROOT)
        );
        final Sort.Direction direction = Sort.Direction.valueOf(
            sortType == null ? Sort.Direction.ASC.name() : sortType.toUpperCase(Locale.ROOT)
        );
        // Map contract sort fields to concrete entity properties.
        return switch (sortField) {
            case NAME -> Sort.by(new Sort.Order(direction, "name"), Sort.Order.asc("id"));
            case CREATED_AT -> Sort.by(new Sort.Order(direction, "createdAt"), Sort.Order.asc("id"));
            case UPDATED_AT -> Sort.by(new Sort.Order(direction, "updatedAt"), Sort.Order.asc("id"));
        };
    }

    static int normalizePage(final Integer page) {
        // Default missing page requests to the first page.
        return page == null ? DEFAULT_PAGE : page;
    }

    static int normalizeSize(final Integer size) {
        // Default missing size requests to a small page window.
        return size == null ? DEFAULT_SIZE : size;
    }
}



