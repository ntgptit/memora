package com.memora.app.service.impl;

import java.util.List;
import java.util.Locale;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.response.flashcard.FlashcardResponse;
import com.memora.app.entity.FlashcardEntity;
import com.memora.app.entity.FlashcardLanguageEntity;
import com.memora.app.enums.flashcard.FlashcardSide;
import com.memora.app.enums.flashcard.FlashcardSortField;
import com.memora.app.mapper.FlashcardMapper;
import com.memora.app.repository.FlashcardLanguageRepository;
import com.memora.app.util.ServiceValidationUtils;

import jakarta.persistence.criteria.Predicate;

import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;

final class FlashcardQuerySupport {

    private static final int DEFAULT_PAGE = 0;
    private static final int DEFAULT_SIZE = 20;
    private static final int MAX_PAGE_SIZE = 100;

    private FlashcardQuerySupport() {
    }

    static FlashcardResponse toResponse(
        final FlashcardEntity entity,
        final FlashcardLanguageRepository flashcardLanguageRepository,
        final FlashcardMapper flashcardMapper
    ) {
        final List<FlashcardLanguageEntity> languageEntities =
            flashcardLanguageRepository.findAllByFlashcardIdOrderByIdAsc(entity.getId());
        final FlashcardLanguageEntity frontLanguage = findLanguage(languageEntities, FlashcardSide.TERM);
        final FlashcardLanguageEntity backLanguage = findLanguage(languageEntities, FlashcardSide.MEANING);
        final String pronunciation = frontLanguage != null
            ? frontLanguage.getPronunciation()
            : backLanguage == null ? null : backLanguage.getPronunciation();

        // Convert the persistence row into the contract response payload.
        return flashcardMapper.toDto(
            entity,
            frontLanguage == null ? null : frontLanguage.getLanguageCode(),
            backLanguage == null ? null : backLanguage.getLanguageCode(),
            pronunciation
        );
    }

    static void syncFlashcardLanguages(
        final Long flashcardId,
        final String frontLangCode,
        final String backLangCode,
        final FlashcardLanguageRepository flashcardLanguageRepository
    ) {
        final List<FlashcardLanguageEntity> existingLanguages =
            flashcardLanguageRepository.findAllByFlashcardIdOrderByIdAsc(flashcardId);
        upsertFlashcardLanguage(
            flashcardId,
            FlashcardSide.TERM,
            frontLangCode,
            existingLanguages,
            flashcardLanguageRepository
        );
        upsertFlashcardLanguage(
            flashcardId,
            FlashcardSide.MEANING,
            backLangCode,
            existingLanguages,
            flashcardLanguageRepository
        );
    }

    static Specification<FlashcardEntity> isActive() {
        // Hide soft-deleted flashcards from all list queries.
        return (root, query, builder) -> builder.isNull(root.get("deletedAt"));
    }

    static Specification<FlashcardEntity> hasDeckId(final Long deckId) {
        // Restrict flashcard queries to the requested deck scope.
        return (root, query, builder) -> builder.equal(root.get("deckId"), deckId);
    }

    static Specification<FlashcardEntity> hasSearchQuery(final String searchQuery) {
        final String normalizedSearchQuery = ServiceValidationUtils.normalizeOptionalNullableText(searchQuery);
        // Skip the search predicate when the caller does not provide a query.
        if (normalizedSearchQuery == null) {
            // Leave the surrounding specification chain unchanged.
            return null;
        }

        // Build a case-insensitive contains filter across the searchable text columns.
        return (root, query, builder) -> {
            final String likePattern = "%" + normalizedSearchQuery.toLowerCase(Locale.ROOT) + "%";
            final Predicate frontPredicate = builder.like(builder.lower(root.get("term")), likePattern);
            final Predicate backPredicate = builder.like(builder.lower(root.get("meaning")), likePattern);
            final Predicate notePredicate = builder.like(builder.lower(root.get("note")), likePattern);
            // Return rows that match any searchable field.
            return builder.or(frontPredicate, backPredicate, notePredicate);
        };
    }

    static Sort buildSort(final String sortBy, final String sortType) {
        final FlashcardSortField sortField = resolveSortField(sortBy);
        final Sort.Direction direction = resolveSortDirection(sortType);

        // Map contract sort fields to concrete entity columns.
        return switch (sortField) {
            case FRONT_TEXT -> Sort.by(new Sort.Order(direction, "term"), Sort.Order.asc("id"));
            case CREATED_AT -> Sort.by(new Sort.Order(direction, "createdAt"), Sort.Order.asc("id"));
            case UPDATED_AT -> Sort.by(new Sort.Order(direction, "updatedAt"), Sort.Order.asc("id"));
        };
    }

    static int normalizePage(final Integer page) {
        // Clamp missing or negative page requests to the first page.
        if (page == null || page < 0) {
            // Return the default page index for invalid input.
            return DEFAULT_PAGE;
        }
        // Return the validated page index.
        return page;
    }

    static int normalizeSize(final Integer size) {
        // Clamp missing or non-positive size requests to the default page size.
        if (size == null || size <= 0) {
            // Return the default page size for invalid input.
            return DEFAULT_SIZE;
        }
        // Return the requested size while enforcing the upper bound.
        return Math.min(size, MAX_PAGE_SIZE);
    }

    private static FlashcardLanguageEntity findLanguage(
        final List<FlashcardLanguageEntity> languageEntities,
        final FlashcardSide side
    ) {
        // Scan the loaded side rows and return the matching one when present.
        return languageEntities.stream()
            .filter(languageEntity -> languageEntity.getSide() == side)
            .findFirst()
            .orElse(null);
    }

    private static void upsertFlashcardLanguage(
        final Long flashcardId,
        final FlashcardSide side,
        final String languageCode,
        final List<FlashcardLanguageEntity> existingLanguages,
        final FlashcardLanguageRepository flashcardLanguageRepository
    ) {
        final String normalizedLanguageCode = ServiceValidationUtils.normalizeOptionalNullableText(languageCode);
        final FlashcardLanguageEntity existingLanguage = findLanguage(existingLanguages, side);

        // Remove the side row when the caller clears the language code.
        if (normalizedLanguageCode == null) {
            // Use the repository's delete-by-id path to keep the cleanup explicit.
            if (existingLanguage != null) {
                flashcardLanguageRepository.removeById(existingLanguage.getId());
            }
            // Nothing else to persist for this side.
            return;
        }

        // Create the side row when it does not exist yet.
        if (existingLanguage == null) {
            final FlashcardLanguageEntity entity = new FlashcardLanguageEntity();
            entity.setFlashcardId(flashcardId);
            entity.setSide(side);
            entity.setLanguageCode(normalizedLanguageCode);
            entity.setPronunciation("");
            flashcardLanguageRepository.save(entity);
            // New side row has been created successfully.
            return;
        }

        existingLanguage.setLanguageCode(normalizedLanguageCode);
        // Update the existing side row in place.
        flashcardLanguageRepository.save(existingLanguage);
    }

    private static FlashcardSortField resolveSortField(final String sortBy) {
        // Default missing sort requests to the front-text field.
        if (sortBy == null) {
            // Return the contract default sort field.
            return FlashcardSortField.FRONT_TEXT;
        }

        try {
            // Return the requested sort field when the input is valid.
            return FlashcardSortField.valueOf(sortBy.toUpperCase(Locale.ROOT));
        } catch (final IllegalArgumentException exception) {
            // Fall back to the default field when the client sends an unknown value.
            return FlashcardSortField.FRONT_TEXT;
        }
    }

    private static Sort.Direction resolveSortDirection(final String sortType) {
        // Default missing sort direction requests to ascending order.
        if (sortType == null) {
            // Return the default contract sort direction.
            return Sort.Direction.ASC;
        }

        try {
            // Return the requested direction when the input is valid.
            return Sort.Direction.valueOf(sortType.toUpperCase(Locale.ROOT));
        } catch (final IllegalArgumentException exception) {
            // Fall back to ascending order when the client sends an unknown value.
            return Sort.Direction.ASC;
        }
    }
}



