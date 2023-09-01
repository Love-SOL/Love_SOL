package com.ssafy.lovesol.domain.datelog.repository;


import com.ssafy.lovesol.domain.datelog.entity.DateLog;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DateLogRepository extends JpaRepository<DateLog,Long> {
}
