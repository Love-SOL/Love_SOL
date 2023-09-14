package com.ssafy.lovesol.domain.couple.entity;


import com.ssafy.lovesol.domain.couple.dto.response.DDayResponseDto;
import com.ssafy.lovesol.domain.user.entity.User;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Couple {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long coupleId;

    private String commonAccount;

//    @Column(nullable = false)
    private LocalDate anniversary;

    @Column(nullable = false)
    private double ownerTotal;

    @Column(nullable = false)
    private double subOwnerTotal;

    private String dDayTitle;

    private LocalDate dDay;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id")
    private User owner;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sub_owner_id")
    private User subOwner;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "couple_id")
    private Pet pet;

    public void updateDDay(String dDayTitle , LocalDate dDay){
        this.dDayTitle = dDayTitle;
        this.dDay = dDay;
    }

    public DDayResponseDto toDDayResponseDto(int dDay , LocalDate date){
        return DDayResponseDto.builder()
                .title(dDayTitle == null ? "일정없음" : dDayTitle)
                .coupleId(coupleId)
                .date(date)
                .remainingDay(dDay)
                .build();
    }
}
