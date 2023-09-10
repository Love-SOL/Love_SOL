package com.ssafy.lovesol.domain.bank.dto.request;

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

    @NotBlank
    @Schema(description = "휴대폰 번호", example = "01099509587")
    private String phoneNumber;
}
