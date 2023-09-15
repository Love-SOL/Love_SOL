package com.ssafy.lovesol.global.util;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@Component
public class CommonHttpSend {

    @Value("${key.api.shinhan}")
    private String key;
    public ResponseEntity<String> shinhanAPI(Map<String,String> data, String uri){


        String url = "https://shbhack.shinhan.com/v1" +uri;
        log.info(url);
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        Map<String, Object> dataHeader = new HashMap<>();
        dataHeader.put("apikey", key);
        log.info("2023_Shinhan_SSAFY_Hackathon");

        Map<String, Object> payload = new HashMap<>();
        payload.put("dataHeader", dataHeader);
        payload.put("dataBody", data);


        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(payload, headers);
        log.info(entity.toString());
        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);
        return response;

    }
}
