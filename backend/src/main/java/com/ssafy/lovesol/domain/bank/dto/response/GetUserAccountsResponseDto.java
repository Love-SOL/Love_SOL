package com.ssafy.lovesol.domain.bank.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "사용자 명의 계좌 정보 반환 DTO")
public class GetUserAccountsResponseDto {
    @Schema(description = "계좌번호", example = "01112341234")
    private String accountNumber;
    @Schema(description = "예금주 명", example = "김신한")
    private String name;
    @Schema(description = "잔액", example = "12345123")
    private double balance;
    @Schema(description = "계좌타입", example = "0:일반계좌 1:러브박스")
    private int type;

}
