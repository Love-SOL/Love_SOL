package com.ssafy.lovesol.domain.couple.repository;

import com.ssafy.lovesol.domain.couple.entity.Pet;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PetRepository  extends JpaRepository<Pet,Long> {
}
