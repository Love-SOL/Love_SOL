package com.ssafy.lovesol.domain.bank.service;

import com.ssafy.lovesol.domain.bank.dto.TransferRequestDto;
import com.ssafy.lovesol.domain.bank.dto.request.TransferAuthRequestDto;
import com.ssafy.lovesol.domain.bank.dto.response.GetUserAccountsResponseDto;

import java.security.NoSuchAlgorithmException;
import java.util.List;

public interface AccountService {
    int transferOneWon(TransferRequestDto transferRequestDto);
    boolean transferOneWonAuth(TransferAuthRequestDto transferAuthRequestDto);

    List<GetUserAccountsResponseDto> getMyAccounts(Long userId) throws NoSuchAlgorithmException;
}
