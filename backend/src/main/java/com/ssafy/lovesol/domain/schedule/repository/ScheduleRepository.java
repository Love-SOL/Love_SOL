package com.ssafy.lovesol.domain.schedule.repository;

import com.ssafy.lovesol.domain.schedule.entity.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.*;

public interface ScheduleRepository extends JpaRepository<Schedule,Long> {

    @Query("SELECT s FROM Schedule s WHERE s.couple.coupleId = :coupleId AND " +
            "(FUNCTION('YEAR', s.startAt) = :year OR FUNCTION('YEAR', s.endAt) = :year) " +
            "AND " +
            "(FUNCTION('MONTH', s.startAt) = :month OR FUNCTION('MONTH', s.endAt) = :month)")
    List<Schedule> findAllByCoupleIdAndYearAndMonth(@Param("coupleId") Long coupleId, @Param("year") int year, @Param("month") int month);

    @Query("SELECT s FROM Schedule s WHERE :targetDate BETWEEN s.startAt AND s.endAt AND s.couple.coupleId = :coupleId")
    List<Schedule> findAllByDateInRangeAndCoupleId(@Param("coupleId") Long coupleId , @Param("targetDate") LocalDate targetDate);

    @Query("SELECT MIN(s.startAt) FROM Schedule s WHERE s.startAt >= :currentDate AND s.couple.coupleId = :coupleId")
    LocalDate findClosestFutureScheduleDate(@Param("currentDate") LocalDate currentDate, @Param("coupleId") Long coupleId);

    @Query("SELECT s FROM Schedule s WHERE s.startAt = :closestDate AND s.couple.coupleId = :coupleId")
    List<Schedule> findAllSchedulesOnClosestDate(@Param("closestDate") LocalDate closestDate, @Param("coupleId") Long coupleId);

}
