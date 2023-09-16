package com.ssafy.lovesol.domain.bank.service;

import com.ssafy.lovesol.domain.bank.dto.request.TransferRequestDto;
import com.ssafy.lovesol.domain.bank.dto.request.TransferRequestDto;
import com.ssafy.lovesol.domain.bank.dto.request.TransferAuthRequestDto;

import com.ssafy.lovesol.domain.bank.dto.response.GetUserAccountsResponseDto;

import java.security.NoSuchAlgorithmException;
import com.ssafy.lovesol.domain.bank.entity.Account;
import com.ssafy.lovesol.domain.bank.entity.Transaction;
import net.nurigo.java_sdk.exceptions.CoolsmsException;

import java.time.LocalDateTime;
import java.util.List;

public interface AccountService {
    int transferOneWon(TransferRequestDto transferRequestDto) throws CoolsmsException;
    boolean transferOneWonAuth(TransferAuthRequestDto transferAuthRequestDto);

    List<GetUserAccountsResponseDto> getMyAccounts(Long userId,int type) throws NoSuchAlgorithmException;

    List<Transaction> findTransactionByAccount(String accountNumber);

    String HashEncrypt(String hashData) throws NoSuchAlgorithmException;

    List<Transaction> findTransactionByAccountToday(String accountNumber, LocalDateTime Now);

    Account findAccountByAccountNumber(String accountNumber);

    void accountSave(Account account);
    GetUserAccountsResponseDto getUserMainAccount(Long userId) throws NoSuchAlgorithmException;

    GetUserAccountsResponseDto getAccountInfo(String accountNumber);
}
