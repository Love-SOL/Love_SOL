package com.ssafy.lovesol.domain.couple.entity;

import com.ssafy.lovesol.domain.couple.dto.response.ResponsePetDto;
import jakarta.persistence.*;
import lombok.*;

@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Pet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long petId;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private int exp;

    @Column(nullable = false)
    private int status;

    @Column(nullable = false)
    private int kind;

    @Column(nullable = false)
    private int level;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "couple_id")
    private Couple couple;

    public void gainExp(int exp) {
        this.exp += exp;
    }

    public void levelUp() {
        this.level++;
    }

    public static Pet create(String petName, Couple couple) {
        return Pet.builder()
                .name(petName)
                .couple(couple)
                .level(1)
                .build();
    }

    public ResponsePetDto toResponsePetDto(){
        return ResponsePetDto.builder()
                .petId(petId)
                .name(name)
                .exp(exp)
                .status(status)
                .kind(kind)
                .level(level)
                .build();
    }
}
