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
@Schema(description = "펫 경험치 증가 요청 DTO")
public class IncreasePetExpRequestDto {
    @NotNull
    @Schema(description = "경험치", example = "3")
    private int exp;
}
