package com.ssafy.lovesol.domain.couple.service;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.entity.Pet;

import java.util.Optional;

public interface PetService {
    Pet getPet(Long coupleId);
    void createPet(String petName, Long coupleId);
    void gainExp(Long coupleId, int exp);
    void deletePet(Pet pet);
}
