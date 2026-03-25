package com.memora.app.controller;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

import java.util.List;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.request.deck_review_settings.CreateDeckReviewSettingsRequest;
import com.memora.app.dto.request.deck_review_settings.UpdateDeckReviewSettingsRequest;
import com.memora.app.dto.response.deck_review_settings.DeckReviewSettingsResponse;
import com.memora.app.exception.BadRequestException;
import com.memora.app.exception.ConflictException;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.service.DeckReviewSettingsService;
import com.memora.app.support.RecordFixtureFactory;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;

@ExtendWith(MockitoExtension.class)
class DeckReviewSettingsControllerTest {

    @Mock
    private DeckReviewSettingsService deckReviewSettingsService;

    @InjectMocks
    private DeckReviewSettingsController deckReviewSettingsController;

    @Test
    void createDeckReviewSettingsReturnsCreatedWhenServiceSucceeds() {
        final CreateDeckReviewSettingsRequest request = RecordFixtureFactory.createRecord(
            CreateDeckReviewSettingsRequest.class
        );
        final DeckReviewSettingsResponse expectedResponse = RecordFixtureFactory.createRecord(
            DeckReviewSettingsResponse.class
        );

        when(deckReviewSettingsService.createDeckReviewSettings(request)).thenReturn(expectedResponse);

        final var response = deckReviewSettingsController.createDeckReviewSettings(request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void createDeckReviewSettingsPropagatesBadRequestScenario() {
        final CreateDeckReviewSettingsRequest request = RecordFixtureFactory.createRecord(
            CreateDeckReviewSettingsRequest.class
        );

        when(deckReviewSettingsService.createDeckReviewSettings(request))
            .thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> deckReviewSettingsController.createDeckReviewSettings(request))
            .isInstanceOf(BadRequestException.class);
    }

    @Test
    void createDeckReviewSettingsPropagatesNotFoundScenario() {
        final CreateDeckReviewSettingsRequest request = RecordFixtureFactory.createRecord(
            CreateDeckReviewSettingsRequest.class
        );

        when(deckReviewSettingsService.createDeckReviewSettings(request))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> deckReviewSettingsController.createDeckReviewSettings(request))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void createDeckReviewSettingsPropagatesConflictScenario() {
        final CreateDeckReviewSettingsRequest request = RecordFixtureFactory.createRecord(
            CreateDeckReviewSettingsRequest.class
        );

        when(deckReviewSettingsService.createDeckReviewSettings(request))
            .thenThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> deckReviewSettingsController.createDeckReviewSettings(request))
            .isInstanceOf(ConflictException.class);
    }

    @Test
    void getDeckReviewSettingsByIdReturnsOkWhenServiceSucceeds() {
        final DeckReviewSettingsResponse expectedResponse = RecordFixtureFactory.createRecord(
            DeckReviewSettingsResponse.class
        );

        when(deckReviewSettingsService.getDeckReviewSettingsById(1L)).thenReturn(expectedResponse);

        final var response = deckReviewSettingsController.getDeckReviewSettingsById(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void getDeckReviewSettingsByIdPropagatesNotFoundScenario() {
        when(deckReviewSettingsService.getDeckReviewSettingsById(1L))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> deckReviewSettingsController.getDeckReviewSettingsById(1L))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void getDeckReviewSettingsListReturnsOkWhenServiceSucceeds() {
        final List<DeckReviewSettingsResponse> expectedResponse = List.of(
            RecordFixtureFactory.createRecord(DeckReviewSettingsResponse.class)
        );

        when(deckReviewSettingsService.getDeckReviewSettingsList(1L)).thenReturn(expectedResponse);

        final var response = deckReviewSettingsController.getDeckReviewSettingsList(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void updateDeckReviewSettingsReturnsOkWhenServiceSucceeds() {
        final UpdateDeckReviewSettingsRequest request = RecordFixtureFactory.createRecord(
            UpdateDeckReviewSettingsRequest.class
        );
        final DeckReviewSettingsResponse expectedResponse = RecordFixtureFactory.createRecord(
            DeckReviewSettingsResponse.class
        );

        when(deckReviewSettingsService.updateDeckReviewSettings(1L, request)).thenReturn(expectedResponse);

        final var response = deckReviewSettingsController.updateDeckReviewSettings(1L, request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void updateDeckReviewSettingsPropagatesBadRequestScenario() {
        final UpdateDeckReviewSettingsRequest request = RecordFixtureFactory.createRecord(
            UpdateDeckReviewSettingsRequest.class
        );

        when(deckReviewSettingsService.updateDeckReviewSettings(1L, request))
            .thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> deckReviewSettingsController.updateDeckReviewSettings(1L, request))
            .isInstanceOf(BadRequestException.class);
    }

    @Test
    void updateDeckReviewSettingsPropagatesNotFoundScenario() {
        final UpdateDeckReviewSettingsRequest request = RecordFixtureFactory.createRecord(
            UpdateDeckReviewSettingsRequest.class
        );

        when(deckReviewSettingsService.updateDeckReviewSettings(1L, request))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> deckReviewSettingsController.updateDeckReviewSettings(1L, request))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void updateDeckReviewSettingsPropagatesConflictScenario() {
        final UpdateDeckReviewSettingsRequest request = RecordFixtureFactory.createRecord(
            UpdateDeckReviewSettingsRequest.class
        );

        when(deckReviewSettingsService.updateDeckReviewSettings(1L, request))
            .thenThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> deckReviewSettingsController.updateDeckReviewSettings(1L, request))
            .isInstanceOf(ConflictException.class);
    }

    @Test
    void deleteDeckReviewSettingsReturnsNoContentWhenServiceSucceeds() {
        final var response = deckReviewSettingsController.deleteDeckReviewSettings(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);
        assertThat(response.getBody()).isNull();
    }

    @Test
    void deleteDeckReviewSettingsPropagatesNotFoundScenario() {
        org.mockito.Mockito.doThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR))
            .when(deckReviewSettingsService)
            .deleteDeckReviewSettings(1L);

        assertThatThrownBy(() -> deckReviewSettingsController.deleteDeckReviewSettings(1L))
            .isInstanceOf(ResourceNotFoundException.class);
    }
}
