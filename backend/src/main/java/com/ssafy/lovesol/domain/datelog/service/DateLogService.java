package com.ssafy.lovesol.domain.datelog.service;

import com.ssafy.lovesol.domain.datelog.dto.request.InsertImageDto;
import com.ssafy.lovesol.domain.datelog.entity.DateLog;
import com.ssafy.lovesol.domain.datelog.entity.Image;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Optional;

public interface DateLogService {
    Long createDateLog(Long coupleId, LocalDate dateAt);

    DateLog getDateLog(Long dateLogId);

    void insertImage(Long dateLogId, InsertImageDto insertImage);
}
