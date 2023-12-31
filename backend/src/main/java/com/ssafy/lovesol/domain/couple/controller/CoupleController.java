package com.ssafy.lovesol.domain.couple.controller;

import com.ssafy.lovesol.domain.bank.entity.Account;
import com.ssafy.lovesol.domain.bank.entity.Transaction;
import com.ssafy.lovesol.domain.bank.service.AccountService;
import com.ssafy.lovesol.domain.bank.service.TransactionService;
import com.ssafy.lovesol.domain.couple.dto.request.*;
import com.ssafy.lovesol.domain.couple.dto.response.ResponseAccountInfoDto;
import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.service.CoupleService;
import com.ssafy.lovesol.domain.couple.service.PetService;
import com.ssafy.lovesol.domain.datelog.entity.DateLog;
import com.ssafy.lovesol.domain.datelog.service.DateLogService;
import com.ssafy.lovesol.domain.user.dto.request.UpdateUserAccountInfoDto;
import com.ssafy.lovesol.domain.user.entity.User;
import com.ssafy.lovesol.domain.user.service.NoticeService;
import com.ssafy.lovesol.domain.user.service.UserService;
import com.ssafy.lovesol.global.fcm.Service.FCMNotificationService;
import com.ssafy.lovesol.global.fcm.dto.request.FcmRequestDto;
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
import jakarta.validation.constraints.NotBlank;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import java.security.NoSuchAlgorithmException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

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
    private final UserService userService;
    private final FCMNotificationService fcmNotificationService;
    private final NoticeService noticeService;
    private final PetService petService;
    private final DateLogService dateLogService;
    @Operation(summary = "Couple info", description = "사용자의 커플 정보를 조회합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "커플 테이블 조회 성공")
    })
    @GetMapping("/{userId}")
    public SingleResponseResult<Couple> getCoupleInfo(@PathVariable String userId){
        log.info("CoupleController -> 커플 통장 정보 조회 ");
        Couple couple = coupleService.getCoupleInfoByUserId(userId);
        return new SingleResponseResult<>(couple);
    }


    @Operation(summary = "Couple Create", description = "사용자가 커플 통장을 생성합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "커플 통장 생성 성공")
    })
    @PostMapping("")
    public ResponseResult createCoupleinfo(@RequestBody @Valid CoupleCreateRequestDto coupleCreateRequestDto) {
        log.info("CoupleController -> 커플 객체 초기 생성 ");
        if(coupleService.createCouple(coupleCreateRequestDto) <= 0) return ResponseResult.failResponse;

        return ResponseResult.successResponse;
    }

    @Operation(summary = "Couple connection", description = "사용자가 커플 연결을 신청합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "알림 전송 선공 :)")
    })
    @PostMapping("/connect")
    public ResponseResult sendconnection(@RequestBody @Valid ConnectNotificationReqDto connectNotificationReqDto)
    {

        //여기서 커플 객채를 만들어줘야한다.
        String titleInit= "커플 통장 초대장이 왔어요!";
        int kind = 0;
        log.info("CoupleController -> 커플 연결 신청 알람 전송");
        User sender = userService.getUserByUserId(connectNotificationReqDto.getSenderId());
        User receiver = userService.getUserById(connectNotificationReqDto.getReceiverId());

        String bodyInit= sender.getName()+"님이 커플 통장에 초대했어요";
        sender.setAmount(connectNotificationReqDto.getAmount());
        sender.setDepositAt(connectNotificationReqDto.getDay());

        Couple couple = coupleService.getCoupleInfoByUserId(sender.getId());

        if(couple.getSubOwner() ==null){
            couple.setAnniversary(connectNotificationReqDto.getAnniversary());
            noticeService.registNotice(sender,receiver,titleInit,bodyInit,kind);
            coupleService.saveCouple(couple);
        }
        Map<String, String> data = new HashMap<>();
        data.put("kind",Integer.toString(kind));
        data.put("senderId",Long.toString(sender.getUserId()));
        data.put("receiverId", connectNotificationReqDto.getReceiverId());
        data.put("coupleId", Long.toString(couple.getCoupleId()));
        if(!fcmNotificationService.sendNotificationByToken(FcmRequestDto.builder().targetId(sender.getUserId()).title(titleInit).body(bodyInit).build(),data)) return ResponseResult.failResponse;
        return ResponseResult.successResponse;
    }

    @Operation(summary = "Couple connection step x", description = "사용자가 커플 연결을 신청합니다." )
    @PostMapping("/share/{ownerId}")
    public ResponseResult connectCouple(@PathVariable(value = "ownerId") long ownerId,@RequestBody @Valid ConnectCoupleRequestDto coupleRequestDto) throws NoSuchAlgorithmException {
        log.info("CoupleController -> 커플 통장 연결 유무 처리 ");
        if(!coupleService.connectCouple(coupleRequestDto,ownerId)){
            return ResponseResult.failResponse;
        }

        User subOwner = userService.getUserById(coupleRequestDto.getSubOnwerId());
        User owner = userService.getUserByUserId(ownerId);

        userService.UpdateDepositInfo(UpdateUserAccountInfoDto.builder().depositAt(owner.getDepositAt()).amount(owner.getAmount()).id(subOwner.getId()).build());

        return ResponseResult.successResponse;
    }


    @PostMapping("/farewall/{coupleId}")
    public ResponseResult farewallCouple(@PathVariable long coupleId) {
        log.info("CoupleController -> 커플 통장 정산하기");
        if(!coupleService.cutCouple(coupleId)){
            return ResponseResult.failResponse;
        }
        return ResponseResult.successResponse;
    }

    @GetMapping("/{coupleId}/balance")
    public SingleResponseResult<ResponseAccountInfoDto> accountTotalInfo(@PathVariable long coupleId){
        ResponseAccountInfoDto dto = coupleService.getAccountTotal(coupleId);
        return new SingleResponseResult<ResponseAccountInfoDto>(dto);
    }

    @GetMapping("/{coupleId}/detail/{date}")
    public ListResponseResult<Transaction> accountDetail(@PathVariable long coupleId , @PathVariable LocalDate date){
        Couple couple = coupleService.getCoupleInfoByCouplId(coupleId);
        Account account = accountService.findAccountByAccountNumber(couple.getCommonAccount());
        LocalDateTime infoAt = date.atStartOfDay();
        List<Transaction> transactionList = transactionService.findTransactionsDetailOrderBy(infoAt,account);
        return new ListResponseResult<Transaction>(transactionList);


    }

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
    public ResponseResult sendAmount(@PathVariable long userId, @RequestBody @Valid SendCoupleAmountRequestDto requestDto){
        LocalDateTime current = LocalDateTime.now();
        User user = userService.getUserByUserId(userId);
        Couple couple = coupleService.getCoupleInfoByCouplId(requestDto.getCouplId());
        transactionService.registTransactionInfo(Transaction.builder()
                        .branchName("기타")
                        .transactionAt(current)
                        .depositAmount(0)
                        .content("LoveSol")
                        .withdrawalAmount(requestDto.getAmount())
                        .account(accountService.findAccountByAccountNumber(user.getPersonalAccount()))
                .build());

        transactionService.registTransactionInfo(Transaction.builder()
                .branchName("기타")
                .transactionAt(current)
                .depositAmount(requestDto.getAmount())
                .content("LoveSol")
                .withdrawalAmount(0)
                .account(accountService.findAccountByAccountNumber(couple.getCommonAccount()))
                .build());
        Account personAccount = accountService.findAccountByAccountNumber(user.getPersonalAccount());
        Account coupleAccount = accountService.findAccountByAccountNumber(couple.getCommonAccount());
        personAccount.setBalance(personAccount.getBalance()- requestDto.getAmount());
        coupleAccount.setBalance(coupleAccount.getBalance()+requestDto.getAmount());
        accountService.accountSave(personAccount);
        accountService.accountSave(coupleAccount);
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
    @GetMapping("/dday/{coupleId}")
    public ResponseResult getDDay(@PathVariable(value = "coupleId") Long coupleId){
        log.info("CoupleController_getDDay -> 커플 커스텀 설정 D-DAY 조회");
        return new SingleResponseResult<>(coupleService.getDDay(coupleId));
    }

    @PostMapping("/refresh/{coupleId}")
    public ResponseResult refreshTransaction(@PathVariable(value = "coupleId") @Valid long couplId){
        Couple couple = coupleService.getCoupleInfoByCouplId(couplId);
        //여기서 결재 내역 조회한다.
        Map<String,String> data = new HashMap<>();
        data.put("계좌번호",couple.getCommonAccount());
        //계좌번호로 결재 내역 조회
        ResponseEntity<String> response = commonHttpSend.shinhanAPI(data,"/search/transaction");
        JSONObject result = new JSONObject(response.getBody());
        //실제 결재내역을 정상적으로 받은 경우
        int successCode = result.getJSONObject("dataHeader").getInt("successCode");
        if(successCode!=0){
            log.info("계좌 내역 조회에 실패했습니다.");
            return ResponseResult.failResponse;
        }
        LocalDateTime current = LocalDate.now().atStartOfDay();
        Account coupleAccount = accountService.findAccountByAccountNumber(couple.getCommonAccount());
        List<Transaction> transactionList = transactionService.findTransactionsDetail(current,coupleAccount);
        LocalDate curDay = current.toLocalDate();
        //계좌 내역을 가져올때 출금만 가져와야하는데 여깃 출입금 둘다 가져왔음
        //1. query를 수정한다
        //2. 스켘줄러에서 처리해준다.
        if(transactionList == null || transactionList.isEmpty()){
            log.info("데이트 일정이 없음!");
            return ResponseResult.successResponse;}
        Optional<DateLog> dateLogFind = dateLogService.getDateLogforScheduler(couple,curDay);
        DateLog dateLog;

        dateLog = dateLogFind.orElseGet(() -> dateLogService.getDateLogForupdate(dateLogService.createDateLog(couple.getCoupleId(), curDay)));
        int total = 0;
        for(int j = 0 ; j < transactionList.size();j++) {
            total += (int) (transactionList.get(j).getWithdrawalAmount() * 0.01);
        }
        dateLog.setMileage(total);
        dateLogService.updateDateLog(dateLog);
        if(couple.getPet()!=  null){petService.gainExp(couple.getCoupleId(), total);
            if(couple.getPet().getLevel()<3){
                couple.getPet().levelUp();
            }
            petService.updatePet(couple.getPet());
        }

        return ResponseResult.successResponse;
    }

}
