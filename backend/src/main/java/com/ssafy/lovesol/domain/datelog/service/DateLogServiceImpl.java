package com.ssafy.lovesol.domain.datelog.service;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.repository.CoupleRepository;
import com.ssafy.lovesol.domain.datelog.entity.DateLog;
import com.ssafy.lovesol.domain.datelog.entity.Image;
import com.ssafy.lovesol.domain.datelog.repository.DateLogRepository;
import com.ssafy.lovesol.global.exception.NotExistDateLogException;
import com.ssafy.lovesol.global.response.ResponseResult;
import com.ssafy.lovesol.global.response.SingleResponseResult;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.Optional;


@Slf4j
@RequiredArgsConstructor
@Service
public class DateLogServiceImpl implements DateLogService{
    DateLogRepository dateLogRepository;
    CoupleRepository coupleRepository;
    @Override
    public Long createDateLog(Long coupleId, LocalDateTime dateAt) {
        // TODO: 커플 not exist 예외 생성하기
        Couple couple = coupleRepository.findById(coupleId).orElseThrow(NotExistDateLogException::new);
        DateLog dateLog = new DateLog();
        // 커플 객체와 날짜를 dateLog에 삽입한다.
        dateLog.setCouple(couple);
        dateLog.setDateAt(dateAt);
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
    public void insertImage(Long dateLogId, Image image) {
        // 해당 데이트 일기가 존재하는지 검사한다.
        DateLog dateLog = dateLogRepository.findById(dateLogId).orElseThrow(NotExistDateLogException::new);

        // 데이트 일기에 이미지를 삽입한다.
        dateLog.getImageList().add(image);
        // 데이트 일기에마일리지(exp)를 적립한다.
        dateLog.setMileage(dateLog.getMileage() + 10);
        // TODO: 커플에게 마일리지를 적립한다.
    }
}
