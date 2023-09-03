package com.ssafy.lovesol.domain.schedule.dto.request;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.schedule.entity.Schedule;
import com.ssafy.lovesol.domain.schedule.entity.ScheduleType;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "일정 등록 요청 DTO")
public class CreateScheduleRequestDto {

    @NotBlank
    @Schema(description = "일정 내용", example = "신촌 데이트")
    private String content;

    @Schema(description = "일정 타입", example = "0")
    private int scheduleType;

    @Schema(description = "일정 시작 날짜", example = "2023-09-03T14:30:40.123")
    private LocalDateTime startAt;

    @Schema(description = "일정 종료 날짜", example = "2023-09-04T14:30:40.123")
    private LocalDateTime endAt;

    public Schedule toScheduleEntity(Couple couple , ScheduleType scheduleType){
        return Schedule.builder()
                .couple(couple)
                .scheduleType(scheduleType)
                .content(content)
                .startAt(startAt)
                .endAt(endAt)
                .build();
    }


}
