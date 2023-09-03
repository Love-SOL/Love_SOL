package com.ssafy.lovesol.domain.datelog.dto.response;

import com.ssafy.lovesol.domain.datelog.entity.Image;
import com.ssafy.lovesol.domain.datelog.entity.PaymentLog;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.time.LocalDate;
import java.util.List;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "달력에 표기하기위한 데이트 정보 반환 DTO")
public class DateLogResponseDto {
    @Schema(description = "데이트 로그 ID", example = "1")
    private Long dateLogId;
    @Schema(description = "데이트 날짜", example = "1")
    private LocalDate dateAt;
    @Schema(description = "해당 일에 적립된 마일리지", example = "1")
    private int mileage;
    @Schema(description = "해당 날짜 결제 내역")
    private List<PaymentLog> paymentLogList;
    @Schema(description = "데이트 일기 이미지 목록")
    private List<Image> imageList;

}
