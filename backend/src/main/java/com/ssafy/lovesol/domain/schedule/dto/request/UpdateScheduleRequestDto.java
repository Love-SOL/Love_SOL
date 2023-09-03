package com.ssafy.lovesol.domain.schedule.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "일정 수정 요청 DTO")
public class UpdateScheduleRequestDto {

    @Schema(description = "일정 타입", example = "0")
    private Long scheduleId;

    @Schema(description = "일정 내용", example = "신촌 데이트")
    private String content;

    @Schema(description = "일정 타입", example = "0")
    private int scheduleType;

    @Schema(description = "일정 시작 날짜", example = "20230903")
    private String startAt;

    @Schema(description = "일정 종료 날짜", example = "20230904")
    private String endAt;
}
