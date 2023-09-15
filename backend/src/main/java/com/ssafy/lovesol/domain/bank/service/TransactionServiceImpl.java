package com.ssafy.lovesol.domain.bank.service;


import com.ssafy.lovesol.domain.bank.dto.response.GetTransactionByCategoryResponseDto;
import com.ssafy.lovesol.domain.bank.dto.response.GetTransactionResponseDto;
import com.ssafy.lovesol.domain.bank.entity.Account;
import com.ssafy.lovesol.domain.bank.entity.Transaction;
import com.ssafy.lovesol.domain.bank.repository.AccountRepository;
import com.ssafy.lovesol.domain.bank.repository.TransactionRepository;
import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.repository.CoupleRepository;
import com.ssafy.lovesol.global.exception.NotExistAccountException;
import com.ssafy.lovesol.global.exception.NotExistCoupleException;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@Service
public class TransactionServiceImpl  implements TransactionService{
    private final TransactionRepository transactionRepository;
    private final AccountRepository accountRepository;
    private final CoupleRepository coupleRepository;
    @Override
    public void registTransactionInfo(Transaction transaction) {
        transactionRepository.save(transaction);
    }

    @Override
    public List<Transaction> findTransactionsDetail(LocalDateTime transactionAt, Account account) {
        return transactionRepository.findByTransactionAtList(transactionAt,account.getAccountNumber());
    }

    @Override
    public List<Transaction> findTransactionsDetailOrderBy(LocalDateTime transactionAt, Account account) {
        return transactionRepository.findByAccountAndTransactionAtAfterAndWithdrawalAmountGreaterThan(account, transactionAt);
    }

    @Override
    public int findTransactionOne(Long coupleId) {
        Couple couple = coupleRepository.findById(coupleId).orElseThrow(NotExistCoupleException::new);
        log.info("커플 조회");
        Account account = accountRepository.findByAccountNumber(couple.getCommonAccount()).orElseThrow(NotExistAccountException::new);
        log.info("계좌 조회");
        Transaction transaction = transactionRepository.findFirstByAccount(account);
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
        log.info("계좌의 거래내역 조회 (8건씩)");
        Pageable pageable = PageRequest.of(idx, 6, Sort.by(Sort.Order.desc("transactionAt")));
        Page<Transaction> transactions = transactionRepository.findByAccount_AccountNumberOrderByTransactionAtDesc(accountNumber, pageable);
        return transactions.getContent().stream().map(transaction -> transaction.toGetTransactionResponseDto()).toList();
    }

    @Override
    public List<GetTransactionByCategoryResponseDto> getTransactionListByCategory(String accountNumber, int year,
        int month) {
        log.info("계좌의 특정 달의 카테고리별 통계 정보 ");
        // 특정년,달 계좌의 거래내역 조회
        // 카테고리별로 액수 구분
        HashMap<String,Integer> categoryMap = new HashMap<>();
        AtomicInteger totalAmount = new AtomicInteger(0);
        transactionRepository.findByAccountNumberAndYearAndMonth(accountNumber, year, month)
            .stream().forEach(transaction -> {
                categoryMap.put(transaction.getBranchName() , categoryMap.getOrDefault(transaction.getBranchName() , 0) + (int)transaction.getWithdrawalAmount());
                totalAmount.addAndGet((int)transaction.getWithdrawalAmount());
            });

        List<GetTransactionByCategoryResponseDto> dtoList = new ArrayList<>();
        for (String category : categoryMap.keySet()) {
            dtoList.add(GetTransactionByCategoryResponseDto.builder()
                        .amount(categoryMap.get(category))
                        .category(category)
                        .rate(Math.round(((double) categoryMap.get(category) / totalAmount.get()) * 100 * 10.0) / 10.0)
                        .build());
        }

        return dtoList.stream()
            .sorted(Comparator.comparing(GetTransactionByCategoryResponseDto::getAmount).reversed())
            .collect(Collectors.toList());
    }
}
