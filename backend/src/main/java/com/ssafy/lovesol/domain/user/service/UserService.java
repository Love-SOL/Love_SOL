package com.ssafy.lovesol.domain.user.service;

import com.ssafy.lovesol.domain.user.dto.request.CreateUserAccountRequestDto;
import com.ssafy.lovesol.domain.user.dto.request.LoginRequestDto;
import com.ssafy.lovesol.domain.user.entity.User;
import jakarta.servlet.http.HttpServletResponse;

public interface UserService {

    Long createUserAccount(CreateUserAccountRequestDto createUserAccountRequestDto);
    void login(LoginRequestDto loginRequestDto, HttpServletResponse response);
    void setToken(User user, HttpServletResponse response);
}
