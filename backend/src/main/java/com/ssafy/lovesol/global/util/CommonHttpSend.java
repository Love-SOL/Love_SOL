package com.ssafy.lovesol.global.util;

import lombok.extern.slf4j.Slf4j;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.http.*;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
@Slf4j
public class CommonHttpSend {
    @Value("${api.shinhan}")
    private static String key;
    public static ResponseEntity<String> autoDeposit(MultiValueMap<String, String> data, String uri){


        String url = "https://shbhack.shinhan.com/v1" +uri;
        log.info(url);
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        MultiValueMap<String, String> jsonObject = new LinkedMultiValueMap<>();
        MultiValueMap<String, String> api = new LinkedMultiValueMap<>();
        api.add("apikey","2023_Shinhan_SSAFY_Hackathon");
        log.info("2023_Shinhan_SSAFY_Hackathon");
        jsonObject.add("dataHeader",api.toString());
        jsonObject.add("dataBody", data.toString());
        log.info(jsonObject.toString());
        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(jsonObject, headers);
        log.info(entity.toString());
        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);
        return response;

    }
}
