package com.ssafy.lovesol.domain.couple.service;

import com.ssafy.lovesol.domain.couple.dto.request.ConnectCoupleRequestDto;
import com.ssafy.lovesol.domain.couple.dto.request.CoupleCreateRequestDto;
import com.ssafy.lovesol.domain.couple.dto.request.CoupleUpdateRequestDto;
import com.ssafy.lovesol.domain.couple.dto.request.DDayRequestDto;
import com.ssafy.lovesol.domain.couple.dto.response.DDayResponseDto;
import com.ssafy.lovesol.domain.couple.dto.response.ResponseAccountInfoDto;
import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.user.entity.User;

import java.security.NoSuchAlgorithmException;
import java.util.List;
import java.util.Optional;

public interface CoupleService {

    long createCouple(CoupleCreateRequestDto coupleDto);
    String getCoupleInfo(long userId);

    boolean cutCouple(long coupleId);
    Couple getCoupleInfoByUserId(String userId);

    Couple getCoupleInfoByCouplId(long coupleId);
    boolean connectCouple(ConnectCoupleRequestDto coupleDto,long coupleId) throws NoSuchAlgorithmException;
    ResponseAccountInfoDto getAccountTotal(long coupleId);
    int getCoupleAnniversary(Long coupleId);
    List<Couple> getAllCouple();
    DDayResponseDto registDDay(DDayRequestDto dDayRequestDto);
    DDayResponseDto getDDay(Long coupleId);

    void saveCouple(Couple couple);

}

