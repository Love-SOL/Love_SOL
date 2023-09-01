package com.ssafy.lovesol.domain.couple.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Builder
@Getter
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
}
