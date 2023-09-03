package com.ssafy.lovesol.domain.couple.service;

import com.ssafy.lovesol.domain.couple.entity.Pet;
import com.ssafy.lovesol.domain.couple.repository.PetRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Slf4j
@RequiredArgsConstructor
@Service
public class PetServiceImpl implements PetService{
    private final PetRepository petRepository;

    @Override
    public Pet getPet(Long coupleId) {
        log.info("PetServiceImpl_findByCoupleId | 커플 펫 조회");
        return petRepository.findByCouple_CoupleId(coupleId);
    }

    @Override
    public Pet createPet(Pet pet) {
        return petRepository.save(pet);
    }

    @Override
    public Pet modifyPet(Pet pet) {
        return petRepository.save(pet);
    }

    @Override
    public void deletePet(Pet pet) {
        petRepository.delete(pet);
    }
}
