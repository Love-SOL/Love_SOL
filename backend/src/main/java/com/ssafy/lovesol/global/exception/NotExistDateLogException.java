package com.ssafy.lovesol.global.exception;

public class NotExistDateLogException extends RuntimeException{
    public NotExistDateLogException() {
        super(ExceptionCode.NOT_EXIST_DATE_LOG.getErrorMessage());
    }
    public NotExistDateLogException(String message) {
        super(message);
    }
}
