package com.ssafy.lovesol.global.fcm.Service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.ssafy.lovesol.domain.user.entity.User;
import com.ssafy.lovesol.domain.user.repository.UserRepository;
import com.ssafy.lovesol.global.fcm.dto.request.FcmRequestDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Optional;

@Slf4j
@RequiredArgsConstructor
@Service
public class FCMNotificationServiceImpl implements FCMNotificationService{

    private final FirebaseMessaging firebaseMessaging;
    private final UserRepository userRepository;
    @Override
    public boolean sendNotificationByToken(FcmRequestDto fcmRequestDto) {
        log.info("Fcm start");
        Optional<User> user = userRepository.findByUserId(fcmRequestDto.getTargetId());
        if(user.isPresent()){
            if(!user.get().getFcmToken().equals("")){
                Notification notification = Notification.builder()
                        .setBody(fcmRequestDto.getBody())
                        .setTitle(fcmRequestDto.getTitle())
                        .build();
                Message message = Message.builder()
                        .setToken(user.get().getFcmToken()).setNotification(notification).build();
                try {
                    firebaseMessaging.send(message);
                    log.info("성공적으로 전송되었습니다.");
                    return true;
                }catch (FirebaseMessagingException e){
                    e.printStackTrace();
                    log.info("전송 중 에러 발생");
                    return false;
                }
            }else{
                log.info("전송 실패 ! 원인 : 등록된 Token이 없습니다.");
                return false;
            }
        }else{
            log.info("등록된 사용자가 없습니다.");
            return false;
        }

    }

    @Override
    public boolean sendNotificationByToken(FcmRequestDto fcmRequestDto, Map<String, String> data) {
        log.info("Fcm start");
        Optional<User> user = userRepository.findByUserId(fcmRequestDto.getTargetId());
        if(user.isPresent()){
            if(!user.get().getFcmToken().equals("")){
                Notification notification = Notification.builder()
                        .setBody(fcmRequestDto.getBody())
                        .setTitle(fcmRequestDto.getTitle())
                        .build();
                Message message = Message.builder()
                        .setToken(user.get().getFcmToken()).setNotification(notification)
                        .putAllData(data)
                        .build();
                try {
                    firebaseMessaging.send(message);
                    log.info("성공적으로 전송되었습니다.");
                    return true;
                }catch (FirebaseMessagingException e){
                    e.printStackTrace();
                    log.info("전송 중 에러 발생");
                    return false;
                }
            }else{
                log.info("전송 실패 ! 원인 : 등록된 Token이 없습니다.");
                return false;
            }
        }else{
            log.info("등록된 사용자가 없습니다.");
            return false;
        }

    }
}
