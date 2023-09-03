package com.ssafy.lovesol.domain.couple.service;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.entity.Pet;
import com.ssafy.lovesol.domain.couple.repository.CoupleRepository;
import com.ssafy.lovesol.domain.couple.repository.PetRepository;
import com.ssafy.lovesol.global.exception.NotExistCoupleException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Slf4j
@RequiredArgsConstructor
@Service
public class PetServiceImpl implements PetService{
    private final PetRepository petRepository;
    private final CoupleRepository coupleRepository;

    @Override
    public Pet getPet(Long coupleId) {
        log.info("PetServiceImpl_getPet | 커플 펫 조회");
        Couple couple = coupleRepository.findById(coupleId).orElseThrow(NotExistCoupleException::new);
        return couple.getPet();
    }

    @Override
    public void createPet(String petName, Long coupleId) {
        Couple couple = coupleRepository.findById(coupleId).orElseThrow(NotExistCoupleException::new);
        petRepository.save(Pet.create(petName, couple));
    }

    @Override
    @Transactional
    public void gainExp(Long coupleId, int exp) {
        Couple couple = coupleRepository.findById(coupleId).orElseThrow(NotExistCoupleException::new);
        couple.getPet().gainExp(exp);
    }

    @Override
    public void deletePet(Pet pet) {
        petRepository.delete(pet);
    }
}
