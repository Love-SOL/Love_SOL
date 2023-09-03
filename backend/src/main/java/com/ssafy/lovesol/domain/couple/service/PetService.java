package com.ssafy.lovesol.domain.couple.service;

import com.ssafy.lovesol.domain.couple.entity.Pet;

import java.util.Optional;

public interface PetService {
    Pet getPet(Long coupleId);
    Pet createPet(Pet pet);
    Pet modifyPet(Pet pet);
    void deletePet(Pet pet);
}
