package com.ssafy.lovesol.domain.couple.controller;

import com.ssafy.lovesol.domain.couple.dto.request.ConnectCoupleRequestDto;
import com.ssafy.lovesol.domain.couple.dto.request.CoupleCreateRequestDto;
import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.service.CoupleService;
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

import java.util.HashMap;
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

    @Operation(summary = "Couple info", description = "사용자의 커플 정보를 조회합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "커플 테이블 조회 성공")
    })
    @GetMapping("/{userId}")
    public SingleResponseResult<Couple> getCoupleInfo(@PathVariable String userId){
        log.info("CoupleController -> 커플 통장 정보 조회 ");
        Couple couple = coupleService.getCoupleInfoByCoupleId(userId);
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
       return CommonHttpSend.autoDeposit(data, "/search/fxrate/number");

    }

//    @PostMapping("")

}
