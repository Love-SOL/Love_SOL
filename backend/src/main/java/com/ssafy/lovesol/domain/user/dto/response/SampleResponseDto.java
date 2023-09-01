package com.ssafy.lovesol.domain.user.dto.response;

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
@Schema(description = "샘플 반환 DTO")
public class SampleResponseDto {

    @NotNull
    @Schema(description = "설명", example = "예시")
    private String sample;

}
