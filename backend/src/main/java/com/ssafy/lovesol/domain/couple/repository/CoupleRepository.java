package com.ssafy.lovesol.domain.couple.repository;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CoupleRepository extends JpaRepository<Couple,Long> {



    Optional<Couple> findBySubOwner(long userId);
    Optional<Couple> findByOwner(long userId);


}
