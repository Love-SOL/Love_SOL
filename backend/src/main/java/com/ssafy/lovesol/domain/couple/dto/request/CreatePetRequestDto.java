package com.ssafy.lovesol.domain.couple.dto.request;

import com.ssafy.lovesol.domain.couple.entity.Pet;
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
@Schema(description = "펫 생성 요청 DTO")
public class CreatePetRequestDto {

    @NotNull
    @Schema(description = "펫 이름", example = "쏠이")
    private String name;

    @Schema(description = "펫의 종류", example = "1")
    private int kind;
    public Pet toEntity(String name){
        return Pet.builder()
                .name(name)
                .build();
    }
}
