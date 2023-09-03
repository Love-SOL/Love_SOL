package com.ssafy.lovesol.domain.couple.service;

import com.ssafy.lovesol.domain.couple.dto.request.CoupleCreateRequestDto;
import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.repository.CoupleRepository;
import com.ssafy.lovesol.domain.user.entity.User;
import com.ssafy.lovesol.domain.user.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Slf4j
@RequiredArgsConstructor
@Service
public class CoupleServiceImpl implements CoupleService{
    private final CoupleRepository coupleRepository;
    private final UserService userService;
    @Override
    public long createCouple(CoupleCreateRequestDto coupleDto) {
        log.info("후보2");
        User user = userService.getUserById(coupleDto.getId());
        log.info("후보1");
        if(user == null) return -1;
        log.info("커플통장 생성 전 owner 객체 " + user.toString());
        Couple couple = coupleDto.toEntity(user);
        log.info(couple.toString());
        return coupleRepository.save(couple).getCoupleId();

    }


    @Override
    public String getCoupleInfo(long userId) {
        log.info("getCoupleInfo : 커플 계좌 정보 도출");
        User user = userService.getUserByUserId(userId);
        Optional<Couple> couple = coupleRepository.findBySubOwner(user);
        if(!couple.isEmpty()){
            return couple.get().getCommonAccount();
        }
        couple = coupleRepository.findByOwner(user);
        if(!couple.isEmpty()){
            return couple.get().getCommonAccount();
        }
        return "";
    }

    @Override
    public Couple getCoupleInfoByCoupleId(String userId) {
        log.info("getCoupleInfo : 커플 정보 return");
        User user = userService.getUserById(userId);
        Optional<Couple> couple = coupleRepository.findBySubOwner(user);
        if(!couple.isEmpty()){
            return couple.get();
        }
        couple = coupleRepository.findByOwner(user);
        if(!couple.isEmpty()){
            return couple.get();
        }
        return null;
    }


}
