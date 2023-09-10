package com.ssafy.lovesol.domain.user.dto.request;

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
@Schema(description = "휴대폰 문자 인증 요청 DTO")
public class PhoneNumberRequestDto {

    @NotBlank
    @Schema(description = "휴대폰 번호", example = "01099509587")
    private String phoneNumber;
}
