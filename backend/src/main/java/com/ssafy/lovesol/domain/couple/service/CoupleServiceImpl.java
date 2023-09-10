package com.ssafy.lovesol.domain.couple.service;

import com.ssafy.lovesol.domain.couple.dto.request.ConnectCoupleRequestDto;
import com.ssafy.lovesol.domain.couple.dto.request.CoupleCreateRequestDto;
import com.ssafy.lovesol.domain.couple.dto.response.ResponseAccountInfoDto;
import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.repository.CoupleRepository;
import com.ssafy.lovesol.domain.user.entity.User;
import com.ssafy.lovesol.domain.user.service.UserService;
import com.ssafy.lovesol.global.exception.NotExistCoupleException;
import com.ssafy.lovesol.global.util.CommonHttpSend;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.*;

@Slf4j
@RequiredArgsConstructor
@Service
public class CoupleServiceImpl implements CoupleService{
    private final CoupleRepository coupleRepository;
    private final UserService userService;
    private final CommonHttpSend commonHttpSend;
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

    @Override
    @Transactional
    public boolean connectCouple(ConnectCoupleRequestDto coupleDto, long coupleId) {
        Optional<Couple> coupleOption = coupleRepository.findById(coupleId);
        if(coupleOption.isEmpty()) {
            return false;
            //일단 커플이 없었기때문에 버그가 발생한 부분인데 에러처리는 나중에 해줘야한다.
        }
        Couple couple = coupleOption.get();
        if(coupleDto.getCheck()>0){
            //커플 연결 거절
            log.info("Coupler Service -> 커플 계좌 신청 반려");
            coupleRepository.delete(couple);
            return true;
        }
        if(coupleDto.getCheck()==0){
            User subOwner = userService.getUserById(coupleDto.getSubOnwerId());
            couple.setSubOwner(subOwner);
            return true;
        }
        log.info("connectCouple Error Happen");
        return false;
        //여기는 오류 발생
    }

    @Override
    public ResponseAccountInfoDto getAccountTotal(long coupleId) {
        Optional<Couple> op_couple = coupleRepository.findById(coupleId);
        if(op_couple.isEmpty()) return null;
        Couple couple = op_couple.get();
//          "지불가능잔액":"331551"
        Map<String, String> data = new HashMap<>();
        data.put("출금계좌번호",couple.getCommonAccount());
        ResponseEntity<String> response =  commonHttpSend.autoDeposit( data,"/account/balance/detail");
        return ResponseAccountInfoDto.builder()
                .coupleId(couple.getCoupleId())
                .coupleAccount(couple.getCommonAccount())
                .build();
    }

    @Override
    public int getCoupleAnniversary(Long coupleId) {
        log.info("CoupleServiceImpl_getCoupleAnniversary | 커플의 D-DAY 계산");
        Couple couple = coupleRepository.findById(coupleId).orElseThrow(NotExistCoupleException::new);
        return (int)ChronoUnit.DAYS.between(couple.getAnniversary(), LocalDate.now()) + 1;
    }

    @Override
    public List<Couple> getAllCouple(){
        return coupleRepository.findAll();
    }
}
