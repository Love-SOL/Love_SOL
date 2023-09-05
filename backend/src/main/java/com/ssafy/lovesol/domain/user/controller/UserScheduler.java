package com.ssafy.lovesol.domain.user.controller;


import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.service.CoupleService;
import com.ssafy.lovesol.domain.user.entity.User;
import com.ssafy.lovesol.domain.user.service.UserService;
import com.ssafy.lovesol.global.util.CommonHttpSend;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONObject;
import org.springframework.http.*;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class UserScheduler {
    private final UserService userService;
    private final CoupleService coupleService;
    /*
    * 1. 금일로 설정된 인원들에 한정하여 입금을 시켜줘야한다.
    * */
    @Scheduled(cron = "0 30 13 * * *")
    public void deposit() {
        int day = LocalDateTime.now().getDayOfMonth();
        List<User> userList = userService.getAllUserByDepositAt(day);


        /*{
            "dataHeader": {
            "apikey": "2023_Shinhan_SSAFY_Hackathon"
        },
            "dataBody": {
            "출금계좌번호":"1102008999999",
                    "입금은행코드":"088",
                    "입금계좌번호":"110054999999",
                    "이체금액":"30000",
                    "입금계좌통장메모":"김신한",
                    "출금계좌통장메모":"회비"
        }
        }*/
        for(User user : userList){
            //입금 도착지
            String CoupleAccount = coupleService.getCoupleInfo(user.getUserId());
            //유저 번호를 기반으로 couple 계좌를 찾아서 입금 api 동작 진행할 예정
            if(CoupleAccount.equals("")) continue;

            String personalAccount = user.getPersonalAccount();

            HashMap<String,String> data = new HashMap<>();
            data.put("출금계좌번호",personalAccount);
            data.put("입금은행코드","088");
//            ResponseEntity<String> response =  CommonHttpSend.CommonHttpSend();

        }

        log.info(day + "일 Scheduler success");
    }


}
