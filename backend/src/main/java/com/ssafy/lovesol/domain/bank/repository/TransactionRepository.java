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

    @Query(value = "SELECT t,a FROM Transaction t INNER JOIN Account a ON t.account.accountNumber = a.accountNumber WHERE t.account.accountNumber = :account" +
            "  AND DATETIME(t.transactionAt) >= :transactionAt" +
            "  AND t.withdrawalAmount != 0" +
            "ORDER BY t.transactionAt")
    List<Transaction> findByTransactionAtList(LocalDateTime transactionAt,String account);
    Optional<Transaction> findFirstByAccountAndDepositAmountOrderByTransactionAtDesc(Account account,int depositAmount);

    List<Transaction> findTransactionsByTransactionAtGreaterThanEqualAndAccountEqualsOrderByTransactionAtDesc(LocalDateTime transactionAt,Account account);
    Transaction findByAccount(Account account);
}


