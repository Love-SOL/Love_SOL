package com.ssafy.lovesol.domain.user.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "FCM Token 업데이트")
public class UpdateFCMTokenRequestDto {

    @NotBlank
    @Schema(description = "사용자 로그인 ID", example = "shinhan")
    private long userId;


    @NotBlank
    @Schema(description = "Android 기기 FCM Token", example = "asdbascaicnen212c1nwicbz19w381bxb0")
    private String fcmToken;

}
