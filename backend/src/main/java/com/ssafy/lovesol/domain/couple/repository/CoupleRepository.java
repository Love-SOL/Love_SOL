package com.ssafy.lovesol.domain.couple.repository;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CoupleRepository extends JpaRepository<Couple,Long> {
}
