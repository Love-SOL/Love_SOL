package com.ssafy.lovesol.domain.datelog.service;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.datelog.dto.request.InsertImageDto;
import com.ssafy.lovesol.domain.datelog.dto.response.DateLogForCalenderResponseDto;
import com.ssafy.lovesol.domain.datelog.dto.response.DateLogResponseDto;
import com.ssafy.lovesol.domain.datelog.dto.response.ImageResponseDto;
import com.ssafy.lovesol.domain.datelog.entity.DateLog;
import com.ssafy.lovesol.domain.datelog.entity.Image;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface DateLogService {
    Long createDateLog(Long coupleId, LocalDate dateAt);

    DateLogResponseDto getDateLog(Long dateLogId);
    Optional<DateLog> getDateLogforScheduler(Couple couple,LocalDate curDay);
    void insertImage(Long dateLogId, MultipartFile insertImage, String content) throws IOException;
    void updateDateLog(DateLog dateLog);
    DateLog getDateLogForupdate(Long dateLogId);
    List<DateLogForCalenderResponseDto> getDateLogList(Long coupleId, int year,int month);

    List<ImageResponseDto> getAllImage(Long coupleId);

    public Couple getDatelogCouple(Long dateLogId);
}
