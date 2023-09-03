package com.ssafy.lovesol.domain.couple.service;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.repository.CoupleRepository;
import com.ssafy.lovesol.domain.user.entity.User;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Slf4j
@RequiredArgsConstructor
@Service
public class CoupleServiceImpl implements CoupleService{
    private final CoupleRepository coupleRepository;
    @Override
    public String getCoupleInfo(long userId) {
        log.info("getCoupleInfo : 커플 정보 도출");
        Optional<Couple> couple = coupleRepository.findBySubOwner(userId);
        if(!couple.isEmpty()){
            return couple.get().getCommonAccount();
        }
        couple = coupleRepository.findByOwner(userId);
        if(!couple.isEmpty()){
            return couple.get().getCommonAccount();
        }
        return "";
    }
}
