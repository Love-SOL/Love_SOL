package com.ssafy.lovesol.domain.user.controller;


import com.ssafy.lovesol.domain.user.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@Component
@RequiredArgsConstructor
public class UserScheduler {

    private final UserService userService;
    //여기선 어차피 userService를 통해서 전부다 가져와서 진행하기때문에
    @Scheduled(cron = "0 30 13 * * *")
    public void deposit() {
        //

    }
}
