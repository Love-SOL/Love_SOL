package com.ssafy.lovesol.domain.user.service;


import com.ssafy.lovesol.domain.user.dto.request.CreateUserAccountRequestDto;
import com.ssafy.lovesol.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@RequiredArgsConstructor
@Service
public class UserServiceImpl implements UserService{

    private final UserRepository userRepository;

    @Override
    public Long createUserAccount(CreateUserAccountRequestDto createUserAccountRequestDto) {
        log.info("UserServiceImpl_createUserAccount | 사용자 회원가입");
        return userRepository.save(createUserAccountRequestDto.toEntity()).getUserId();
    }
}
