package com.ssafy.lovesol.domain.couple.repository;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;


@Repository
public interface CoupleRepository extends JpaRepository<Couple,Long> {



    Optional<Couple> findBySubOwner(User userId);
    Optional<Couple> findByOwner(User userId);


}
