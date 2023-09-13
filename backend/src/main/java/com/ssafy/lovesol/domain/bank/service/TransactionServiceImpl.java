package com.ssafy.lovesol.domain.bank.service;


import com.ssafy.lovesol.domain.bank.dto.response.GetTransactionResponseDto;
import com.ssafy.lovesol.domain.bank.entity.Account;
import com.ssafy.lovesol.domain.bank.entity.Transaction;
import com.ssafy.lovesol.domain.bank.repository.AccountRepository;
import com.ssafy.lovesol.domain.bank.repository.TransactionRepository;
import com.ssafy.lovesol.domain.couple.dto.request.SendCoupleAmountRequestDto;
import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.repository.CoupleRepository;
import com.ssafy.lovesol.domain.couple.service.CoupleService;
import com.ssafy.lovesol.domain.user.entity.User;
import com.ssafy.lovesol.domain.user.service.UserService;
import com.ssafy.lovesol.global.exception.NotExistAccountException;
import com.ssafy.lovesol.global.exception.NotExistCoupleException;
import com.ssafy.lovesol.global.util.CommonHttpSend;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@Service
public class TransactionServiceImpl  implements TransactionService{
    private final TransactionRepository transactionRepository;
    private final AccountRepository accountRepository;
    private final CoupleRepository coupleRepository;
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

    @Override
    public int findTransactionOne(Long coupleId) {
        Couple couple = coupleRepository.findById(coupleId).orElseThrow(NotExistCoupleException::new);
        log.info("커플 조회");
        Account account = accountRepository.findByAccountNumber(couple.getCommonAccount()).orElseThrow(NotExistAccountException::new);
        log.info("계좌 조회");
        Transaction transaction = transactionRepository.findByAccount(account);
        int category = 0;
        if (transaction != null) {
            String branchName = transaction.getBranchName();
            if (branchName.equals("식당")) category = 1;
            if (branchName.equals("커피숍")) category = 4;
            if (branchName.equals("쇼핑")) category = 7;
            if (branchName.equals("온라인")) category = 10;
        }
        return category;
    }

    @Override
    public List<GetTransactionResponseDto> getTransactionList(String accountNumber , int idx) {
        log.info("계좌의 거래내역 조회 (6건씩)");
        Pageable pageable = PageRequest.of(idx, 6, Sort.by(Sort.Order.desc("transactionAt")));
        Page<Transaction> transactions = transactionRepository.findByAccount_AccountNumberOrderByTransactionAtDesc(accountNumber, pageable);
        return transactions.getContent().stream().map(transaction -> transaction.toGetTransactionResponseDto()).toList();
    }
}
