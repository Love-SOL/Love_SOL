package com.ssafy.lovesol.domain.couple.controller;

import com.ssafy.lovesol.domain.bank.entity.Account;
import com.ssafy.lovesol.domain.bank.entity.Transaction;
import com.ssafy.lovesol.domain.bank.service.AccountService;
import com.ssafy.lovesol.domain.bank.service.TransactionService;
import com.ssafy.lovesol.domain.couple.dto.request.ConnectCoupleRequestDto;
import com.ssafy.lovesol.domain.couple.dto.request.CoupleCreateRequestDto;
import com.ssafy.lovesol.domain.couple.dto.request.DDayRequestDto;
import com.ssafy.lovesol.domain.couple.dto.request.SendCoupleAmountRequestDto;
import com.ssafy.lovesol.domain.couple.dto.response.ResponseAccountInfoDto;
import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.service.CoupleService;
import com.ssafy.lovesol.global.response.ListResponseResult;
import com.ssafy.lovesol.global.response.ResponseResult;
import com.ssafy.lovesol.global.response.SingleResponseResult;
import com.ssafy.lovesol.global.util.CommonHttpSend;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONObject;
import org.springframework.http.ResponseEntity;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@ApiResponses({
        @ApiResponse(responseCode = "200", description = "응답이 성공적으로 반환되었습니다."),
        @ApiResponse(responseCode = "400", description = "응답이 실패하였습니다.",
                content = @Content(schema = @Schema(implementation = ResponseResult.class)))})
@Tag(name = "Couple Controller", description = "커플 컨트롤러")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/api/couple")
public class CoupleController {
    private final CoupleService coupleService;
    private final CommonHttpSend commonHttpSend;
    private final TransactionService transactionService;
    private final AccountService accountService;
    @Operation(summary = "Couple info", description = "사용자의 커플 정보를 조회합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "커플 테이블 조회 성공")
    })
    @GetMapping("/{userId}")
    public SingleResponseResult<Couple> getCoupleInfo(@PathVariable String userId){
        log.info("CoupleController -> 커플 통장 정보 조회 ");
        Couple couple = coupleService.getCoupleInfoByUserId(userId);
        return new SingleResponseResult<Couple>(couple);
    }


    @Operation(summary = "Couple Create", description = "사용자가 커플 통장을 생성합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "커플 통장 생성 성공")
    })
    @PostMapping("")
    public ResponseResult createCoupleinfo(@RequestBody @Valid CoupleCreateRequestDto coupleCreateRequestDto)
    {
        log.info("CoupleController -> 커플 통장 초기 생성 ");
        if(coupleService.createCouple(coupleCreateRequestDto) < 0) return ResponseResult.failResponse;


        return ResponseResult.successResponse;
    }

    @PostMapping("/share/{ownerId}")
    public ResponseResult connectCouple(@PathVariable long coupleId,@RequestBody @Valid ConnectCoupleRequestDto coupleRequestDto){
        log.info("CoupleController -> 커플 통장 연결 유무 처리 ");
        if(!coupleService.connectCouple(coupleRequestDto,coupleId)){
            return ResponseResult.failResponse;
        }

        return ResponseResult.successResponse;
    }
    @GetMapping("/test")
    public ResponseEntity<String> test(){
        log.info("CoupleController -> 환율 조회 ");
        Map<String, String> data = new HashMap<>();
        data.put("조회일자","20230901");
       return commonHttpSend.autoDeposit(data, "/search/fxrate/number");

    }

    @GetMapping("/{coupleId}/balance")
    public SingleResponseResult<ResponseAccountInfoDto> accountTotalInfo(@PathVariable long coupleId){
        ResponseAccountInfoDto dto = coupleService.getAccountTotal(coupleId);
        return new SingleResponseResult<ResponseAccountInfoDto>(dto);
    }
    //
    @GetMapping("/{coupleId}/detail/{date}")
    public ListResponseResult<Transaction> accountDetail(@PathVariable long coupleId , @PathVariable LocalDate date){
        Couple couple = coupleService.getCoupleInfoByCouplId(coupleId);
        Account account = accountService.findAccountByAccountNumber(couple.getCommonAccount());
        LocalDateTime infoAt = date.atStartOfDay();
        List<Transaction> transactionList = transactionService.findTransactionsDetailOrderBy(infoAt,account);
        //여기서는 couple아이디를 기반으로 커플이 원하는 날짜에 있는 date날짜에 맞는 transaction 리스트를 뽑아와야한다.
        //
//        List<Transaction> transactionList = transactionService.findTransactionsDetail(date, accountService.findAccountByAccountNumber(couple.getCommonAccount()));
        //여기서는 커플id값을 기반으로
        return new ListResponseResult<Transaction>(transactionList);


    }
//    @PostMapping("")

    @Operation(summary = "커플 D-DAY 조회", description = "사용자의 커플 D-DAY 조회합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "커플 D-DAY 조회 성공")
    })
    @GetMapping("/anniversary/{coupleId}")
    public ResponseResult getCoupleAnniversary(@PathVariable(value = "coupleId") Long coupleId){
        log.info("CoupleController -> 커플 통장 정보 조회 ");
        return new SingleResponseResult<>(coupleService.getCoupleAnniversary(coupleId));
    }

    @PostMapping("/wire/{userId}")
    public ResponseResult sendAmount(@PathVariable int userId, @RequestBody @Valid SendCoupleAmountRequestDto requestDto){

//        return Res
        return ResponseResult.successResponse;
    }

    @Operation(summary = "커플 D-DAY 설정", description = "사용자의 커플 D-DAY 설정합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "커플 D-DAY 설정 성공")
    })
    @PostMapping("/dday")
    public ResponseResult registDDAY(@Valid @RequestBody DDayRequestDto dDayRequestDto){
        log.info("CoupleController_registDDAY -> 커플 D-DAY 설정");
        return new SingleResponseResult<>(coupleService.registDDay(dDayRequestDto));
    }

    @Operation(summary = "커플 커스텀 설정 D-DAY 조회", description = "사용자의 커플 커스텀 설정 D-DAY 조회 합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "커플 커스텀 설정 D-DAY 조회 성공")
    })
    @PostMapping("/dday/{coupleId}")
    public ResponseResult getDDay(@PathVariable(value = "coupleId") Long coupleId){
        log.info("CoupleController_getDDay -> 커플 커스텀 설정 D-DAY 조회");
        return new SingleResponseResult<>(coupleService.getDDay(coupleId));
    }


}
