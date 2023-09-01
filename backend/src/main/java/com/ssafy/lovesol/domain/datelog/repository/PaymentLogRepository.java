package com.ssafy.lovesol.domain.datelog.repository;


import com.ssafy.lovesol.domain.datelog.entity.PaymentLog;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PaymentLogRepository extends JpaRepository<PaymentLog,Long> {
}
