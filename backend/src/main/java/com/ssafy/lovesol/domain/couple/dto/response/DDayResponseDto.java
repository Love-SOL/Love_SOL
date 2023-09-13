package com.ssafy.lovesol.domain.couple.dto.response;

import java.time.LocalDate;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "커플 D-DAY 조회 Dto")
public class DDayResponseDto {

    private Long coupleId;
    private String title;
    private LocalDate date;
    private int remainingDay;

}
