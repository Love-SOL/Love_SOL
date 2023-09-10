package com.ssafy.lovesol.global.util;

import com.ssafy.lovesol.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import lombok.extern.slf4j.Slf4j;
import net.nurigo.java_sdk.exceptions.CoolsmsException;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.nurigo.java_sdk.api.Message;
import net.nurigo.java_sdk.exceptions.CoolsmsException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.HashMap;
import java.util.Random;

@Slf4j
@Component
@RequiredArgsConstructor
public class SmsService {

    @Value("${SMS_KEY}")
    private String apiKey;

    @Value("${SMS_SECRET_KEY}")
    private String apiSecretKey;

    @Value("${SENDER}")
    private String sender;

    @Transactional
    public String sendAuthKey(String phoneNumber) throws CoolsmsException {
        log.info("SmsService_sendAuthenticationKey -> 휴대폰 번호로 인증번호 전송");
        Message coolsms = new Message(apiKey, apiSecretKey);
        String authenticationKey = CreateAuthenticationKey();
        coolsms.send(settingSms(phoneNumber, authenticationKey));

        return authenticationKey;
    }

    private HashMap<String, String> settingSms(String phoneNumber, String authenticationKey) {
        log.info("인증번호발송 SMS 설정");
        HashMap<String, String> params = new HashMap<String, String>();
        params.put("to", phoneNumber);    // 수신전화번호 (ajax로 view 화면에서 받아온 값으로 넘김)
        params.put("from", sender);    // 발신전화번호. 테스트시에는 발신,수신 둘다 본인 번호로 하면 됨
        params.put("type", "sms");
        params.put("text", "인증번호는 [" + authenticationKey + "] 입니다.");
        return params;
    }

    private String CreateAuthenticationKey(){
        log.info("인증키 생성");
        Random rand  = new Random();

        String authenticationKey ="";
        for(int i=0; i<6; i++) {
            String ran = Integer.toString(rand.nextInt(10));
            authenticationKey +=ran;
        }

        return authenticationKey;
    }
}