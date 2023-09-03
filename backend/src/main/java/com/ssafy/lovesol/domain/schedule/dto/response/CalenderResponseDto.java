package com.ssafy.lovesol.domain.schedule.dto.response;

import com.ssafy.lovesol.domain.datelog.dto.response.DateLogForCalenderResponseDto;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;
import java.util.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "달력에 표기하기위한 모든 정보 반환 DTO")
public class CalenderResponseDto {

    @Schema(description = "일정 리스트")
    List<ScheduleResponseDto> scheduleResponseDtoList;

    @Schema(description = "데이트 한 날짜 리스트")
    List<DateLogForCalenderResponseDto> dateLogForCalenderResponseDtoList;

    public static CalenderResponseDto createCalenderResponseDto(List<ScheduleResponseDto> scheduleResponseDtoList ,List<DateLogForCalenderResponseDto> dateLogForCalenderResponseDtoList ){

        return CalenderResponseDto.builder()
                .scheduleResponseDtoList(scheduleResponseDtoList)
                .dateLogForCalenderResponseDtoList(dateLogForCalenderResponseDtoList)
                .build();
    }
}
