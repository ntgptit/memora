package com.memora.app.controller;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

import java.util.List;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.request.user_account.CreateUserAccountRequest;
import com.memora.app.dto.request.user_account.UpdateUserAccountRequest;
import com.memora.app.dto.response.user_account.UserAccountResponse;
import com.memora.app.enums.user_account.AccountStatus;
import com.memora.app.exception.BadRequestException;
import com.memora.app.exception.ConflictException;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.service.UserAccountService;
import com.memora.app.support.RecordFixtureFactory;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;

@ExtendWith(MockitoExtension.class)
class UserAccountControllerTest {

    @Mock
    private UserAccountService userAccountService;

    @InjectMocks
    private UserAccountController userAccountController;

    @Test
    void createUserAccountReturnsCreatedWhenServiceSucceeds() {
        final CreateUserAccountRequest request = RecordFixtureFactory.createRecord(CreateUserAccountRequest.class);
        final UserAccountResponse expectedResponse = RecordFixtureFactory.createRecord(UserAccountResponse.class);

        when(userAccountService.createUserAccount(request)).thenReturn(expectedResponse);

        final var response = userAccountController.createUserAccount(request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void createUserAccountPropagatesBadRequestScenario() {
        final CreateUserAccountRequest request = RecordFixtureFactory.createRecord(CreateUserAccountRequest.class);

        when(userAccountService.createUserAccount(request))
            .thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> userAccountController.createUserAccount(request))
            .isInstanceOf(BadRequestException.class);
    }

    @Test
    void createUserAccountPropagatesConflictScenario() {
        final CreateUserAccountRequest request = RecordFixtureFactory.createRecord(CreateUserAccountRequest.class);

        when(userAccountService.createUserAccount(request))
            .thenThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> userAccountController.createUserAccount(request))
            .isInstanceOf(ConflictException.class);
    }

    @Test
    void getUserAccountReturnsOkWhenServiceSucceeds() {
        final UserAccountResponse expectedResponse = RecordFixtureFactory.createRecord(UserAccountResponse.class);

        when(userAccountService.getUserAccount(1L)).thenReturn(expectedResponse);

        final var response = userAccountController.getUserAccount(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void getUserAccountPropagatesNotFoundScenario() {
        when(userAccountService.getUserAccount(1L))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> userAccountController.getUserAccount(1L))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void getUserAccountsReturnsOkWhenServiceSucceeds() {
        final List<UserAccountResponse> expectedResponse = List.of(
            RecordFixtureFactory.createRecord(UserAccountResponse.class)
        );

        when(userAccountService.getUserAccounts(AccountStatus.ACTIVE)).thenReturn(expectedResponse);

        final var response = userAccountController.getUserAccounts(AccountStatus.ACTIVE);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void updateUserAccountReturnsOkWhenServiceSucceeds() {
        final UpdateUserAccountRequest request = RecordFixtureFactory.createRecord(UpdateUserAccountRequest.class);
        final UserAccountResponse expectedResponse = RecordFixtureFactory.createRecord(UserAccountResponse.class);

        when(userAccountService.updateUserAccount(1L, request)).thenReturn(expectedResponse);

        final var response = userAccountController.updateUserAccount(1L, request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void updateUserAccountPropagatesBadRequestScenario() {
        final UpdateUserAccountRequest request = RecordFixtureFactory.createRecord(UpdateUserAccountRequest.class);

        when(userAccountService.updateUserAccount(1L, request))
            .thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> userAccountController.updateUserAccount(1L, request))
            .isInstanceOf(BadRequestException.class);
    }

    @Test
    void updateUserAccountPropagatesNotFoundScenario() {
        final UpdateUserAccountRequest request = RecordFixtureFactory.createRecord(UpdateUserAccountRequest.class);

        when(userAccountService.updateUserAccount(1L, request))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> userAccountController.updateUserAccount(1L, request))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void updateUserAccountPropagatesConflictScenario() {
        final UpdateUserAccountRequest request = RecordFixtureFactory.createRecord(UpdateUserAccountRequest.class);

        when(userAccountService.updateUserAccount(1L, request))
            .thenThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> userAccountController.updateUserAccount(1L, request))
            .isInstanceOf(ConflictException.class);
    }

    @Test
    void deleteUserAccountReturnsNoContentWhenServiceSucceeds() {
        final var response = userAccountController.deleteUserAccount(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);
        assertThat(response.getBody()).isNull();
    }

    @Test
    void deleteUserAccountPropagatesNotFoundScenario() {
        org.mockito.Mockito.doThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR))
            .when(userAccountService)
            .deleteUserAccount(1L);

        assertThatThrownBy(() -> userAccountController.deleteUserAccount(1L))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void deleteUserAccountPropagatesConflictScenario() {
        org.mockito.Mockito.doThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR))
            .when(userAccountService)
            .deleteUserAccount(1L);

        assertThatThrownBy(() -> userAccountController.deleteUserAccount(1L))
            .isInstanceOf(ConflictException.class);
    }
}
