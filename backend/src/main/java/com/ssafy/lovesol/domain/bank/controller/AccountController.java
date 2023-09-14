package com.ssafy.lovesol.domain.bank.controller;

import com.ssafy.lovesol.domain.bank.dto.request.TransferRequestDto;
import com.ssafy.lovesol.domain.bank.dto.request.TransferAuthRequestDto;
import com.ssafy.lovesol.domain.bank.dto.response.GetUserAccountsResponseDto;
import com.ssafy.lovesol.domain.bank.entity.Transaction;
import com.ssafy.lovesol.domain.bank.service.AccountService;
import com.ssafy.lovesol.domain.bank.service.TransactionService;
import com.ssafy.lovesol.global.response.ListResponseResult;
import com.ssafy.lovesol.global.response.ResponseResult;
import com.ssafy.lovesol.global.response.SingleResponseResult;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.nurigo.java_sdk.exceptions.CoolsmsException;
import org.springframework.web.bind.annotation.*;

import java.security.NoSuchAlgorithmException;
import java.util.List;

@ApiResponses({
        @ApiResponse(responseCode = "200", description = "응답이 성공적으로 반환되었습니다."),
        @ApiResponse(responseCode = "400", description = "응답이 실패하였습니다.",
                content = @Content(schema = @Schema(implementation = ResponseResult.class)))})
@Tag(name = "Account Controller", description = "계좌 컨트롤러")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/api/account")
public class AccountController {

    private final AccountService accountService;
    private final TransactionService transactionService;

    @Operation(summary = "1Won Transfer", description = "입력한 계좌번호로 1원 이체를 합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "1원이체 성공")
    })
    @PostMapping
    public ResponseResult transferOneWon(
            @Valid @RequestBody TransferRequestDto transferRequestDto) throws CoolsmsException {
        log.info("AccountController_transferOneWon");
        return new SingleResponseResult<>(accountService.transferOneWon(transferRequestDto));
    }

    @Operation(summary = "1Won Transfer Auth", description = "1원이체 인증번호 인증")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "1원이체 인증번호 인증 성공")
    })
    @PostMapping("/auth")
    public ResponseResult transferOneWonAuth(
            @Valid @RequestBody TransferAuthRequestDto transferAuthRequestDto) {
        log.info("AccountController_transferOneWonAuth");
        if(accountService.transferOneWonAuth(transferAuthRequestDto))
            return ResponseResult.successResponse;
        return ResponseResult.failResponse;
    }

    @GetMapping("/{userId}")
    public ResponseResult getMyAccounts(@Valid @PathVariable Long userId) throws NoSuchAlgorithmException {
        return new SingleResponseResult<>(accountService.getMyAccounts(userId,0));
    }

    @GetMapping("/couple/{userId}")
    public ResponseResult getMyLoveBox(@Valid @PathVariable Long userId) throws NoSuchAlgorithmException {
        return new SingleResponseResult<>(accountService.getMyAccounts(userId,1));
    }

    @GetMapping("/transaction/{coupleId}")
    public ResponseResult getMyTransaction(@Valid @PathVariable Long coupleId) {
        return new SingleResponseResult<Integer>(transactionService.findTransactionOne(coupleId));
    }

    @GetMapping("/transaction/{accountNumber}/{idx}")
        public ResponseResult getTransactionList(@PathVariable(name = "accountNumber") String accountNumber , @PathVariable(name = "idx") int idx) {
        return new ListResponseResult<>(transactionService.getTransactionList(accountNumber,idx));
    }

    @GetMapping("/transaction/category/{accountNumber}")
    public ResponseResult getTransactionListByCategory(@PathVariable(name = "accountNumber") String accountNumber , @RequestParam(name = "year") int year , @RequestParam(name = "month") int month) {
        return new ListResponseResult<>(transactionService.getTransactionListByCategory(accountNumber, year, month));
    }

}
