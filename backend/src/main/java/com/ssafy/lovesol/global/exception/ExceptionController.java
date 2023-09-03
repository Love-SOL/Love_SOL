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

	@ExceptionHandler(Exception.class)
	public ResponseResult incorrectLanguageCodeException(Exception err) {
		log.info("Error : {}", err.getClass());
		log.info("Error Message : {}", err.getMessage());
		return ResponseResult.exceptionResponse(ExceptionCode.SERVER_EXCEPTION);
	}

	@ExceptionHandler(Exception.class)
	public ResponseResult notExistDateLogException(Exception err) {
		log.info("Error : {}", err.getClass());
		log.info("Error Message : {}", err.getMessage());
		return ResponseResult.exceptionResponse(ExceptionCode.NOT_EXIST_DATE_LOG);
	}
}
