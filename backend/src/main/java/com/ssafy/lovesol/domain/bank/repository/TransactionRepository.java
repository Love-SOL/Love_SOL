package com.ssafy.lovesol.domain.bank.repository;

import com.ssafy.lovesol.domain.bank.entity.Account;
import com.ssafy.lovesol.domain.bank.entity.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface TransactionRepository extends JpaRepository<Transaction,Long> {
    Optional<Transaction> findByAccountAndDepositAmount(Account account,int depositAmount);

//    @Query(value = "select a from ")
//    List<Transaction> findAccountLocalDate(Long AccountId, LocalDateTime date);
    List<Transaction> findTransactionsByTransactionAtGreaterThanEqualAAndAccountEquals(LocalDateTime transactionAt,Account account);
//    List<Transaction> findTransactionsByAccountOrderBy
}
