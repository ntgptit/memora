package com.memora.app.controller;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

import java.util.List;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.request.deck.CreateDeckRequest;
import com.memora.app.dto.request.deck.UpdateDeckRequest;
import com.memora.app.dto.response.deck.DeckResponse;
import com.memora.app.exception.BadRequestException;
import com.memora.app.exception.ConflictException;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.service.DeckService;
import com.memora.app.support.RecordFixtureFactory;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;

@ExtendWith(MockitoExtension.class)
class DeckControllerTest {

    @Mock
    private DeckService deckService;

    @InjectMocks
    private DeckController deckController;

    @Test
    void createDeckReturnsCreatedWhenServiceSucceeds() {
        final CreateDeckRequest request = RecordFixtureFactory.createRecord(CreateDeckRequest.class);
        final DeckResponse expectedResponse = RecordFixtureFactory.createRecord(DeckResponse.class);

        when(deckService.createDeck(1L, request)).thenReturn(expectedResponse);

        final var response = deckController.createDeck(1L, request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void createDeckPropagatesBadRequestScenario() {
        final CreateDeckRequest request = RecordFixtureFactory.createRecord(CreateDeckRequest.class);

        when(deckService.createDeck(1L, request)).thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> deckController.createDeck(1L, request)).isInstanceOf(BadRequestException.class);
    }

    @Test
    void createDeckPropagatesNotFoundScenario() {
        final CreateDeckRequest request = RecordFixtureFactory.createRecord(CreateDeckRequest.class);

        when(deckService.createDeck(1L, request)).thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> deckController.createDeck(1L, request)).isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void createDeckPropagatesConflictScenario() {
        final CreateDeckRequest request = RecordFixtureFactory.createRecord(CreateDeckRequest.class);

        when(deckService.createDeck(1L, request)).thenThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> deckController.createDeck(1L, request)).isInstanceOf(ConflictException.class);
    }

    @Test
    void getDeckReturnsOkWhenServiceSucceeds() {
        final DeckResponse expectedResponse = RecordFixtureFactory.createRecord(DeckResponse.class);

        when(deckService.getDeck(1L, 2L)).thenReturn(expectedResponse);

        final var response = deckController.getDeck(1L, 2L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void getDeckPropagatesNotFoundScenario() {
        when(deckService.getDeck(1L, 2L)).thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> deckController.getDeck(1L, 2L)).isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void getDecksReturnsOkWhenServiceSucceeds() {
        final List<DeckResponse> expectedResponse = List.of(RecordFixtureFactory.createRecord(DeckResponse.class));

        when(deckService.getDecks(1L, "query", "NAME", "ASC", 0, 20)).thenReturn(expectedResponse);

        final var response = deckController.getDecks(1L, "query", "NAME", "ASC", 0, 20);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void updateDeckReturnsOkWhenServiceSucceeds() {
        final UpdateDeckRequest request = RecordFixtureFactory.createRecord(UpdateDeckRequest.class);
        final DeckResponse expectedResponse = RecordFixtureFactory.createRecord(DeckResponse.class);

        when(deckService.updateDeck(1L, 2L, request)).thenReturn(expectedResponse);

        final var response = deckController.updateDeck(1L, 2L, request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void updateDeckPropagatesBadRequestScenario() {
        final UpdateDeckRequest request = RecordFixtureFactory.createRecord(UpdateDeckRequest.class);

        when(deckService.updateDeck(1L, 2L, request)).thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> deckController.updateDeck(1L, 2L, request)).isInstanceOf(BadRequestException.class);
    }

    @Test
    void updateDeckPropagatesNotFoundScenario() {
        final UpdateDeckRequest request = RecordFixtureFactory.createRecord(UpdateDeckRequest.class);

        when(deckService.updateDeck(1L, 2L, request))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> deckController.updateDeck(1L, 2L, request)).isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void updateDeckPropagatesConflictScenario() {
        final UpdateDeckRequest request = RecordFixtureFactory.createRecord(UpdateDeckRequest.class);

        when(deckService.updateDeck(1L, 2L, request)).thenThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> deckController.updateDeck(1L, 2L, request)).isInstanceOf(ConflictException.class);
    }

    @Test
    void deleteDeckReturnsNoContentWhenServiceSucceeds() {
        final var response = deckController.deleteDeck(1L, 2L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);
        assertThat(response.getBody()).isNull();
    }

    @Test
    void deleteDeckPropagatesNotFoundScenario() {
        org.mockito.Mockito.doThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR))
            .when(deckService)
            .deleteDeck(1L, 2L);

        assertThatThrownBy(() -> deckController.deleteDeck(1L, 2L)).isInstanceOf(ResourceNotFoundException.class);
    }
}
