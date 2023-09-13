package com.ssafy.lovesol.domain.bank.repository;

import com.ssafy.lovesol.domain.bank.entity.Account;
import com.ssafy.lovesol.domain.bank.entity.Transaction;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface TransactionRepository extends JpaRepository<Transaction,Long> {
    Optional<Transaction> findByAccountAndDepositAmount(Account account,int depositAmount);

    @Query(value = "SELECT t,a FROM Transaction t INNER JOIN Account a ON t.account.accountNumber = a.accountNumber WHERE t.account.accountNumber = :account" +
            "  AND t.transactionAt >= :transactionAt" +
            "  AND t.withdrawalAmount != 0" +
            "ORDER BY t.transactionAt")
    List<Transaction> findByTransactionAtList(LocalDateTime transactionAt,String account);
    Optional<Transaction> findFirstByAccountAndDepositAmountOrderByTransactionAtDesc(Account account,int depositAmount);

    @Query("SELECT t FROM Transaction t WHERE t.account = :account AND t.transactionAt >= :transactionAt AND t.withdrawalAmount > 0")
    List<Transaction> findByAccountAndTransactionAtAfterAndWithdrawalAmountGreaterThan(Account account, LocalDateTime transactionAt);

    Page<Transaction> findByAccount_AccountNumberOrderByTransactionAtDesc(String accountNumber, Pageable pageable);

    Transaction findFirstByAccount(Account account);

    @Query("SELECT t " +
        "FROM Transaction t " +
        "WHERE t.account.accountNumber = :accountNumber " +
        "AND t.transactionType = 0" +
        "AND YEAR(t.transactionAt) = :year " +
        "AND MONTH(t.transactionAt) = :month")
    List<Transaction> findByAccountNumberAndYearAndMonth(@Param(value = "accountNumber") String accountNumber,@Param(value = "year") int year,@Param(value = "month") int month);
}


