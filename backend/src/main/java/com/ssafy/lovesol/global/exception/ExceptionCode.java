package com.ssafy.lovesol.global.exception;

import lombok.Getter;

/**
 *  ErrorCode는 임의로 지정하였음
 */
@Getter
public enum ExceptionCode {

	SERVER_EXCEPTION(500, "서버에서 예측하지 못한 에러가 발생했습니다."),
	NOT_EXIST_DATE_LOG(490, "데이트 일기가 존재하지 않습니다."),
	NOT_EXIST_IMAGE(495, "이미지가 존재하지 않습니다.");
	private final int errorCode;
	private final String errorMessage;

	ExceptionCode(int errorCode, String errorMessage) {
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
	}
}
