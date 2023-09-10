package com.ssafy.lovesol.global.fcm.Service;

import com.ssafy.lovesol.global.fcm.dto.request.FcmRequestDto;

public interface FCMNotificationService {
    boolean sendNotificationByToken(FcmRequestDto fcmRequestDto);
}
