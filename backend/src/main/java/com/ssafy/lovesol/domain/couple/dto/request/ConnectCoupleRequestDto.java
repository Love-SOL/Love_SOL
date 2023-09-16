package com.ssafy.lovesol.domain.couple.dto.request;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.user.entity.User;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.Column;
import jakarta.validation.constraints.NotBlank;
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
public class ConnectCoupleRequestDto {

    @NotBlank
    private String subOnwerId;



    @NotNull
    @Schema(description = "0,1 승인/거절", example = "예시")
    private int check; // 0: 승인 1: 거절


}
