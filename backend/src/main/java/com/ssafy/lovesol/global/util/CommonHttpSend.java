package com.ssafy.lovesol.global.util;

import org.json.JSONObject;
import org.springframework.http.*;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;

public class CommonHttpSend {
    public static ResponseEntity<String> autoDeposit(HashMap<String,String> data, String uri){
        String url = "https://shbhack.shinhan.com/v1" +uri;
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        JSONObject jsonObject = new JSONObject();
        jsonObject.append("dateHeader","{ apiky : 2_Hackathon}");
        jsonObject.append("dataBody", data.toString());

        HttpEntity<String> entity = new HttpEntity<String>(jsonObject.toString(), headers);
        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);
        return response;

    }
}
