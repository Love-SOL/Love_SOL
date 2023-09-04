package com.ssafy.lovesol.global.exception;

public class NotExistCommentException extends RuntimeException{
    public NotExistCommentException() {
        super(ExceptionCode.NOT_EXIST_COMMENT.getErrorMessage());
    }

    public NotExistCommentException(String message) {
        super(message);
    }
}
