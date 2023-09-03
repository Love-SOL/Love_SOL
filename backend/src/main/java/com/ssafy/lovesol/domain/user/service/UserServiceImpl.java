package com.ssafy.lovesol.domain.user.service;


import com.ssafy.lovesol.domain.user.dto.request.CreateUserAccountRequestDto;
import com.ssafy.lovesol.domain.user.dto.request.LoginRequestDto;
import com.ssafy.lovesol.domain.user.dto.request.UpdateUserAccountInfoDto;
import com.ssafy.lovesol.domain.user.entity.User;
import com.ssafy.lovesol.domain.user.repository.UserRepository;
import com.ssafy.lovesol.global.exception.NotExistAccountException;
import com.ssafy.lovesol.global.util.JwtService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Slf4j
@RequiredArgsConstructor
@Service
public class UserServiceImpl implements UserService{

    private final UserRepository userRepository;
    private final JwtService jwtService;

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
    public void login(LoginRequestDto loginRequestDto, HttpServletResponse response) {
        log.info("UserServiceImpl_login | 사용자 로그인 시도");
        User loginUser = userRepository.findByIdAndPassword(loginRequestDto.getId(), loginRequestDto.getPassword()).orElseThrow(NotExistAccountException::new);
        setToken(loginUser , response);
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
    public User getUserByUserId(long userId){
        Optional<User> user = userRepository.findByUserId(userId);
        if(user.isEmpty()){
            return null;
        }
        return user.get();
    }
}
