package com.ssafy.lovesol.domain.datelog.service;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.repository.CoupleRepository;
import com.ssafy.lovesol.domain.couple.repository.PetRepository;
import com.ssafy.lovesol.domain.datelog.dto.request.InsertImageDto;
import com.ssafy.lovesol.domain.datelog.entity.DateLog;
import com.ssafy.lovesol.domain.datelog.entity.Image;
import com.ssafy.lovesol.domain.datelog.repository.DateLogRepository;
import com.ssafy.lovesol.global.exception.NotExistCoupleException;
import com.ssafy.lovesol.global.exception.NotExistDateLogException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;


@Slf4j
@RequiredArgsConstructor
@Service
public class DateLogServiceImpl implements DateLogService{
    DateLogRepository dateLogRepository;
    CoupleRepository coupleRepository;
    PetRepository petRepository;
    @Override
    public Long createDateLog(Long coupleId, LocalDateTime dateAt) {
        // 커플 정보가 존재하는지 검사한다.
        Couple couple = coupleRepository.findById(coupleId).orElseThrow(NotExistCoupleException::new);
        // 커플 객체와 날짜를 dateLog에 삽입한다.
        DateLog dateLog = DateLog.create(couple, dateAt);
        return dateLogRepository.save(dateLog).getDateLogId();
    }

    @Override
    public DateLog getDateLog(Long dateLogId) {
        // 해당 데이트 일기가 존재하는지 검사한다.
        // 데이트 로그에 속하는 날짜, 적립된 마일리지와 이미지 객체들을 조회한다.
        return dateLogRepository.findById(dateLogId).orElseThrow(NotExistDateLogException::new);
    }

    @Override
    @Transactional
    public void insertImage(Long dateLogId, InsertImageDto insertImage) {
        // 해당 데이트 일기가 존재하는지 검사한다.
        DateLog dateLog = dateLogRepository.findById(dateLogId).orElseThrow(NotExistDateLogException::new);

        // 데이트 로그, 이미지 url, 이미지 내용, 현재 작성된 시간을 가진 이미지 객체 생성
        Image image = Image.create(dateLog, insertImage.getImgUrl(), insertImage.getContent(), LocalDateTime.now());
        // 데이트 일기에 이미지를 삽입한다.
        dateLog.getImageList().add(image);
        // 데이트 일기에마일리지(exp)를 적립한다.
        dateLog.accumulateMileage(10);
        // TODO: 펫에게 마일리지를 적립한다.

    }
}
