package com.ssafy.lovesol.domain.bank.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "1원 이체 인증번호 인증 DTO")
public class TransferAuthRequestDto {

    @NotBlank
    @Schema(description = "계좌 번호", example = "110222999999")
    private String accountNumber;

    @NotBlank
    @Schema(description = "인증 번호", example = "135135")
    private String authNumber;

}
