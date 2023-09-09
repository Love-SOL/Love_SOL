package com.ssafy.lovesol.domain.bank.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.lovesol.domain.bank.dto.TransferRequestDto;
import com.ssafy.lovesol.domain.bank.dto.request.TransferAuthRequestDto;
import com.ssafy.lovesol.domain.bank.entity.Account;
import com.ssafy.lovesol.domain.bank.entity.Transaction;
import com.ssafy.lovesol.domain.bank.repository.AccountRepository;
import com.ssafy.lovesol.domain.bank.repository.TransactionRepository;
import com.ssafy.lovesol.global.util.CommonHttpSend;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@Slf4j
@RequiredArgsConstructor
@Service
public class AccountServiceImpl implements AccountService{

    private final AccountRepository accountRepository;
    private final TransactionRepository transactionRepository;
    private final CommonHttpSend commonHttpSend;
    @Override
    @Transactional
    public int transferOneWon(TransferRequestDto transferRequestDto) {
        log.info("AccountServiceImpl_transferOneWon | 1원 이체 기능");

        String randomSixNumber = generateSixDigitNumber();
        Map<String, String> data = new HashMap<>();
        data.put("입금은행코드","088");
        data.put("입금계좌번호",transferRequestDto.getAccountNumber());
        data.put("입금통장메모",randomSixNumber);
        ResponseEntity<String> response = commonHttpSend.autoDeposit(data, "/auth/1transfer");

        try {
            // String 형태의 응답 본문을 JsonNode 객체로 변환
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(response.getBody());
            JsonNode successCodeNode = root.path("dataHeader").path("successCode");
            int successCode = successCodeNode.asInt();

            if(successCode == 0){
                Account account = accountRepository.findByAccountNumber(transferRequestDto.getAccountNumber()).orElseThrow();
                account.getTransactionList().add(Transaction.createTransaction(account,randomSixNumber,"SHINHAN",1,0));
            }

        } catch (Exception e) {
            // JSON 변환 중 발생하는 예외 처리
            e.printStackTrace();
        }

        return Integer.valueOf(randomSixNumber);
    }

    @Override
    public boolean transferOneWonAuth(TransferAuthRequestDto transferAuthRequestDto) {
        log.info("AccountServiceImpl_transferOneWonAuth | 1원 이체 인증번호 인증 기능");
        Transaction transaction = transactionRepository.findFirstByAccountAndDepositAmountOrderByTransactionAtDesc(accountRepository.findByAccountNumber(transferAuthRequestDto.getAccountNumber()).get(), 1).get();
        if(!transaction.getContent().equals(transferAuthRequestDto.getAuthNumber()))
            return false;
        return true;
    }

    private String generateSixDigitNumber() {
        Random random = new Random();
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < 6; i++) {
            int digit = random.nextInt(10);  // 0~9 사이의 난수 생성
            sb.append(digit);
        }

        return sb.toString();
    }
}
