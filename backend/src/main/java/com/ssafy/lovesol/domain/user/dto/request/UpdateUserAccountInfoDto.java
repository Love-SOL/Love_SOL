package com.ssafy.lovesol.domain.user.dto.request;


import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "계좌정보 업데이트")
public class UpdateUserAccountInfoDto {

	@NotBlank
	@Schema(description = "사용자 로그인 ID", example = "shinhan")
	private String id;


	@Schema(description = "사용자 자동입금 일자", example = "1:28")
	private int depositAt;


	@Schema(description = "사용자 자동 입금 금액", example = "0")
	private int amount;

}
