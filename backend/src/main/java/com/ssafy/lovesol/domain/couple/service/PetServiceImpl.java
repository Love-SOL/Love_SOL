package com.ssafy.lovesol.domain.couple.service;

import com.ssafy.lovesol.domain.couple.dto.response.ResponsePetDto;
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
    public ResponsePetDto getPet(Long coupleId) {
        log.info("PetServiceImpl_getPet | 커플 펫 조회");
        Couple couple = coupleRepository.findById(coupleId).orElseThrow(NotExistCoupleException::new);
        Pet pet = couple.getPet();
        if (pet == null)
            return null;

        return pet.toResponsePetDto();
    }

    @Override
    public ResponsePetDto createPet(String petName, int kind, Long coupleId) {
        Couple couple = coupleRepository.findById(coupleId).orElseThrow(NotExistCoupleException::new);
        Pet pet = Pet.create(petName, kind, couple);
        petRepository.save(pet);
        return pet.toResponsePetDto();
    }

    @Override
    @Transactional
    public void gainExp(Long coupleId, int exp) {
        Couple couple = coupleRepository.findById(coupleId).orElseThrow(NotExistCoupleException::new);
        Pet pet = couple.getPet();
        pet.gainExp(exp);
        if (pet.getExp() >= 1000 || pet.getExp() >= 3000) {
            pet.levelUp();
            log.info(couple.getCoupleId() + " 펫 " + pet.getName() + " 레벨 업");
        }
    }


    @Override
    public void deletePet(Pet pet) {
        petRepository.delete(pet);
    }

    @Override
    public void updatePet(Pet pet) {
        petRepository.save(pet);
    }
}
