package com.ssafy.lovesol.domain.schedule.service;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.repository.CoupleRepository;
import com.ssafy.lovesol.domain.datelog.dto.response.DateLogForCalenderResponseDto;
import com.ssafy.lovesol.domain.datelog.repository.DateLogRepository;
import com.ssafy.lovesol.domain.schedule.dto.request.CreateScheduleRequestDto;
import com.ssafy.lovesol.domain.schedule.dto.request.UpdateScheduleRequestDto;
import com.ssafy.lovesol.domain.schedule.dto.response.CalenderResponseDto;
import com.ssafy.lovesol.domain.schedule.dto.response.ScheduleResponseDto;
import com.ssafy.lovesol.domain.schedule.entity.Schedule;
import com.ssafy.lovesol.domain.schedule.entity.ScheduleType;
import com.ssafy.lovesol.domain.schedule.repository.ScheduleRepository;
import com.ssafy.lovesol.domain.user.entity.User;
import com.ssafy.lovesol.domain.user.repository.UserRepository;
import com.ssafy.lovesol.global.util.JwtService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@Service
public class ScheduleServiceImpl implements ScheduleService{

    private final ScheduleRepository scheduleRepository;
    private final CoupleRepository coupleRepository;
    private final UserRepository userRepository;
    private final DateLogRepository dateLogRepository;
    private final JwtService jwtService;

    @Override
    @Transactional
    public Long createSchedule(Long coupleId, CreateScheduleRequestDto createScheduleRequestDto ,
                               HttpServletRequest request
                               ) {
        log.info("ScheduleServiceImpl_CreateSchedule | 일정 작성");
        Couple couple = coupleRepository.findById(coupleId).get();
        String loginId = jwtService.extractUserLoginIdFromAccessToken(request.getHeader("Authorization").split(" ")[1]);
        User user = userRepository.findById(loginId).get();
        Schedule schedule = createScheduleRequestDto.toScheduleEntity(couple, getScheduleType(couple, user, createScheduleRequestDto.getScheduleType()));
        return scheduleRepository.save(schedule).getScheduleId();
    }

    @Override
    public ScheduleType getScheduleType(Couple couple, User user , int ScheduleTypeInt) {
        log.info("ScheduleServiceImpl_getScheduleType | 일정 타입 파악");
        if(ScheduleTypeInt == 0)
            return ScheduleType.SHARED_SCHEDULE;

        if(couple.getOwner().getUserId().equals(user.getUserId()))
            return ScheduleType.MAIN_OWNER_SCHEDULE;
        return ScheduleType.SUB_OWNER_SCHEDULE;
    }

    @Override
    public void updateSchedule(Long coupleId, UpdateScheduleRequestDto updateScheduleRequestDto, HttpServletRequest request) {
        log.info("ScheduleServiceImpl_UpdateSchedule | 일정 수정");

        Schedule schedule = scheduleRepository.findById(updateScheduleRequestDto.getScheduleId()).get();
        Couple couple = coupleRepository.findById(coupleId).get();
        String loginId = jwtService.extractUserLoginIdFromAccessToken(request.getHeader("Authorization").split(" ")[1]);
        User user = userRepository.findById(loginId).get();
        ScheduleType scheduleType = getScheduleType(couple, user, updateScheduleRequestDto.getScheduleType());
        schedule.updateSchedule(updateScheduleRequestDto , scheduleType);
    }

    @Override
    public void deleteSchedule(Long scheduleId) {
        log.info("ScheduleServiceImpl_deleteSchedule | 일정 삭제");
        scheduleRepository.deleteById(scheduleId);
    }

    @Override
    public CalenderResponseDto getAllScheduleByYearAndMonth(Long coupleId, int year, int month) {
        log.info("ScheduleServiceImpl_getAllScheduleByYearAndMonth | 전체 일정 조회");

        List<ScheduleResponseDto> scheduleResponseDtoList = scheduleRepository.findAllByCoupleIdAndYearAndMonth(coupleId, year, month)
                .stream().map(schedule -> schedule.toScheduleResponseDto())
                .collect(Collectors.toList());

        List<DateLogForCalenderResponseDto> dateLogForCalenderResponseDtoList = dateLogRepository.findAllByCoupleIdAndYearAndMonth(coupleId, year, month)
                .stream().map(dateLog -> dateLog.toDateLogForCalenderResponseDto())
                .collect(Collectors.toList());

        return CalenderResponseDto.createCalenderResponseDto(scheduleResponseDtoList , dateLogForCalenderResponseDtoList);
    }

}
