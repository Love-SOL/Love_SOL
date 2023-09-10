package com.ssafy.lovesol.domain.user.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "로그인 성공 반환 DTO")
public class LoginResponseDto {

    @Schema(description = "유저 ID", example = "1")
    private Long userId;

    @Schema(description = "커플 ID", example = "1")
    private Long coupleId;

}
