package com.ssafy.lovesol.global.response;

import com.ssafy.lovesol.global.exception.ExceptionCode;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import org.springframework.http.HttpStatus;

import java.time.LocalDateTime;

@Getter
@SuperBuilder
@AllArgsConstructor
@NoArgsConstructor
@Schema(title = "요청 결과", description = "프론트에서의 요청의 성공,실패 여부")
public class ResponseResult {

	@Schema(description = "요청에 대한 성공 또는 다양한 예외 코드 반환")
	int statusCode;

	@Schema(description = "프론트에서 보여줄 메세지")
	String messages;

	@Schema(description = "개발자를 위한 메세지")
	String developerMessage;

	@Schema(description = "응답 시간")
	LocalDateTime timestamp;

	public static final ResponseResult successResponse =
		ResponseResult.builder()
			.statusCode(HttpStatus.OK.value())
			.messages("성공 :)")
			.developerMessage("성공하였습니다.")
			.timestamp(LocalDateTime.now()).build();

	public static final ResponseResult failResponse =
		ResponseResult.builder()
			.statusCode(HttpStatus.BAD_REQUEST.value())
			.messages("실패 :(")
			.developerMessage("실패하였습니다.")
			.timestamp(LocalDateTime.now()).build();

	public static final ResponseResult exceptionResponse(ExceptionCode exceptionCode) {
		return ResponseResult.builder()
			.statusCode(exceptionCode.getErrorCode())
			.messages("에러발생 :(")
			.developerMessage(exceptionCode.getErrorMessage())
			.timestamp(LocalDateTime.now()).build();
	}
}


