package com.memora.app.controller;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

import java.util.List;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.request.folder.CreateFolderRequest;
import com.memora.app.dto.request.folder.RenameFolderRequest;
import com.memora.app.dto.request.folder.UpdateFolderRequest;
import com.memora.app.dto.response.folder.FolderResponse;
import com.memora.app.exception.BadRequestException;
import com.memora.app.exception.ConflictException;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.service.FolderService;
import com.memora.app.support.RecordFixtureFactory;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;

@ExtendWith(MockitoExtension.class)
class FolderControllerTest {

    @Mock
    private FolderService folderService;

    @InjectMocks
    private FolderController folderController;

    @Test
    void createFolderReturnsCreatedWhenServiceSucceeds() {
        final CreateFolderRequest request = RecordFixtureFactory.createRecord(CreateFolderRequest.class);
        final FolderResponse expectedResponse = RecordFixtureFactory.createRecord(FolderResponse.class);

        when(folderService.createFolder(request)).thenReturn(expectedResponse);

        final var response = folderController.createFolder(request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void createFolderPropagatesBadRequestScenario() {
        final CreateFolderRequest request = RecordFixtureFactory.createRecord(CreateFolderRequest.class);

        when(folderService.createFolder(request)).thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> folderController.createFolder(request)).isInstanceOf(BadRequestException.class);
    }

    @Test
    void createFolderPropagatesNotFoundScenario() {
        final CreateFolderRequest request = RecordFixtureFactory.createRecord(CreateFolderRequest.class);

        when(folderService.createFolder(request)).thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> folderController.createFolder(request)).isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void createFolderPropagatesConflictScenario() {
        final CreateFolderRequest request = RecordFixtureFactory.createRecord(CreateFolderRequest.class);

        when(folderService.createFolder(request)).thenThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> folderController.createFolder(request)).isInstanceOf(ConflictException.class);
    }

    @Test
    void getFolderReturnsOkWhenServiceSucceeds() {
        final FolderResponse expectedResponse = RecordFixtureFactory.createRecord(FolderResponse.class);

        when(folderService.getFolder(1L)).thenReturn(expectedResponse);

        final var response = folderController.getFolder(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void getFolderPropagatesNotFoundScenario() {
        when(folderService.getFolder(1L)).thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> folderController.getFolder(1L)).isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void getFoldersReturnsOkWhenServiceSucceeds() {
        final List<FolderResponse> expectedResponse = List.of(RecordFixtureFactory.createRecord(FolderResponse.class));

        when(folderService.getFolders(1L, "query", "NAME", "ASC", 0, 20)).thenReturn(expectedResponse);

        final var response = folderController.getFolders(1L, "query", "NAME", "ASC", 0, 20);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void renameFolderReturnsOkWhenServiceSucceeds() {
        final RenameFolderRequest request = RecordFixtureFactory.createRecord(RenameFolderRequest.class);
        final FolderResponse expectedResponse = RecordFixtureFactory.createRecord(FolderResponse.class);

        when(folderService.renameFolder(1L, request)).thenReturn(expectedResponse);

        final var response = folderController.renameFolder(1L, request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void renameFolderPropagatesBadRequestScenario() {
        final RenameFolderRequest request = RecordFixtureFactory.createRecord(RenameFolderRequest.class);

        when(folderService.renameFolder(1L, request)).thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> folderController.renameFolder(1L, request)).isInstanceOf(BadRequestException.class);
    }

    @Test
    void renameFolderPropagatesNotFoundScenario() {
        final RenameFolderRequest request = RecordFixtureFactory.createRecord(RenameFolderRequest.class);

        when(folderService.renameFolder(1L, request))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> folderController.renameFolder(1L, request))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void renameFolderPropagatesConflictScenario() {
        final RenameFolderRequest request = RecordFixtureFactory.createRecord(RenameFolderRequest.class);

        when(folderService.renameFolder(1L, request)).thenThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> folderController.renameFolder(1L, request)).isInstanceOf(ConflictException.class);
    }

    @Test
    void updateFolderReturnsOkWhenServiceSucceeds() {
        final UpdateFolderRequest request = RecordFixtureFactory.createRecord(UpdateFolderRequest.class);
        final FolderResponse expectedResponse = RecordFixtureFactory.createRecord(FolderResponse.class);

        when(folderService.updateFolder(1L, request)).thenReturn(expectedResponse);

        final var response = folderController.updateFolder(1L, request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void updateFolderPropagatesBadRequestScenario() {
        final UpdateFolderRequest request = RecordFixtureFactory.createRecord(UpdateFolderRequest.class);

        when(folderService.updateFolder(1L, request)).thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> folderController.updateFolder(1L, request)).isInstanceOf(BadRequestException.class);
    }

    @Test
    void updateFolderPropagatesNotFoundScenario() {
        final UpdateFolderRequest request = RecordFixtureFactory.createRecord(UpdateFolderRequest.class);

        when(folderService.updateFolder(1L, request))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> folderController.updateFolder(1L, request))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void updateFolderPropagatesConflictScenario() {
        final UpdateFolderRequest request = RecordFixtureFactory.createRecord(UpdateFolderRequest.class);

        when(folderService.updateFolder(1L, request)).thenThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> folderController.updateFolder(1L, request)).isInstanceOf(ConflictException.class);
    }

    @Test
    void deleteFolderReturnsNoContentWhenServiceSucceeds() {
        final var response = folderController.deleteFolder(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);
        assertThat(response.getBody()).isNull();
    }

    @Test
    void deleteFolderPropagatesNotFoundScenario() {
        org.mockito.Mockito.doThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR))
            .when(folderService)
            .deleteFolder(1L);

        assertThatThrownBy(() -> folderController.deleteFolder(1L)).isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void deleteFolderPropagatesConflictScenario() {
        org.mockito.Mockito.doThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR))
            .when(folderService)
            .deleteFolder(1L);

        assertThatThrownBy(() -> folderController.deleteFolder(1L)).isInstanceOf(ConflictException.class);
    }
}
