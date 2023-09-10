package com.ssafy.lovesol.domain.user.service;


import com.ssafy.lovesol.domain.user.dto.request.*;
import com.ssafy.lovesol.domain.user.dto.response.LoginResponseDto;
import com.ssafy.lovesol.domain.user.entity.User;
import jakarta.servlet.http.HttpServletResponse;
import net.nurigo.java_sdk.exceptions.CoolsmsException;

import java.util.List;

public interface UserService {

    Long createUserAccount(CreateUserAccountRequestDto createUserAccountRequestDto);
    LoginResponseDto login(LoginRequestDto loginRequestDto, HttpServletResponse response);
    LoginResponseDto simpleLogin(SimpleLoginRequestDto simpleLoginRequestDto);
    void setToken(User user, HttpServletResponse response);
    List<User> getAllUserByDepositAt(int day);
    User getUserByUserId(long userId);
    User getUserById(String userId);

    void UpdateDepositInfo(UpdateUserAccountInfoDto userDto);
    String sendMessage(PhoneNumberRequestDto phoneNumberRequestDto) throws CoolsmsException;
}
