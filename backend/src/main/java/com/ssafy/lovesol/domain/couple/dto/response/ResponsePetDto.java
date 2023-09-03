package com.ssafy.lovesol.domain.couple.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Schema(description = "샘플 반환 DTO")
public class ResponsePetDto {

    @NotNull
    @Schema(description = "펫 ID", example = "123")
    private Long petId;

    @NotNull
    @Schema(description = "펫 이름", example = "쏠")
    private String name;

    @NotNull
    @Schema(description = "펫 경험치", example = "10")
    private int exp;

    @NotNull
    @Schema(description = "펫 상태", example = "1")
    private int status;

    @NotNull
    @Schema(description = "펫 종류", example = "1")
    private int kind;

    @NotNull
    @Schema(description = "펫 레벨", example = "1")
    private int level;
}
