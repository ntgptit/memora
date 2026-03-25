package com.memora.app.controller;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

import java.util.List;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.request.flashcard_language.CreateFlashcardLanguageRequest;
import com.memora.app.dto.request.flashcard_language.UpdateFlashcardLanguageRequest;
import com.memora.app.dto.response.flashcard_language.FlashcardLanguageResponse;
import com.memora.app.exception.BadRequestException;
import com.memora.app.exception.ConflictException;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.service.FlashcardLanguageService;
import com.memora.app.support.RecordFixtureFactory;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;

@ExtendWith(MockitoExtension.class)
class FlashcardLanguageControllerTest {

    @Mock
    private FlashcardLanguageService flashcardLanguageService;

    @InjectMocks
    private FlashcardLanguageController flashcardLanguageController;

    @Test
    void createFlashcardLanguageReturnsCreatedWhenServiceSucceeds() {
        final CreateFlashcardLanguageRequest request = RecordFixtureFactory.createRecord(
            CreateFlashcardLanguageRequest.class
        );
        final FlashcardLanguageResponse expectedResponse = RecordFixtureFactory.createRecord(
            FlashcardLanguageResponse.class
        );

        when(flashcardLanguageService.createFlashcardLanguage(request)).thenReturn(expectedResponse);

        final var response = flashcardLanguageController.createFlashcardLanguage(request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void createFlashcardLanguagePropagatesBadRequestScenario() {
        final CreateFlashcardLanguageRequest request = RecordFixtureFactory.createRecord(
            CreateFlashcardLanguageRequest.class
        );

        when(flashcardLanguageService.createFlashcardLanguage(request))
            .thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> flashcardLanguageController.createFlashcardLanguage(request))
            .isInstanceOf(BadRequestException.class);
    }

    @Test
    void createFlashcardLanguagePropagatesNotFoundScenario() {
        final CreateFlashcardLanguageRequest request = RecordFixtureFactory.createRecord(
            CreateFlashcardLanguageRequest.class
        );

        when(flashcardLanguageService.createFlashcardLanguage(request))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> flashcardLanguageController.createFlashcardLanguage(request))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void createFlashcardLanguagePropagatesConflictScenario() {
        final CreateFlashcardLanguageRequest request = RecordFixtureFactory.createRecord(
            CreateFlashcardLanguageRequest.class
        );

        when(flashcardLanguageService.createFlashcardLanguage(request))
            .thenThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> flashcardLanguageController.createFlashcardLanguage(request))
            .isInstanceOf(ConflictException.class);
    }

    @Test
    void getFlashcardLanguageReturnsOkWhenServiceSucceeds() {
        final FlashcardLanguageResponse expectedResponse = RecordFixtureFactory.createRecord(
            FlashcardLanguageResponse.class
        );

        when(flashcardLanguageService.getFlashcardLanguage(1L)).thenReturn(expectedResponse);

        final var response = flashcardLanguageController.getFlashcardLanguage(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void getFlashcardLanguagePropagatesNotFoundScenario() {
        when(flashcardLanguageService.getFlashcardLanguage(1L))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> flashcardLanguageController.getFlashcardLanguage(1L))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void getFlashcardLanguagesReturnsOkWhenServiceSucceeds() {
        final List<FlashcardLanguageResponse> expectedResponse = List.of(
            RecordFixtureFactory.createRecord(FlashcardLanguageResponse.class)
        );

        when(flashcardLanguageService.getFlashcardLanguages(1L)).thenReturn(expectedResponse);

        final var response = flashcardLanguageController.getFlashcardLanguages(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void updateFlashcardLanguageReturnsOkWhenServiceSucceeds() {
        final UpdateFlashcardLanguageRequest request = RecordFixtureFactory.createRecord(
            UpdateFlashcardLanguageRequest.class
        );
        final FlashcardLanguageResponse expectedResponse = RecordFixtureFactory.createRecord(
            FlashcardLanguageResponse.class
        );

        when(flashcardLanguageService.updateFlashcardLanguage(1L, request)).thenReturn(expectedResponse);

        final var response = flashcardLanguageController.updateFlashcardLanguage(1L, request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void updateFlashcardLanguagePropagatesBadRequestScenario() {
        final UpdateFlashcardLanguageRequest request = RecordFixtureFactory.createRecord(
            UpdateFlashcardLanguageRequest.class
        );

        when(flashcardLanguageService.updateFlashcardLanguage(1L, request))
            .thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> flashcardLanguageController.updateFlashcardLanguage(1L, request))
            .isInstanceOf(BadRequestException.class);
    }

    @Test
    void updateFlashcardLanguagePropagatesNotFoundScenario() {
        final UpdateFlashcardLanguageRequest request = RecordFixtureFactory.createRecord(
            UpdateFlashcardLanguageRequest.class
        );

        when(flashcardLanguageService.updateFlashcardLanguage(1L, request))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> flashcardLanguageController.updateFlashcardLanguage(1L, request))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void updateFlashcardLanguagePropagatesConflictScenario() {
        final UpdateFlashcardLanguageRequest request = RecordFixtureFactory.createRecord(
            UpdateFlashcardLanguageRequest.class
        );

        when(flashcardLanguageService.updateFlashcardLanguage(1L, request))
            .thenThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> flashcardLanguageController.updateFlashcardLanguage(1L, request))
            .isInstanceOf(ConflictException.class);
    }

    @Test
    void deleteFlashcardLanguageReturnsNoContentWhenServiceSucceeds() {
        final var response = flashcardLanguageController.deleteFlashcardLanguage(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);
        assertThat(response.getBody()).isNull();
    }

    @Test
    void deleteFlashcardLanguagePropagatesNotFoundScenario() {
        org.mockito.Mockito.doThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR))
            .when(flashcardLanguageService)
            .deleteFlashcardLanguage(1L);

        assertThatThrownBy(() -> flashcardLanguageController.deleteFlashcardLanguage(1L))
            .isInstanceOf(ResourceNotFoundException.class);
    }
}
