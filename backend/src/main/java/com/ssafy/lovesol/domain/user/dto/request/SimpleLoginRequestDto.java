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
@Schema(description = "간편 로그인 요청 DTO")
public class SimpleLoginRequestDto {

    @Schema(description = "유저 ID", example = "1")
    private Long userId;

    @NotBlank
    @Schema(description = "간편 비밀번호", example = "123456")
    private String simplePassword;
}
