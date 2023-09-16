package com.ssafy.lovesol.domain.bank.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.lovesol.domain.bank.dto.request.TransferRequestDto;
import com.ssafy.lovesol.domain.bank.dto.request.TransferAuthRequestDto;
import com.ssafy.lovesol.domain.bank.dto.request.TransferRequestDto;
import com.ssafy.lovesol.domain.bank.dto.response.GetUserAccountsResponseDto;
import com.ssafy.lovesol.domain.bank.entity.Account;
import com.ssafy.lovesol.domain.bank.entity.Transaction;
import com.ssafy.lovesol.domain.bank.repository.AccountRepository;
import com.ssafy.lovesol.domain.bank.repository.TransactionRepository;
import com.ssafy.lovesol.domain.couple.repository.CoupleRepository;
import com.ssafy.lovesol.domain.user.entity.User;
import com.ssafy.lovesol.domain.user.repository.UserRepository;
import com.ssafy.lovesol.global.exception.NotExistAccountException;
import com.ssafy.lovesol.global.exception.NotExistUserException;
import com.ssafy.lovesol.global.util.CommonHttpSend;
import com.ssafy.lovesol.global.util.SmsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.nurigo.java_sdk.exceptions.CoolsmsException;

import org.json.JSONObject;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@Service
public class AccountServiceImpl implements AccountService{

    private final AccountRepository accountRepository;
    private final TransactionRepository transactionRepository;
    private final CoupleRepository coupleRepository;
    private final UserRepository userRepository;
    private final CommonHttpSend commonHttpSend;
    private final SmsService smsService;
    @Override
    @Transactional
    public int transferOneWon(TransferRequestDto transferRequestDto) throws CoolsmsException {
        log.info("AccountServiceImpl_transferOneWon | 1원 이체 기능");

        String randomSixNumber = smsService.sendAuthKey(transferRequestDto.getPhoneNumber());
        Map<String, String> data = new HashMap<>();
        data.put("입금은행코드","088");
        data.put("입금계좌번호",transferRequestDto.getAccountNumber());
        data.put("입금통장메모",randomSixNumber);
        ResponseEntity<String> response = commonHttpSend.shinhanAPI(data, "/auth/1transfer");

        try {
            // String 형태의 응답 본문을 JsonNode 객체로 변환
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(response.getBody());
            JsonNode successCodeNode = root.path("dataHeader").path("successCode");
            int successCode = successCodeNode.asInt();

            if(successCode == 0){
                Account account = accountRepository.findByAccountNumber(transferRequestDto.getAccountNumber()).orElseThrow();
                account.getTransactionList().add(Transaction.createTransaction(account,randomSixNumber,"SHINHAN",1,0));
            }

        } catch (Exception e) {
            // JSON 변환 중 발생하는 예외 처리
            e.printStackTrace();
        }

        return Integer.valueOf(randomSixNumber);
    }

    @Override
    public boolean transferOneWonAuth(TransferAuthRequestDto transferAuthRequestDto) {
        log.info("AccountServiceImpl_transferOneWonAuth | 1원 이체 인증번호 인증 기능");
        Transaction transaction = transactionRepository.findFirstByAccountAndDepositAmountOrderByTransactionAtDesc(accountRepository.findByAccountNumber(transferAuthRequestDto.getAccountNumber()).get(), 1).get();
        if(!transaction.getContent().equals(transferAuthRequestDto.getAuthNumber()))
            return false;
        return true;
    }



    @Override
    public String HashEncrypt(String hashData) throws NoSuchAlgorithmException {
        // SHA-256 해시 생성
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hashedBytes = digest.digest(hashData.getBytes(StandardCharsets.UTF_8));

        // 바이트 배열을 16진수 문자열로 변환
        StringBuilder builder = new StringBuilder();
        for (byte b : hashedBytes) {
            builder.append(String.format("%02x", b));
        }

        return builder.toString();
    }

    @Override
    public List<GetUserAccountsResponseDto> getMyAccounts(Long userId,int type) throws NoSuchAlgorithmException {

        User user = userRepository.findById(userId).orElseThrow(NotExistUserException::new);
        //여기서는 계좌 목록 조회
        Map<String, String> data = new HashMap<>();
        data.put("실명번호",HashEncrypt(user.getName()+user.getPhoneNumber()));
        ResponseEntity<String> response = commonHttpSend.shinhanAPI(data, "/account");
        // 입력 데이터
        String dataToHash = user.getName() + user.getPhoneNumber();
        String HashedData = HashEncrypt(dataToHash);

        List<Account> accounts = accountRepository.findByUserIdAndType(HashedData,type);
        List<GetUserAccountsResponseDto> res = accounts.stream().map(account -> account.toGetUserAccountsResponseDto()).collect(Collectors.toList());

        return res;
    }

    private String generateSixDigitNumber() {
        Random random = new Random();
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < 6; i++) {
            int digit = random.nextInt(10);  // 0~9 사이의 난수 생성
            sb.append(digit);
        }

        return sb.toString();
    }

    @Override
    public Account findAccountByAccountNumber(String accountNumber) {
        Optional<Account> account = accountRepository.findByAccountNumber(accountNumber);
        Map<String, String> data = new HashMap<>();
        data.put("계좌번호",account.get().getAccountNumber());
        ResponseEntity<String> response = commonHttpSend.shinhanAPI(data, "/account/deposit/detail");
        if(account.isPresent()) return account.get();
        return null;
    }

    @Override
    @Transactional
    public void accountSave(Account account) {
        accountRepository.save(account);
    }

    @Override
    public GetUserAccountsResponseDto getUserMainAccount(Long userId) {
        User user = userRepository.findById(userId).orElseThrow(NotExistUserException::new);
        return accountRepository.findByAccountNumber(user.getPersonalAccount()).get().toGetUserAccountsResponseDto();
    }

    @Override
    public GetUserAccountsResponseDto getAccountInfo(String accountNumber) {
        log.info("AccountServiceImpl_getAccountInfo | 계좌번호 정보 조회");
        HashMap<String,String> data = new HashMap<>();
        data.put("계좌번호","230307000000");

        ResponseEntity<String> response = commonHttpSend.shinhanAPI(data,"/account/deposit/detail");
        JSONObject result = new JSONObject(response.getBody());
        int successCode = result.getJSONObject("dataHeader").getInt("successCode");

        if(successCode == 0 ){
            log.info("계좌 조회 성공");
            return accountRepository.findByAccountNumber(accountNumber).get().toGetUserAccountsResponseDto();
        }

        return null;
    }
}
