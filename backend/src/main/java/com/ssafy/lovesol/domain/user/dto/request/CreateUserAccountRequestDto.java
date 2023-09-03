package com.ssafy.lovesol.domain.user.dto.request;


import com.ssafy.lovesol.domain.user.entity.User;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "회원가입 요청 DTO")
public class CreateUserAccountRequestDto {

	@NotBlank
	@Schema(description = "사용자 로그인 ID", example = "shinhan")
	private String id;

	@NotBlank
	@Schema(description = "사용자 로그인 비밀번호", example = "12341234")
	private String password;

	@NotBlank
	@Schema(description = "사용자 간편 비밀번호", example = "123456")
	private String simplePassword;

	@NotBlank
	@Schema(description = "사용자 이름", example = "박신한")
	private String name;

	@NotBlank
	@Schema(description = "사용자 휴대폰 번호", example = "01012341234")
	private String phoneNumber;

	@NotBlank
	@Schema(description = "사용자 생일", example = "20001111")
	private String birthAt;

	@NotBlank
	@Schema(description = "사용자 계좌", example = "318307106824124")
	private String personalAccount;

	public User toEntity(){
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
		LocalDate updatedBirthAt = LocalDate.parse(birthAt, formatter);

		return User.builder()
				.id(id)
				.password(password)
				.simplePassword(simplePassword)
				.name(name)
				.phoneNumber(phoneNumber)
				.birthAt(updatedBirthAt)
				.personalAccount(personalAccount)
				.build();
	}
}
