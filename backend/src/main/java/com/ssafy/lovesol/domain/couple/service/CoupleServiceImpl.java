package com.ssafy.lovesol.domain.couple.service;

import com.ssafy.lovesol.domain.bank.entity.Account;
import com.ssafy.lovesol.domain.bank.entity.Transaction;
import com.ssafy.lovesol.domain.bank.repository.AccountRepository;
import com.ssafy.lovesol.domain.bank.service.AccountService;
import com.ssafy.lovesol.domain.bank.service.AccountServiceImpl;
import com.ssafy.lovesol.domain.bank.service.TransactionService;
import com.ssafy.lovesol.domain.couple.dto.request.ConnectCoupleRequestDto;
import com.ssafy.lovesol.domain.couple.dto.request.CoupleCreateRequestDto;
import com.ssafy.lovesol.domain.couple.dto.request.DDayRequestDto;
import com.ssafy.lovesol.domain.couple.dto.response.DDayResponseDto;
import com.ssafy.lovesol.domain.couple.dto.response.ResponseAccountInfoDto;
import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.repository.CoupleRepository;
import com.ssafy.lovesol.domain.user.entity.User;
import com.ssafy.lovesol.domain.user.service.UserService;
import com.ssafy.lovesol.global.exception.NotExistCoupleException;
import com.ssafy.lovesol.global.util.CommonHttpSend;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONObject;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.NoSuchAlgorithmException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;

@Slf4j
@RequiredArgsConstructor
@Service
public class CoupleServiceImpl implements CoupleService{
    private final CoupleRepository coupleRepository;
    private final UserService userService;
    private final CommonHttpSend commonHttpSend;
    private final AccountRepository accountRepository;
    private final AccountService accountService;
    private final TransactionService transactionService;
    @Override
    public long createCouple(CoupleCreateRequestDto coupleDto) {
        log.info("후보2");
        User user = userService.getUserByUserId(coupleDto.getId());
        log.info("후보1");
        if(user == null) return -1;
//        log.info("커플통장 생성 전 owner 객체 " + user.toString());
        Couple couple = coupleDto.toEntity(user);
//        log.info(couple.toString());
        return coupleRepository.save(couple).getCoupleId();

    }


    @Override
    public String getCoupleInfo(long userId) {
        log.info("getCoupleInfo : 커플 계좌 정보 도출");
        User user = userService.getUserByUserId(userId);
        Optional<Couple> couple = coupleRepository.findBySubOwner(user);
        if(!couple.isEmpty()){
            return couple.get().getCommonAccount();
        }
        couple = coupleRepository.findByOwner(user);
        if(!couple.isEmpty()){
            return couple.get().getCommonAccount();
        }
        return "";
    }

    @Override
//    @Transactional
    public boolean cutCouple(long coupleId) {
        Couple couple = coupleRepository.findById(coupleId).get();
        Account commonAccount = accountRepository.findByAccountNumber(couple.getCommonAccount()).get();
        //여기서부터는 이제 공통 계좌와 돈 나눠주는거임
        User owner = couple.getOwner();
        User subOwner = couple.getSubOwner();
        double total =  couple.getSubOwnerTotal() + couple.getSubOwnerTotal();
        double ownerPer = Math.round((couple.getOwnerTotal()/total)*1000)/1000.0;
        log.info(Double.toString(total));
        double ownerGet = Math.round(commonAccount.getBalance()*ownerPer);

        double subOwnerGet = commonAccount.getBalance() - ownerGet;
        log.info(Double.toString(subOwnerGet)+ " " + Double.toString(ownerPer));
        Account ownerAccount = accountRepository.findByAccountNumber(owner.getPersonalAccount()).get();
        Account subOwnerAccount = accountRepository.findByAccountNumber(subOwner.getPersonalAccount()).get();

        HashMap<String,String> data = new HashMap<>();
        data.put("출금계좌번호",couple.getCommonAccount());
        data.put("입금은행코드","088");
        data.put("입금계좌번호", owner.getPersonalAccount());
        data.put("이체금액",Integer.toString((int)ownerGet));
        data.put("입금계좌통장메모","LoveSol");
        data.put("출금계좌통장메모","LoveSol");

        ResponseEntity<String> response = commonHttpSend.shinhanAPI(data,"/transfer/krw");
        JSONObject result = new JSONObject(response.getBody());
//        int successCode = result.getJSONObject("dataHeader").getInt("successCode");
//        log.info(Integer.toString(successCode));
//        if(successCode != 0 ){
//            log.info("입금을 실패 했습니다.");
//            //여기서 notice를 추가해주자.
//            return false;
//        }
        log.info(Double.toString(ownerAccount.getBalance()+ownerGet));
        ownerAccount.setBalance(ownerAccount.getBalance()+ownerGet);

        LocalDateTime now = LocalDateTime.now();
        Transaction withdrawal = Transaction.builder()
                .transactionAt(now)
                .depositAmount(ownerGet)
                .withdrawalAmount(0)
                .content("LoveSol")
                .branchName("LoveSol 자동이체 출금")
                .account(ownerAccount)
                .build();
        transactionService.registTransactionInfo(withdrawal);

        //subowner 입금해주기
        data = new HashMap<>();
        data.put("출금계좌번호",couple.getCommonAccount());
        data.put("입금은행코드","088");
        data.put("입금계좌번호", subOwner.getPersonalAccount());
        data.put("이체금액",Integer.toString((int)subOwnerGet));
        data.put("입금계좌통장메모","LoveSol");
        data.put("출금계좌통장메모","LoveSol");

        response = commonHttpSend.shinhanAPI(data,"/transfer/krw");
        result = new JSONObject(response.getBody());
//        successCode = result.getJSONObject("dataHeader").getInt("successCode");
//        if(successCode != 0 ){
//            log.info("입금을 실패 했습니다.");
//            //여기서 notice를 추가해주자.
//            return false;
//        }
        log.info(Double.toString(subOwnerAccount.getBalance()+subOwnerGet));
        subOwnerAccount.setBalance(subOwnerAccount.getBalance()+subOwnerGet);

        withdrawal = Transaction.builder()
                .transactionAt(now)
                .depositAmount(ownerGet)
                .withdrawalAmount(0)
                .content("LoveSol")
                .branchName("LoveSol 자동이체 출금")
                .account(subOwnerAccount)
                .build();
        transactionService.registTransactionInfo(withdrawal);

        //이제부터 여기서 해야하는 거는

        coupleRepository.delete(couple);
        accountRepository.delete(commonAccount);

        return true;
    }

    @Override
    public Couple getCoupleInfoByUserId(String userId) {
        log.info("getCoupleInfo : 커플 정보 return");
        User user = userService.getUserById(userId);
        Optional<Couple> couple = coupleRepository.findBySubOwner(user);
        if(!couple.isEmpty()){
            return couple.get();
        }
        couple = coupleRepository.findByOwner(user);
        if(!couple.isEmpty()){
            return couple.get();
        }
        return null;
    }

    @Override
    public Couple getCoupleInfoByCouplId(long coupleId) {
        return coupleRepository.findById(coupleId).orElseGet(null);
    }

    @Override
    public boolean connectCouple(ConnectCoupleRequestDto coupleDto, long ownerId) throws NoSuchAlgorithmException {
        Optional<Couple> coupleOption = coupleRepository.findByOwner(userService.getUserByUserId(ownerId));
        if(coupleOption.isEmpty()) {
            return false;
            //일단 커플이 없었기때문에 버그가 발생한 부분인데 에러처리는 나중에 해줘야한다.
        }
        Couple couple = coupleOption.get();
        if(coupleDto.getCheck()>0){
            //커플 연결 거절
            log.info("Coupler Service -> 커플 계좌 신청 반려");
            coupleRepository.delete(couple);
            return true;
        }
        if(coupleDto.getCheck()==0){
            //여기서 러브박스 생성해주고 할당
            User owner = couple.getOwner();
            User subOwner = userService.getUserById(coupleDto.getSubOnwerId());
            Account loveBox = Account.builder()
                    .name(owner.getName())
                    .accountNumber(owner.getPersonalAccount()+"-1")
                    .balance(0).type(1).bankCode(88).userId(accountService.HashEncrypt(owner.getName()+owner.getPhoneNumber()))
                    .build();

            accountRepository.save(loveBox);

            couple.setSubOwner(subOwner);
            couple.setCommonAccount(loveBox.getAccountNumber());
            return true;
        }
        log.info("connectCouple Error Happen");
        return false;
        //여기는 오류 발생
    }

    @Override
    public ResponseAccountInfoDto getAccountTotal(long coupleId) {
        Optional<Couple> op_couple = coupleRepository.findById(coupleId);
        if(op_couple.isEmpty()) return null;
        Couple couple = op_couple.get();
//          "지불가능잔액":"331551"
        Map<String, String> data = new HashMap<>();
        data.put("출금계좌번호",couple.getCommonAccount());
        ResponseEntity<String> response =  commonHttpSend.shinhanAPI( data,"/account/balance/detail");
        return ResponseAccountInfoDto.builder()
                .coupleId(couple.getCoupleId())
                .coupleAccount(couple.getCommonAccount())
                .build();
    }

    @Override
    public int getCoupleAnniversary(Long coupleId) {
        log.info("CoupleServiceImpl_getCoupleAnniversary | 커플의 D-DAY 계산");
        Couple couple = coupleRepository.findById(coupleId).orElseThrow(NotExistCoupleException::new);
        return (int)ChronoUnit.DAYS.between(couple.getAnniversary(), LocalDate.now()) + 1;
    }

    @Override
    public List<Couple> getAllCouple(){
        return coupleRepository.findAll();
    }

    @Override
    @Transactional
    public DDayResponseDto registDDay(DDayRequestDto dDayRequestDto) {
        log.info("CoupleServiceImpl_registDDay | 커플의 D-DAY 설정");
        Couple couple = coupleRepository.findById(dDayRequestDto.getCoupleId()).get();
        couple.updateDDay(dDayRequestDto.getTitle(), LocalDate.parse(dDayRequestDto.getTargetDay()));
        return couple.toDDayResponseDto((int)ChronoUnit.DAYS.between(LocalDate.now(), LocalDate.parse(dDayRequestDto.getTargetDay())),LocalDate.parse(dDayRequestDto.getTargetDay()));
    }

    @Override
    public DDayResponseDto getDDay(Long coupleId) {
        log.info("CoupleServiceImpl_getDDay | 커플의 커스텀 설정 D-DAY 조회");
        Couple couple = coupleRepository.findById(coupleId).get();
        return couple.toDDayResponseDto((int)ChronoUnit.DAYS.between(LocalDate.now(), couple.getDDay() == null ? LocalDate.now() : couple.getDDay()) , couple.getDDay());
    }

    @Override
    public void saveCouple(Couple couple) {
        coupleRepository.save(couple);
    }
}
