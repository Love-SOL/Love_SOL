package com.ssafy.lovesol.domain.couple.dto.request;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.user.entity.User;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "커플 등록 요청 객체")
public class CoupleCreateRequestDto {


    private long id;


    public Couple toEntity(User owner){
        return Couple.builder()
                .owner(owner)
                .ownerTotal(0)
                .subOwnerTotal(0)
                .build();
    }
}
