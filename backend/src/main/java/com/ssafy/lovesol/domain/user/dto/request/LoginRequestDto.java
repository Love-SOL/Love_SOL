package com.ssafy.lovesol.domain.user.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "로그인 요청 DTO")
public class LoginRequestDto {

	@NotBlank
	@Schema(description = "로그인 ID", example = "ssafy")
	private String id;

	@NotBlank
	@Schema(description = "로그인 PW", example = "12341234")
	private String password;

}
