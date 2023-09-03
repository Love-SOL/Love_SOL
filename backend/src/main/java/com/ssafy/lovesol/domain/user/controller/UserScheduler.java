package com.ssafy.lovesol.domain.user.controller;


import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.service.CoupleService;
import com.ssafy.lovesol.domain.user.entity.User;
import com.ssafy.lovesol.domain.user.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
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

        for(User user : userList){
            String CoupleAccount = coupleService.getCoupleInfo(user.getUserId());
            //유저 번호를 기반으로 couple 계좌를 찾아서 입금 api 동작 진행할 예정
            
        }

        log.info(day + "일 Scheduler success");
    }
}
