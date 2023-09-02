package com.ssafy.lovesol.global.exception;

public class InvalidAccessTokenException extends RuntimeException {
	public InvalidAccessTokenException() {
		super(ExceptionCode.INVALID_ACCESS_TOKEN_EXCEPTION.getErrorMessage());
	}

	public InvalidAccessTokenException(String message) {
		super(message);
	}
}
