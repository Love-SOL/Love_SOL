package com.ssafy.lovesol.domain.bank.dto.response;

import java.time.LocalDateTime;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "계좌의 거래 내역 정보 반환 DTO")
public class GetTransactionResponseDto {

	@Schema(description = "가게 이름", example = "스타벅스")
	private String content;

	@Schema(description = "출/입금 구분", example = "0")
	private int transactionType;

	@Schema(description = "거래액", example = "15000")
	private int transactionAmount;

	@Schema(description = "거래 시간", example = "2023-09-23~~")
	private LocalDateTime transactionAt;
}
