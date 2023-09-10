package com.ssafy.lovesol.domain.user.service;


import com.ssafy.lovesol.domain.couple.repository.CoupleRepository;
import com.ssafy.lovesol.domain.user.dto.request.*;
import com.ssafy.lovesol.domain.user.dto.response.LoginResponseDto;
import com.ssafy.lovesol.domain.user.entity.User;
import com.ssafy.lovesol.domain.user.repository.UserRepository;
import com.ssafy.lovesol.global.exception.NotExistUserException;
import com.ssafy.lovesol.global.util.JwtService;
import com.ssafy.lovesol.global.util.SmsService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.nurigo.java_sdk.exceptions.CoolsmsException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.Random;
import java.util.List;
import java.util.Optional;

@Slf4j
@RequiredArgsConstructor
@Service
public class UserServiceImpl implements UserService{

    private final UserRepository userRepository;
    private final JwtService jwtService;
    private final SmsService smsService;
    private final CoupleRepository coupleRepository;

    @Override
    public List<User> getAllUserByDepositAt (int day) {
        log.info("UserServiceImpl_getAllUserByDepositAt | 자동 입금 사용자 목록");
        return userRepository.findAllByDepositAt(day);
    }

    @Override
    public Long createUserAccount(CreateUserAccountRequestDto createUserAccountRequestDto) {
        log.info("UserServiceImpl_createUserAccount | 사용자 회원가입");
        return userRepository.save(createUserAccountRequestDto.toEntity()).getUserId();
    }

    @Override
    public LoginResponseDto login(LoginRequestDto loginRequestDto, HttpServletResponse response) {
        log.info("UserServiceImpl_login | 사용자 로그인 시도");
        User loginUser = userRepository.findByIdAndPassword(loginRequestDto.getId(), loginRequestDto.getPassword()).orElseThrow(NotExistUserException::new);
        setToken(loginUser , response);
        return loginUser.toLoginResponseDto(coupleRepository.findByOwnerOrSubOwner(loginUser,loginUser).get().getCoupleId());
    }

    @Override
    public LoginResponseDto simpleLogin(SimpleLoginRequestDto simpleLoginRequestDto) {
        log.info("UserServiceImpl_login | 사용자 간편 로그인");
        User user = userRepository.findByUserId(simpleLoginRequestDto.getUserId()).orElseThrow(NotExistUserException::new);
        if(!user.getSimplePassword().equals(simpleLoginRequestDto.getSimplePassword()))
            throw new NotExistUserException();
        return user.toLoginResponseDto(coupleRepository.findByOwnerOrSubOwner(user,user).get().getCoupleId());
    }

    @Override
    public void setToken(User user, HttpServletResponse response) {
        log.info("UserServiceImpl_setToken | 로그인 성공, 토큰 생성");
        String accessToken = jwtService.createAccessToken("userLoginId", user.getId());
        response.setHeader("Authorization","Bearer " + accessToken);
    }


    @Override
    public User getUserById(String id){
        Optional<User> user = userRepository.findById(id);
        if(user.isEmpty()){
            log.info("not found user");
            return null;
        }
        log.info("return Not null");
        return user.get();
    }

    @Override
    @Transactional
    public void UpdateDepositInfo(UpdateUserAccountInfoDto userDto) {
        Optional<User> user = userRepository.findById(userDto.getId());
        if(!user.isEmpty()) {
            log.info("isEmpty Check ");
            User use = user.get();
            use.setAutoDeposit(userDto.getDepositAt(),userDto.getAmount());
        }

    }

    @Override
    public String sendMessage(PhoneNumberRequestDto phoneNumberRequestDto) throws CoolsmsException {
        log.info("UserServiceImpl_sendMessage | 메시지 발송");
        return smsService.sendAuthKey(phoneNumberRequestDto.getPhoneNumber());
    }

    @Override
    @Transactional
    public void setSimplePassword(SimpleLoginRequestDto simplePassword) {
        log.info("UserServiceImpl_setSimplePassword | 간편 비밀번호 설정");
        userRepository.findByUserId(simplePassword.getUserId()).get().setSimplePassword(simplePassword.getSimplePassword());
    }


    @Override
    public User getUserByUserId(long userId){
        Optional<User> user = userRepository.findByUserId(userId);
        if(user.isEmpty()){
            return null;
        }
        return user.get();
    }

}
