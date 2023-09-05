package com.ssafy.lovesol.domain.bank.repository;

import com.ssafy.lovesol.domain.bank.entity.Account;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface AccountRepository extends JpaRepository<Account,String> {
    Optional<Account> findByAccountNumber(String accountNumber);
}
