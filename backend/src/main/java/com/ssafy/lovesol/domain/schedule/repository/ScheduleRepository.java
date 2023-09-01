package com.ssafy.lovesol.domain.schedule.repository;

import com.ssafy.lovesol.domain.schedule.entity.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ScheduleRepository extends JpaRepository<Schedule,Long> {
}
