package com.memora.app.repository;

import java.util.List;
import java.util.Optional;

import com.memora.app.entity.UserAccountEntity;
import com.memora.app.enums.user_account.AccountStatus;

import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserAccountRepository extends JpaRepository<UserAccountEntity, Long> {

    Optional<UserAccountEntity> findByIdAndDeletedAtIsNull(Long userAccountId);

    List<UserAccountEntity> findAllByDeletedAtIsNull(Sort sort);

    List<UserAccountEntity> findAllByAccountStatusAndDeletedAtIsNull(AccountStatus accountStatus, Sort sort);

    boolean existsByUsernameIgnoreCaseAndDeletedAtIsNull(String username);

    boolean existsByUsernameIgnoreCaseAndDeletedAtIsNullAndIdNot(String username, Long userAccountId);

    boolean existsByEmailIgnoreCaseAndDeletedAtIsNull(String email);

    boolean existsByEmailIgnoreCaseAndDeletedAtIsNullAndIdNot(String email, Long userAccountId);

    Optional<UserAccountEntity> findByUsernameIgnoreCaseAndDeletedAtIsNull(String username);

    Optional<UserAccountEntity> findByEmailIgnoreCaseAndDeletedAtIsNull(String email);
}
