package com.ssafy.lovesol.domain.bank.service;

import com.ssafy.lovesol.domain.bank.dto.TransferRequestDto;
import com.ssafy.lovesol.domain.bank.dto.request.TransferAuthRequestDto;

public interface AccountService {
    int transferOneWon(TransferRequestDto transferRequestDto);
    boolean transferOneWonAuth(TransferAuthRequestDto transferAuthRequestDto);

}
