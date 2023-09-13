package com.ssafy.lovesol.global.exception;

public class NotExistRecentCoupleScheduleException extends RuntimeException {
	public NotExistRecentCoupleScheduleException() {
		super(ExceptionCode.NOT_EXIST_RECENT_COUPLE_SCHEDULE_EXCEPTION.getErrorMessage());
	}
	public NotExistRecentCoupleScheduleException(String message) {
		super(message);
	}
}
