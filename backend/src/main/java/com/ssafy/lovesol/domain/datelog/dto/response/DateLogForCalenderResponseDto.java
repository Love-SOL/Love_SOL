package com.ssafy.lovesol.domain.datelog.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "달력에 표기하기위한 데이트 정보 반환 DTO")
public class DateLogForCalenderResponseDto {

    @Schema(description = "일정 ID", example = "1")
    private Long dateLogId;

    @Schema(description = "데이트 한 날짜", example = "20230903")
    private LocalDate dateAt;
}
