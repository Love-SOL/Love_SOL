package com.ssafy.lovesol.domain.datelog.service;

import com.ssafy.lovesol.domain.datelog.dto.request.InsertCommentRequestDto;
import com.ssafy.lovesol.domain.datelog.dto.request.UpdateCommentRequestDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

public interface CommentService {
    void writeComment(Long imageId, InsertCommentRequestDto insertCommentRequestDto);

    void modifyComment(UpdateCommentRequestDto updateCommentRequestDto);
}
