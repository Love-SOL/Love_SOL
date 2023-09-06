package com.ssafy.lovesol.domain.couple.service;

import com.ssafy.lovesol.domain.couple.dto.request.ConnectCoupleRequestDto;
import com.ssafy.lovesol.domain.couple.dto.request.CoupleCreateRequestDto;
import com.ssafy.lovesol.domain.couple.dto.request.CoupleUpdateRequestDto;
import com.ssafy.lovesol.domain.couple.dto.response.ResponseAccountInfoDto;
import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.user.entity.User;

import java.util.Optional;

public interface CoupleService {

    long createCouple(CoupleCreateRequestDto coupleDto);
//    void updateCouple(CoupleUpdateRequestDto coupleDto);
    String getCoupleInfo(long userId);

    Couple getCoupleInfoByCoupleId(String userId);


    boolean connectCouple(ConnectCoupleRequestDto coupleDto,long coupleId);
    ResponseAccountInfoDto getAccountTotal(long coupleId);
    int getCoupleAnniversary(Long coupleId);

}

