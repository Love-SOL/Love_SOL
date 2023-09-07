package com.ssafy.lovesol.domain.couple.controller;


import com.ssafy.lovesol.domain.bank.service.AccountService;
import com.ssafy.lovesol.domain.bank.service.TransactionService;
import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.service.CoupleService;
import com.ssafy.lovesol.domain.couple.service.PetService;
import com.ssafy.lovesol.domain.datelog.service.DateLogService;
import com.ssafy.lovesol.domain.user.service.UserService;
import com.ssafy.lovesol.global.util.CommonHttpSend;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Component
@RequiredArgsConstructor
public class CoupleScheduler {
    private final CoupleService coupleService;
    private final UserService userService;
    private final PetService petService;
    private final DateLogService dateLogService;
    private final TransactionService transactionService;
    private final AccountService accountService;
    private final CommonHttpSend commonHttpSend;
    @Scheduled(cron = "0 */10 * * * *")
    public void searchTransaction(){
        List<Couple> coupleList = coupleService.getAllCouple();
        for(int i = 0 ; i < coupleList.size(); i++){
            Couple couple = coupleList.get(i);
            //여기서 결재 내역 조회한다.
            Map<String,String> data = new HashMap<>();
            data.put("계좌번호",couple.getCommonAccount());
            //계좌번호로 결재 내역 조회
            ResponseEntity<String> response = commonHttpSend.autoDeposit(data,"/search/transaction");
            JSONObject result = new JSONObject(response.getBody());
            //실제 결재내역을 정상적으로 받은 경우
            int successCode = result.getJSONObject("dataHeader").getInt("successCode");
            if(successCode!=0){
                log.info("계좌 내역 조회에 실패했습니다.");
                continue;
            }
            log.info("glgl");
        }
//        LocalDateTime
//
/*
1. 커플 리스트를 전부가져온다..?
2. 커플 Account를 기반으로 해당 계좌를 조회한다.
-> transaction에서 출금 계좌가 내 계좌인경우
*/
    }

}
