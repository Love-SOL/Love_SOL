package com.ssafy.lovesol.domain.bank.service;

import com.ssafy.lovesol.domain.bank.dto.TransferRequestDto;

public interface AccountService {
    int transferOneWon(TransferRequestDto transferRequestDto);


}
