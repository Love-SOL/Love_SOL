package com.ssafy.lovesol.domain.user.controller;

import com.ssafy.lovesol.domain.user.dto.request.*;
import com.ssafy.lovesol.domain.user.dto.response.UserResponseDto;
import com.ssafy.lovesol.domain.user.entity.User;
import com.ssafy.lovesol.domain.user.service.UserService;
import com.ssafy.lovesol.global.response.ResponseResult;
import com.ssafy.lovesol.global.response.SingleResponseResult;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.nurigo.java_sdk.exceptions.CoolsmsException;
import org.springframework.web.bind.annotation.*;

@ApiResponses({
        @ApiResponse(responseCode = "200", description = "응답이 성공적으로 반환되었습니다."),
        @ApiResponse(responseCode = "400", description = "응답이 실패하였습니다.",
                content = @Content(schema = @Schema(implementation = ResponseResult.class)))})
@Tag(name = "User Controller", description = "유저 컨트롤러")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/api/user")
public class UserController {

    private final UserService userService;

    @Operation(summary = "Sign Up", description = "사용자가 회원가입 합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "회원가입 성공")
    })
    @PostMapping("/signup")
    public ResponseResult createUserAccount(
            @Valid @RequestBody CreateUserAccountRequestDto createUserAccountRequestDto) {
        log.info("UserController_createUserAccount -> 사용자의 회원가입");
        if (userService.createUserAccount(createUserAccountRequestDto) >= 0) {
            return ResponseResult.successResponse;
        }
        return ResponseResult.failResponse;
    }

    @Operation(summary = "Login", description = "사용자가 로그인 합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "로그인 성공")
    })
    @PostMapping("/login")
    public ResponseResult login(@Valid @RequestBody LoginRequestDto loginRequestDto, HttpServletResponse response) {
        log.info("UserController_login -> 로그인 시도");
        return new SingleResponseResult<>(userService.login(loginRequestDto, response));
    }

    @Operation(summary = "Simple Password Auth", description = "사용자가 간편 로그인을 합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "간편 로그인 성공")
    })
    @PostMapping("/simple-password")
    public ResponseResult simpleLogin(@Valid @RequestBody SimpleLoginRequestDto simpleLoginRequestDto) {
        log.info("UserController_simpleLogin -> 간편 로그인 시도");
        return new SingleResponseResult<>(userService.simpleLogin(simpleLoginRequestDto));
    }

    @PostMapping("/{token}")
    @Operation(summary = "FCM", description = "Flutter 사용자가 보내주는 Token값을 확인하고 업데이트를 진행합니다")
    public ResponseResult checkFcm(@RequestBody @Valid UpdateFCMTokenRequestDto updateFCMTokenRequestDto){
       userService.setFCMToken(updateFCMTokenRequestDto);
       return ResponseResult.successResponse;
    }

    @Operation(summary = "Deposit", description = "사용자가 자동 입금 날짜 및 금액을 설정합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description ="자동 입금 설정 성공")
    })


    @PutMapping("/account")
    public ResponseResult setDeposit(@Valid @RequestBody UpdateUserAccountInfoDto updateUserAccountInfoDto){
        log.info("UserController_Deposit -> 자동 입금 정보 설정");
        userService.UpdateDepositInfo(updateUserAccountInfoDto);
        return ResponseResult.successResponse;
    }

    @GetMapping("/account/{id}")
    public SingleResponseResult<UserResponseDto> setDeposit(@PathVariable String id){
        log.info("UserController_Deposit -> 자동 입금 정보 조회");
        User user = userService.getUserById(id);
        return new SingleResponseResult<UserResponseDto>(
                UserResponseDto.builder()
                        .id(user.getId())
                        .personalAccount(user.getPersonalAccount())
                        .name(user.getName())
                        .phoneNumber(user.getPhoneNumber())
                        .birthAt(user.getBirthAt())
                        .amount(user.getAmount())
                        .depositAt(user.getDepositAt())
                        .build()
        );
    }

    @Operation(summary = "PhoneNumber Auth", description = "사용자 휴대폰 번호인증을 요청합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "휴대폰번호로 문자메시지 발송 성공")
    })
    @PostMapping("/phone")
    public ResponseResult sendMessage(@Valid @RequestBody PhoneNumberRequestDto phoneNumberRequestDto) throws CoolsmsException {
        log.info("UserController_sendMessage -> 휴대폰 번호로 메시지 발송");
        return new SingleResponseResult<String>(userService.sendMessage(phoneNumberRequestDto));
    }

}
