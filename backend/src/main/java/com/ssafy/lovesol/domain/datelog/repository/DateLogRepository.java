package com.ssafy.lovesol.domain.datelog.repository;


import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.datelog.entity.DateLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

public interface DateLogRepository extends JpaRepository<DateLog,Long> {

    @Query("SELECT d FROM DateLog d WHERE " +
            "d.couple.coupleId = :coupleId AND " +
            "FUNCTION('YEAR', d.dateAt) = :year AND " +
            "FUNCTION('MONTH', d.dateAt) = :month")
    List<DateLog> findAllByCoupleIdAndYearAndMonth(@Param("coupleId") Long coupleId,
                                                   @Param("year") int year,
                                                   @Param("month") int month);

    Optional<DateLog> findByCoupleAndDateAt(Couple couple, LocalDate createAt);
}
