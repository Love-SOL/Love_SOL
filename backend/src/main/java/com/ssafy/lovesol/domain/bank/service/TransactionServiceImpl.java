package com.ssafy.lovesol.domain.bank.service;


import com.ssafy.lovesol.domain.bank.entity.Account;
import com.ssafy.lovesol.domain.bank.entity.Transaction;
import com.ssafy.lovesol.domain.bank.repository.TransactionRepository;
import com.ssafy.lovesol.domain.couple.dto.request.SendCoupleAmountRequestDto;
import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.service.CoupleService;
import com.ssafy.lovesol.domain.user.entity.User;
import com.ssafy.lovesol.domain.user.service.UserService;
import com.ssafy.lovesol.global.util.CommonHttpSend;
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
    private final AccountService accountService;
    private final UserService userService;
    private final CoupleService coupleService;
    private final TransactionRepository transactionRepository;
    private final CommonHttpSend commonHttpSend;
    @Override
    @Transactional
    public void registTransactionInfo(Transaction transaction) {
        transactionRepository.save(transaction);
    }

    @Override
    public List<Transaction> findTransactionsDetail(LocalDateTime transactionAt, Account account) {
        return transactionRepository.findByTransactionAtList(transactionAt,account.getAccountNumber());
    }

    @Override
    public List<Transaction> findTransactionsDetailOrderBy(LocalDateTime transactionAt, Account account) {
        return transactionRepository.findTransactionsByTransactionAtGreaterThanEqualAndAccountEqualsOrderByTransactionAtDesc(transactionAt,account);
    }



}
