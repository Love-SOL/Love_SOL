package com.ssafy.lovesol.domain.bank.service;


import com.ssafy.lovesol.domain.bank.entity.Account;
import com.ssafy.lovesol.domain.bank.entity.Transaction;
import com.ssafy.lovesol.domain.bank.repository.TransactionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@Service
public class TransactionServiceImpl  implements TransactionService{

    private final TransactionRepository transactionRepository;
    @Override
    @Transactional
    public void registTransactionInfo(Transaction transaction) {
        transactionRepository.save(transaction);
    }

    @Override
    public List<Transaction> findTransactionsDetail(LocalDateTime transactionAt, Account account) {
        return transactionRepository.findTransactionsByTransactionAtGreaterThanEqualsAndAccountEqualsAndWithdrawalAmountGreaterThan(transactionAt,account,0);
    }
}
