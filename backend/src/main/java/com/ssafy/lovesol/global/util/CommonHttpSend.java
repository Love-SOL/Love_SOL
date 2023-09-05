package com.ssafy.lovesol.global.util;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.http.*;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;

public class CommonHttpSend {
    @Value("${springdoc.api.shinhan}")
    private static String key;
    public static ResponseEntity<String> autoDeposit(HashMap<String,String> data, String uri){


        String url = "https://shbhack.shinhan.com/v1" +uri;
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        JSONObject jsonObject = new JSONObject();
        HashMap<String, String> api = new HashMap<>();
        api.put("apikey",key);
        jsonObject.append("dateHeader",api.toString());
        jsonObject.append("dataBody", data.toString());

        HttpEntity<String> entity = new HttpEntity<String>(jsonObject.toString(), headers);
        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);
        return response;

    }
}
