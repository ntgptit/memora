package com.memora.app.service;

import java.util.List;

import com.memora.app.dto.CreateUserAccountRequest;
import com.memora.app.dto.UpdateUserAccountRequest;
import com.memora.app.dto.UserAccountDto;
import com.memora.app.enums.AccountStatus;

public interface UserAccountService {

    UserAccountDto createUserAccount(CreateUserAccountRequest request);

    UserAccountDto getUserAccount(Long userAccountId);

    List<UserAccountDto> getUserAccounts(AccountStatus accountStatus);

    UserAccountDto updateUserAccount(Long userAccountId, UpdateUserAccountRequest request);

    void deleteUserAccount(Long userAccountId);
}
