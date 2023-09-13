package com.ssafy.lovesol.domain.schedule.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "최근 커플 일정 반환 DTO")
public class RecentCoupleScheduleResponseDto {

	@Schema(description = "일정 내용", example = "신촌 데이트")
	private String content;

	@Schema(description = "남은날", example = "5")
	private int remainingDay;
}
