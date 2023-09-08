package com.ssafy.lovesol.domain.bank.service;

import com.ssafy.lovesol.domain.bank.entity.Account;
import com.ssafy.lovesol.domain.bank.entity.Transaction;

import java.time.LocalDateTime;
import java.util.List;

public interface TransactionService {

    void registTransactionInfo(Transaction transaction);

    List<Transaction>  findTransactionsDetail(LocalDateTime transactionAt, Account account);
}
