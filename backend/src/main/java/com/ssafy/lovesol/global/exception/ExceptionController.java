package com.ssafy.lovesol.global.exception;

import com.ssafy.lovesol.global.response.ResponseResult;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@Slf4j
@RequiredArgsConstructor
@RestControllerAdvice(basePackages = "com.ssafy.lovesol")
public class ExceptionController {

	@ExceptionHandler(InvalidAccessTokenException.class)
	public ResponseResult InvalidAccessTokenException(InvalidAccessTokenException err) {
		log.info("Error : {}", err.getClass());
		log.info("Error Message : {}", err.getMessage());
		return ResponseResult.exceptionResponse(ExceptionCode.INVALID_ACCESS_TOKEN_EXCEPTION);
	}

	@ExceptionHandler(NotExistUserException.class)
	public ResponseResult NotExistAccountException(NotExistUserException err) {
		log.info("Error : {}", err.getClass());
		log.info("Error Message : {}", err.getMessage());
		return ResponseResult.exceptionResponse(ExceptionCode.NOT_EXIST_USER_EXCEPTION);
	}

	@ExceptionHandler(NotExistCoupleException.class)
	public ResponseResult NotExistCoupleException(NotExistCoupleException err) {
		log.info("Error : {}", err.getClass());
		log.info("Error Message : {}", err.getMessage());
		return ResponseResult.exceptionResponse(ExceptionCode.NOT_EXIST_COUPLE_EXCEPTION);
	}

	@ExceptionHandler(NotExistDateLogException.class)
	public ResponseResult notExistDateLogException(Exception err) {
		log.info("Error : {}", err.getClass());
		log.info("Error Message : {}", err.getMessage());
		return ResponseResult.exceptionResponse(ExceptionCode.NOT_EXIST_DATE_LOG);
	}

	@ExceptionHandler(NotExistImageException.class)
	public ResponseResult notExistImageException(Exception err) {
		log.info("Error : {}", err.getClass());
		log.info("Error Message : {}", err.getMessage());
		return ResponseResult.exceptionResponse(ExceptionCode.NOT_EXIST_IMAGE);
	}

	@ExceptionHandler(NotExistCommentException.class)
	public ResponseResult notExistCommentException(Exception err) {
		log.info("Error : {}", err.getClass());
		log.info("Error Message : {}", err.getMessage());
		return ResponseResult.exceptionResponse(ExceptionCode.NOT_EXIST_COMMENT);
	}

	@ExceptionHandler(NotExistAccountException.class)
	public ResponseResult NotExistAccountException(NotExistAccountException err) {
		log.info("Error : {}", err.getClass());
		log.info("Error Message : {}", err.getMessage());
		return ResponseResult.exceptionResponse(ExceptionCode.NOT_EXIST_ACCOUNT_EXCEPTION);
	}
}
