package com.ssafy.lovesol.domain.user.service;

import com.ssafy.lovesol.domain.user.dto.request.CreateUserAccountRequestDto;

public interface UserService {

    Long createUserAccount(CreateUserAccountRequestDto createUserAccountRequestDto);
}
