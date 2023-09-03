package com.ssafy.lovesol.domain.user.dto.request;


import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "회원가입 요청 DTO")
public class UpdateUserAccountInfoDto {

	@NotBlank
	@Schema(description = "사용자 로그인 ID", example = "shinhan")
	private String id;


	@Schema(description = "사용자 로그인 ID", example = "shinhan")
	private int depositAt;


	@Schema(description = "사용자 로그인 ID", example = "shinhan")
	private int amount;

}
