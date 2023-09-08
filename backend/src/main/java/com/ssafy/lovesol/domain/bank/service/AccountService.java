package com.ssafy.lovesol.domain.bank.service;

import com.ssafy.lovesol.domain.bank.dto.TransferRequestDto;
import com.ssafy.lovesol.domain.bank.dto.request.TransferAuthRequestDto;
import com.ssafy.lovesol.domain.bank.entity.Account;
import com.ssafy.lovesol.domain.bank.entity.Transaction;

import java.time.LocalDateTime;
import java.util.List;

public interface AccountService {
    int transferOneWon(TransferRequestDto transferRequestDto);
    boolean transferOneWonAuth(TransferAuthRequestDto transferAuthRequestDto);

    List<Transaction> findTransactionByAccount(String accountNumber);

    List<Transaction> findTransactionByAccountToday(String accountNumber, LocalDateTime Now);

    Account findAccountByAccountNumber(String accountNumber);
}
