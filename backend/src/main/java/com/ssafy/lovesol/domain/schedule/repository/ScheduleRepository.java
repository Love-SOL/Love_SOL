package com.ssafy.lovesol.domain.schedule.repository;

import com.ssafy.lovesol.domain.schedule.entity.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.*;

public interface ScheduleRepository extends JpaRepository<Schedule,Long> {

    @Query("SELECT s FROM Schedule s WHERE s.couple.coupleId = :coupleId AND " +
            "(FUNCTION('YEAR', s.startAt) = :year OR FUNCTION('YEAR', s.endAt) = :year) " +
            "AND " +
            "(FUNCTION('MONTH', s.startAt) = :month OR FUNCTION('MONTH', s.endAt) = :month)")
    List<Schedule> findAllByCoupleIdAndYearAndMonth(@Param("coupleId") Long coupleId, @Param("year") int year, @Param("month") int month);

}
