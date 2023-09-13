package com.ssafy.lovesol.global.fcm.Service;

import com.ssafy.lovesol.global.fcm.dto.request.FcmRequestDto;

import java.util.Map;

public interface FCMNotificationService {
    boolean sendNotificationByToken(FcmRequestDto fcmRequestDto);

    boolean sendNotificationByToken(FcmRequestDto fcmRequestDto, Map<String, String> data);
}
