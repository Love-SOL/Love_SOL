package com.ssafy.lovesol.global.exception;

public class NotExistCoupleException extends RuntimeException{
    public NotExistCoupleException() {
        super(ExceptionCode.NOT_EXIST_COUPLE_EXCEPTION.getErrorMessage());
    }

    public NotExistCoupleException(String message) {
        super(message);
    }
}
