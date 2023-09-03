package com.ssafy.lovesol.global.exception;

public class NotExistImageException extends RuntimeException {
    public NotExistImageException() {
        super(ExceptionCode.NOT_EXIST_IMAGE.getErrorMessage());
    }

    public NotExistImageException(String message) {
        super(message);
    }
}
