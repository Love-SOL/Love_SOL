package com.ssafy.lovesol.domain.bank.service;


import com.ssafy.lovesol.domain.bank.entity.Transaction;
import com.ssafy.lovesol.domain.bank.repository.TransactionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
}
