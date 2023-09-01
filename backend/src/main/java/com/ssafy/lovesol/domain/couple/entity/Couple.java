package com.ssafy.lovesol.domain.couple.entity;


import com.ssafy.lovesol.domain.user.entity.User;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Couple {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long coupleId;

    @Column(nullable = false)
    private String commonAccount;

    @Column(nullable = false)
    private LocalDateTime anniversary;

    @Column(nullable = false)
    private double ownerTotal;

    @Column(nullable = false)
    private double subOwnerTotal;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id")
    private User owner;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sub_owner_id")
    private User subOwner;

    @OneToOne(mappedBy = "couple", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Pet pet;
}
