package com.memora.app.repository;

import java.util.List;
import java.util.Optional;

import com.memora.app.entity.UserAccountEntity;
import com.memora.app.enums.AccountStatus;

import org.springframework.data.jpa.repository.JpaRepository;

public interface UserAccountRepository extends JpaRepository<UserAccountEntity, Long> {

    Optional<UserAccountEntity> findByIdAndDeletedAtIsNull(Long userAccountId);

    Optional<UserAccountEntity> findFirstByAccountStatusAndDeletedAtIsNullOrderByIdAsc(AccountStatus accountStatus);

    Optional<UserAccountEntity> findFirstByDeletedAtIsNullOrderByIdAsc();

    List<UserAccountEntity> findAllByDeletedAtIsNullOrderByIdAsc();

    List<UserAccountEntity> findAllByAccountStatusAndDeletedAtIsNullOrderByIdAsc(AccountStatus accountStatus);

    boolean existsByUsernameIgnoreCaseAndDeletedAtIsNull(String username);

    boolean existsByUsernameIgnoreCaseAndDeletedAtIsNullAndIdNot(String username, Long userAccountId);

    boolean existsByEmailIgnoreCaseAndDeletedAtIsNull(String email);

    boolean existsByEmailIgnoreCaseAndDeletedAtIsNullAndIdNot(String email, Long userAccountId);

    Optional<UserAccountEntity> findByUsernameIgnoreCaseAndDeletedAtIsNull(String username);

    Optional<UserAccountEntity> findByEmailIgnoreCaseAndDeletedAtIsNull(String email);
}
