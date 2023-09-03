package com.ssafy.lovesol.domain.schedule.service;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.schedule.dto.request.CreateScheduleRequestDto;
import com.ssafy.lovesol.domain.schedule.entity.ScheduleType;
import com.ssafy.lovesol.domain.user.entity.User;
import jakarta.servlet.http.HttpServletRequest;

public interface ScheduleService {
    Long CreateSchedule(Long coupleId , CreateScheduleRequestDto registScheduleRequestDto, HttpServletRequest request);
    ScheduleType getScheduleType(Couple couple , User user , int ScheduleType);
}
