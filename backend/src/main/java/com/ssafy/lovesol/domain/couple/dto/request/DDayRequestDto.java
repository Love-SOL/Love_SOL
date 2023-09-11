package com.ssafy.lovesol.domain.couple.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
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
@Schema(description = "커플 D-DAY 설정 요청 Dto")
public class DDayRequestDto {

    private Long coupleId;

    @NotBlank
    private String title;

    @NotNull
    private LocalDate dDay;
}
