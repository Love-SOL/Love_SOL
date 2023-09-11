package com.ssafy.lovesol.domain.user.controller;


import com.ssafy.lovesol.domain.bank.entity.Account;
import com.ssafy.lovesol.domain.bank.entity.Transaction;
import com.ssafy.lovesol.domain.bank.service.AccountService;
import com.ssafy.lovesol.domain.bank.service.TransactionService;
import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.service.CoupleService;
import com.ssafy.lovesol.domain.user.entity.User;
import com.ssafy.lovesol.domain.user.service.UserService;
import com.ssafy.lovesol.global.util.CommonHttpSend;
import io.swagger.v3.core.util.Json;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.tomcat.util.json.JSONParser;
import org.json.JSONObject;
import org.springframework.http.*;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Optional;

@Slf4j
@Component
@RequiredArgsConstructor
public class UserScheduler {
    private final UserService userService;
    private final CoupleService coupleService;
    private final AccountService accountService;
    private final TransactionService transactionService;
    private final CommonHttpSend commonHttpSend;
    /*
     * 1. 금일로 설정된 인원들에 한정하여 입금을 시켜줘야한다.
     * */
    @Scheduled(cron = "0 35 13 * * *")
    public void deposit() {
        int day = LocalDateTime.now().getDayOfMonth();
        List<User> userList = userService.getAllUserByDepositAt(day);


        for(User user : userList){
            //입금 도착지
            String coupleAccount = coupleService.getCoupleInfo(user.getUserId());
            //유저 번호를 기반으로 couple 계좌를 찾아서 입금 api 동작 진행할 예정
            if(coupleAccount.equals("")) continue;

            String personalAccount = user.getPersonalAccount();


            HashMap<String,String> data = new HashMap<>();
            data.put("출금계좌번호",personalAccount);
            data.put("입금은행코드","088");
            data.put("입금계좌번호",coupleAccount);
            data.put("이체금액",Integer.toString(user.getAmount()));
            data.put("입금계좌통장메모","LoveSol");
            data.put("출금계좌통장메모","LoveSol");

            ResponseEntity<String> response = commonHttpSend.autoDeposit(data,"/transfer/krw");
            JSONObject result = new JSONObject(response.getBody());
            int successCode = result.getJSONObject("dataHeader").getInt("successCode");
            if(successCode != 0 ){
                log.info("입금을 실패 했습니다.");
                //여기서 notice를 추가해주자.
                continue;
            }
            LocalDateTime now = LocalDateTime.now();
            Transaction withdrawal = Transaction.builder()
                    .transactionAt(now)
                    .depositAmount(0)
                    .withdrawalAmount(user.getAmount())
                    .content("LoveSol")
                    .branchName("LoveSol 자동이체 출금")
                    .account(accountService.findAccountByAccountNumber(personalAccount))
                    .build();
            transactionService.registTransactionInfo(withdrawal);

            Account account = accountService.findAccountByAccountNumber(user.getPersonalAccount());
            account.setBalance(account.getBalance()-user.getAmount());
            accountService.accountSave(account);

            Transaction deposit = Transaction.builder()
                    .transactionAt(now)
                    .depositAmount(user.getAmount())
                    .withdrawalAmount(0)
                    .content("LoveSol")
                    .branchName("LoveSol 정기 입금")
                    .account(accountService.findAccountByAccountNumber(coupleAccount))
                    .build();
            transactionService.registTransactionInfo(deposit);
            Account couple = accountService.findAccountByAccountNumber(coupleAccount);
            couple.setBalance(couple.getBalance()+user.getAmount());

            accountService.accountSave(couple);


//            ResponseEntity<String> response =  CommonHttpSend.CommonHttpSend();

        }

        log.info(day + "일 Scheduler success");
    }


}
