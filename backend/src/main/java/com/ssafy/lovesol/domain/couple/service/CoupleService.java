package com.ssafy.lovesol.domain.couple.service;

import com.ssafy.lovesol.domain.couple.dto.request.CoupleCreateRequestDto;
import com.ssafy.lovesol.domain.couple.dto.request.CoupleUpdateRequestDto;
import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.user.entity.User;

import java.util.Optional;

public interface CoupleService {

    void createCouple(CoupleCreateRequestDto coupleDto);
//    void updateCouple(CoupleUpdateRequestDto coupleDto);
    String getCoupleInfo(long userId);




}

