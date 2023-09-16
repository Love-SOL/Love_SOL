package com.ssafy.lovesol.domain.datelog.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.ssafy.lovesol.domain.bank.entity.Transaction;
import com.ssafy.lovesol.domain.bank.repository.TransactionRepository;
import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.repository.CoupleRepository;
import com.ssafy.lovesol.domain.datelog.dto.request.InsertImageDto;
import com.ssafy.lovesol.domain.datelog.dto.response.DateLogForCalenderResponseDto;
import com.ssafy.lovesol.domain.datelog.dto.response.DateLogResponseDto;
import com.ssafy.lovesol.domain.datelog.dto.response.ImageResponseDto;
import com.ssafy.lovesol.domain.datelog.entity.DateLog;
import com.ssafy.lovesol.domain.datelog.entity.Image;
import com.ssafy.lovesol.domain.datelog.repository.DateLogRepository;
import com.ssafy.lovesol.global.exception.NotExistCoupleException;
import com.ssafy.lovesol.global.exception.NotExistDateLogException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@Service
public class DateLogServiceImpl implements DateLogService{
    private final AmazonS3 amazonS3;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;
    final private DateLogRepository dateLogRepository;
    final private CoupleRepository coupleRepository;
    final private TransactionRepository transactionRepository;

    @Override
    public Long createDateLog(Long coupleId, LocalDate dateAt) {
        // 커플 정보가 존재하는지 검사한다.
        Couple couple = coupleRepository.findById(coupleId).orElseThrow(NotExistCoupleException::new);
        // 커플 객체와 날짜를 dateLog에 삽입한다.
        DateLog dateLog = DateLog.create(couple, dateAt);
        return dateLogRepository.save(dateLog).getDateLogId();
    }

    @Override
    public DateLogResponseDto getDateLog(Long dateLogId) {
        // 해당 데이트 일기가 존재하는지 검사한다.
        // 데이트 로그에 속하는 날짜, 적립된 마일리지와 이미지 객체들을 조회한다.
        DateLog dateLog = dateLogRepository.findById(dateLogId).orElseThrow(NotExistDateLogException::new);
        return dateLog.toDateLogResponseDto();
    }

    @Override
    public Optional<DateLog> getDateLogforScheduler(Couple couple,LocalDate curDay) {
        return dateLogRepository.findByCoupleAndDateAt(couple,curDay);
    }

    @Override
    @Transactional
    public void insertImage(Long dateLogId, MultipartFile insertImage, String content) throws IOException {
        // 해당 데이트 일기가 존재하는지 검사한다.
        DateLog dateLog = dateLogRepository.findById(dateLogId).orElseThrow(NotExistDateLogException::new);
        MultipartFile imageFile = insertImage;

        ObjectMetadata objectMetadata = new ObjectMetadata();
        objectMetadata.setContentType(imageFile.getContentType());
        objectMetadata.setContentLength(imageFile.getSize());

        String originalFileName = imageFile.getOriginalFilename();
        int index = originalFileName.lastIndexOf(".");
        String ext = originalFileName.substring(index + 1);

        String storeFileName = UUID.randomUUID() + "." + ext;
        String key = "date-log/" + storeFileName;

        try (InputStream inputStream = imageFile.getInputStream()) {
            amazonS3.putObject(new PutObjectRequest(bucket, key, inputStream, objectMetadata)
                    .withCannedAcl(CannedAccessControlList.PublicRead));
        }

        String storeFileUrl = amazonS3.getUrl(bucket, key).toString();

        // 데이트 로그, 이미지 url, 이미지 내용, 현재 작성된 시간을 가진 이미지 객체 생성
        Image image = Image.create(dateLog, storeFileUrl, content, LocalDateTime.now());
        // 데이트 일기에 이미지를 삽입한다.
        dateLog.getImageList().add(image);
        // 데이트 일기에마일리지(exp)를 적립한다.
        dateLog.accumulateMileage(10);
        // TODO: 펫에게 마일리지를 적립한다.
    }

    @Override
    public void updateDateLog(DateLog dateLog) {
        dateLogRepository.save(dateLog);
    }


    @Override
    public DateLog getDateLogForupdate(Long dateLogId) {
        return dateLogRepository.findById(dateLogId).get();
    }

    @Override
    public List<DateLogForCalenderResponseDto> getDateLogList(Long coupleId, int year, int month) {
        log.info("DateLogServiceImpl_getDateLogList || 데이트 일기 조회");
        String commonAccount = coupleRepository.findById(coupleId).get().getCommonAccount();
        List<DateLogForCalenderResponseDto> dateLogForCalenderResponseDtoArrayList = new ArrayList<>();

        for (DateLog dateLog : dateLogRepository.findAllByCoupleIdAndYearAndMonth(coupleId, year, month)) {
            LocalDateTime dateAt = dateLog.getDateAt().atStartOfDay();
            LocalDateTime endAt = dateLog.getDateAt().atTime(LocalTime.MAX);

            System.out.println("dateAt = " + dateAt);
            System.out.println("endAt = " + endAt);

            List<Transaction> transactionList = transactionRepository.findByAccountAccountNumberAndTransactionAtBetweenAndTransactionType(commonAccount, dateAt, endAt , 0);
            int totalAmount = 0;
            for (Transaction transaction : transactionList) {
                totalAmount += transaction.getWithdrawalAmount();
            }
            if(totalAmount == 0) continue;

            dateLogForCalenderResponseDtoArrayList.add(dateLog.toDateLogForCalenderResponseDto(totalAmount));
        }

        return dateLogForCalenderResponseDtoArrayList;
    }

    @Override
    public List<ImageResponseDto> getAllImage(Long coupleId) {
        Couple couple = coupleRepository.findById(coupleId).orElseThrow(NotExistCoupleException::new);
        List<DateLog> dateLogList = dateLogRepository.findByCouple(couple);
        List<ImageResponseDto> imageList = new ArrayList<>();
        for (DateLog dateLog : dateLogList) {
            List<Image> images = dateLog.getImageList();
            for (Image image : images) {
                imageList.add(image.toImageResponseDto());
            }
        }
        return imageList;
    }
}
