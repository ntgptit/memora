package com.memora.app.controller;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.request.flashcard.CreateFlashcardRequest;
import com.memora.app.dto.request.flashcard.UpdateFlashcardRequest;
import com.memora.app.dto.response.flashcard.FlashcardPageResponse;
import com.memora.app.dto.response.flashcard.FlashcardResponse;
import com.memora.app.exception.BadRequestException;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.service.FlashcardService;
import com.memora.app.support.RecordFixtureFactory;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;

@ExtendWith(MockitoExtension.class)
class FlashcardControllerTest {

    @Mock
    private FlashcardService flashcardService;

    @InjectMocks
    private FlashcardController flashcardController;

    @Test
    void createFlashcardReturnsCreatedWhenServiceSucceeds() {
        final CreateFlashcardRequest request = RecordFixtureFactory.createRecord(CreateFlashcardRequest.class);
        final FlashcardResponse expectedResponse = RecordFixtureFactory.createRecord(FlashcardResponse.class);

        when(flashcardService.createFlashcard(1L, request)).thenReturn(expectedResponse);

        final var response = flashcardController.createFlashcard(1L, request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void createFlashcardPropagatesBadRequestScenario() {
        final CreateFlashcardRequest request = RecordFixtureFactory.createRecord(CreateFlashcardRequest.class);

        when(flashcardService.createFlashcard(1L, request)).thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> flashcardController.createFlashcard(1L, request))
            .isInstanceOf(BadRequestException.class);
    }

    @Test
    void createFlashcardPropagatesNotFoundScenario() {
        final CreateFlashcardRequest request = RecordFixtureFactory.createRecord(CreateFlashcardRequest.class);

        when(flashcardService.createFlashcard(1L, request))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> flashcardController.createFlashcard(1L, request))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void getFlashcardsReturnsOkWhenServiceSucceeds() {
        final FlashcardPageResponse expectedResponse = RecordFixtureFactory.createRecord(FlashcardPageResponse.class);

        when(flashcardService.getFlashcards(1L, "query", "CREATED_AT", "DESC", 0, 20)).thenReturn(expectedResponse);

        final var response = flashcardController.getFlashcards(1L, "query", "CREATED_AT", "DESC", 0, 20);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void getFlashcardsPropagatesNotFoundScenario() {
        when(flashcardService.getFlashcards(1L, "query", "CREATED_AT", "DESC", 0, 20))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> flashcardController.getFlashcards(1L, "query", "CREATED_AT", "DESC", 0, 20))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void updateFlashcardReturnsOkWhenServiceSucceeds() {
        final UpdateFlashcardRequest request = RecordFixtureFactory.createRecord(UpdateFlashcardRequest.class);
        final FlashcardResponse expectedResponse = RecordFixtureFactory.createRecord(FlashcardResponse.class);

        when(flashcardService.updateFlashcard(1L, 2L, request)).thenReturn(expectedResponse);

        final var response = flashcardController.updateFlashcard(1L, 2L, request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void updateFlashcardPropagatesBadRequestScenario() {
        final UpdateFlashcardRequest request = RecordFixtureFactory.createRecord(UpdateFlashcardRequest.class);

        when(flashcardService.updateFlashcard(1L, 2L, request))
            .thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> flashcardController.updateFlashcard(1L, 2L, request))
            .isInstanceOf(BadRequestException.class);
    }

    @Test
    void updateFlashcardPropagatesNotFoundScenario() {
        final UpdateFlashcardRequest request = RecordFixtureFactory.createRecord(UpdateFlashcardRequest.class);

        when(flashcardService.updateFlashcard(1L, 2L, request))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> flashcardController.updateFlashcard(1L, 2L, request))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void deleteFlashcardReturnsNoContentWhenServiceSucceeds() {
        final var response = flashcardController.deleteFlashcard(1L, 2L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);
        assertThat(response.getBody()).isNull();
    }

    @Test
    void deleteFlashcardPropagatesNotFoundScenario() {
        org.mockito.Mockito.doThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR))
            .when(flashcardService)
            .deleteFlashcard(1L, 2L);

        assertThatThrownBy(() -> flashcardController.deleteFlashcard(1L, 2L))
            .isInstanceOf(ResourceNotFoundException.class);
    }
}
