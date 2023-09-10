package com.ssafy.lovesol.domain.couple.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "커플 등록 요청 객체")
public class SendCoupleAmountRequestDto {


    @NotNull
    @Schema(description = "커플pk값", example = "1")
    private long couplId;

    @NotNull
    @Schema(description = "금액", example = "5000")
    private int amount; // 0: 승인 1: 거절


}
