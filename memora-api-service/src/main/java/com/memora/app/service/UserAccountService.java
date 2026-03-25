package com.memora.app.service;

import java.util.List;

import com.memora.app.dto.request.user_account.CreateUserAccountRequest;
import com.memora.app.dto.request.user_account.UpdateUserAccountRequest;
import com.memora.app.dto.response.user_account.UserAccountResponse;
import com.memora.app.enums.user_account.AccountStatus;

public interface UserAccountService {

    UserAccountResponse createUserAccount(CreateUserAccountRequest request);

    UserAccountResponse getUserAccount(Long userAccountId);

    List<UserAccountResponse> getUserAccounts(AccountStatus accountStatus);

    UserAccountResponse updateUserAccount(Long userAccountId, UpdateUserAccountRequest request);

    void deleteUserAccount(Long userAccountId);
}



