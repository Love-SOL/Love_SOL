package com.ssafy.lovesol.domain.bank.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "1원 이체 요청 DTO")
public class TransferRequestDto {

    @NotBlank
    @Schema(description = "계좌 번호", example = "110222999999")
    private String accountNumber;
}
