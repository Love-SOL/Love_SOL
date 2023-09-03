package com.ssafy.lovesol.domain.couple.repository;

import com.ssafy.lovesol.domain.couple.entity.Pet;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PetRepository  extends JpaRepository<Pet,Long> {
    Pet findByCouple_CoupleId(Long CoupleId);

}
