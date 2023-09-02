package com.ssafy.lovesol.global.exception;

import lombok.Getter;

/**
 *  ErrorCode는 임의로 지정하였음
 */
@Getter
public enum ExceptionCode {

	NOT_EXIST_ACCOUNT_EXCEPTION(470, "사용자가 존재하지 않습니다."),
	INVALID_ACCESS_TOKEN_EXCEPTION(480, "Access Token이 유효하지 않습니다."),
	SERVER_EXCEPTION(500, "서버에서 예측하지 못한 에러가 발생했습니다.");

	private final int errorCode;
	private final String errorMessage;

	ExceptionCode(int errorCode, String errorMessage) {
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
	}
}
