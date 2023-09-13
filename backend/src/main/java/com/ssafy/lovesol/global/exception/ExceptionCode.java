package com.ssafy.lovesol.global.exception;

import lombok.Getter;

/**
 *  ErrorCode는 임의로 지정하였음
 */
@Getter
public enum ExceptionCode {


	NOT_EXIST_RECENT_COUPLE_SCHEDULE_EXCEPTION(440,"커플의 최근 일정이 존재하지 않습니다."),
	NOT_EXIST_ACCOUNT_EXCEPTION(450, "계좌가 존재하지 않습니다."),
	NOT_EXIST_DATE_LOG(490, "데이트 일기가 존재하지 않습니다."),
	NOT_EXIST_IMAGE(495, "이미지가 존재하지 않습니다."),
	NOT_EXIST_COMMENT(496, "댓글이 존재하지 않습니다."),
	NOT_EXIST_USER_EXCEPTION(470, "사용자가 존재하지 않습니다."),
	NOT_EXIST_COUPLE_EXCEPTION(460, "커플 정보가 존재하지 않습니다"),
	INVALID_ACCESS_TOKEN_EXCEPTION(480, "Access Token이 유효하지 않습니다."),
	SERVER_EXCEPTION(500, "서버에서 예측하지 못한 에러가 발생했습니다.");

	private final int errorCode;
	private final String errorMessage;

	ExceptionCode(int errorCode, String errorMessage) {
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
	}
}
