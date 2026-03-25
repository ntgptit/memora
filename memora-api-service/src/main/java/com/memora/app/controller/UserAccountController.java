package com.memora.app.controller;

import java.util.List;

import com.memora.app.dto.request.user_account.CreateUserAccountRequest;
import com.memora.app.dto.request.user_account.UpdateUserAccountRequest;
import com.memora.app.dto.response.user_account.UserAccountResponse;
import com.memora.app.enums.user_account.AccountStatus;
import com.memora.app.service.UserAccountService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * REST endpoints for user account management.
 */
@Tag(name = "User Accounts", description = "CRUD APIs for Memora user accounts")
@RestController
@RequestMapping("/api/v1/user-accounts")
@RequiredArgsConstructor
public class UserAccountController {

    private final UserAccountService userAccountService;

    /**
     * Create a user account.
     *
     * @param request user account payload
     * @return created user account
     */
    @Operation(summary = "Create user account")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "User account created"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "409", description = "Username or email already exists")
    })
    @PostMapping
    public ResponseEntity<UserAccountResponse> createUserAccount(
        @Valid @RequestBody final CreateUserAccountRequest request
    ) {
        return ResponseEntity.status(HttpStatus.CREATED).body(userAccountService.createUserAccount(request));
    }

    /**
     * Get a user account by id.
     *
     * @param userAccountId user account identifier
     * @return user account details
     */
    @Operation(summary = "Get user account by id")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "User account found"),
        @ApiResponse(responseCode = "404", description = "User account not found")
    })
    @GetMapping("/{userAccountId}")
    public ResponseEntity<UserAccountResponse> getUserAccount(@PathVariable final Long userAccountId) {
        return ResponseEntity.ok(userAccountService.getUserAccount(userAccountId));
    }

    /**
     * List user accounts.
     *
     * @param accountStatus optional account status filter
     * @return matching user accounts
     */
    @Operation(summary = "List user accounts")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "User accounts loaded")
    })
    @GetMapping
    public ResponseEntity<List<UserAccountResponse>> getUserAccounts(
        @RequestParam(required = false) final AccountStatus accountStatus
    ) {
        return ResponseEntity.ok(userAccountService.getUserAccounts(accountStatus));
    }

    /**
     * Update an existing user account.
     *
     * @param userAccountId user account identifier
     * @param request updated user account payload
     * @return updated user account
     */
    @Operation(summary = "Update user account")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "User account updated"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "404", description = "User account not found"),
        @ApiResponse(responseCode = "409", description = "Username or email already exists")
    })
    @PutMapping("/{userAccountId}")
    public ResponseEntity<UserAccountResponse> updateUserAccount(
        @PathVariable final Long userAccountId,
        @Valid @RequestBody final UpdateUserAccountRequest request
    ) {
        return ResponseEntity.ok(userAccountService.updateUserAccount(userAccountId, request));
    }

    /**
     * Soft delete a user account.
     *
     * @param userAccountId user account identifier
     * @return empty response
     */
    @Operation(summary = "Delete user account")
    @ApiResponses({
        @ApiResponse(responseCode = "204", description = "User account deleted"),
        @ApiResponse(responseCode = "404", description = "User account not found"),
        @ApiResponse(responseCode = "409", description = "User account still owns active data")
    })
    @DeleteMapping("/{userAccountId}")
    public ResponseEntity<Void> deleteUserAccount(@PathVariable final Long userAccountId) {
        userAccountService.deleteUserAccount(userAccountId);
        return ResponseEntity.noContent().build();
    }
}



