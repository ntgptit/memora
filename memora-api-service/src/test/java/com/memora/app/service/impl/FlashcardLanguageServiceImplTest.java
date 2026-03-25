package com.memora.app.service.impl;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

import java.util.List;

import com.memora.app.dto.response.flashcard_language.FlashcardLanguageResponse;
import com.memora.app.entity.FlashcardLanguageEntity;
import com.memora.app.enums.flashcard.FlashcardSide;
import com.memora.app.mapper.FlashcardLanguageMapper;
import com.memora.app.repository.FlashcardLanguageRepository;
import com.memora.app.repository.FlashcardRepository;
import com.memora.app.support.RecordFixtureFactory;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Sort;

@ExtendWith(MockitoExtension.class)
class FlashcardLanguageServiceImplTest {

    @Mock
    private FlashcardLanguageRepository flashcardLanguageRepository;

    @Mock
    private FlashcardRepository flashcardRepository;

    @Mock
    private FlashcardLanguageMapper flashcardLanguageMapper;

    @InjectMocks
    private FlashcardLanguageServiceImpl flashcardLanguageService;

    @Test
    void getFlashcardLanguagesReturnsFlashcardScopedRowsWhenFlashcardIdProvided() {
        final FlashcardLanguageEntity entity = new FlashcardLanguageEntity();
        entity.setId(1L);
        entity.setFlashcardId(10L);
        entity.setSide(FlashcardSide.TERM);
        final FlashcardLanguageResponse expectedResponse = RecordFixtureFactory.createRecord(
            FlashcardLanguageResponse.class
        );

        when(flashcardLanguageRepository.findAllByFlashcardId(org.mockito.ArgumentMatchers.eq(10L), any(Sort.class)))
            .thenReturn(List.of(entity));
        when(flashcardLanguageMapper.toDto(entity)).thenReturn(expectedResponse);

        final List<FlashcardLanguageResponse> response = flashcardLanguageService.getFlashcardLanguages(10L);

        assertThat(response).containsExactly(expectedResponse);
    }
}
