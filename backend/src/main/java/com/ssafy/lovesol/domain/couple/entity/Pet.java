package com.ssafy.lovesol.domain.couple.entity;

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

    public static Pet create(String petName, Couple couple) {
        return Pet.builder()
                .name(petName)
                .couple(couple)
                .build();
    }
}
