package com.ssafy.lovesol.domain.schedule.dto.response;

import com.ssafy.lovesol.domain.schedule.entity.ScheduleType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "일정 정보 반환 DTO")
public class ScheduleResponseDto {

    @Schema(description = "일정 ID", example = "1")
    private Long scheduleId;

    @Schema(description = "일정 내용", example = "신촌 데이트")
    private String content;

    @Schema(description = "일정 타입", example = "MAIN_OWNER_SCHEDULE")
    private ScheduleType scheduleType;

    @Schema(description = "일정 시작 날짜", example = "20230903")
    private LocalDate startAt;

    @Schema(description = "일정 종료 날짜", example = "20230904")
    private LocalDate endAt;

}
