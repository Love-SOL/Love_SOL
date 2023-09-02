package com.ssafy.lovesol.global.exception;

public class NotExistAccountException extends RuntimeException {
	public NotExistAccountException() {
		super(ExceptionCode.NOT_EXIST_ACCOUNT_EXCEPTION.getErrorMessage());
	}

	public NotExistAccountException(String message) {
		super(message);
	}
}

