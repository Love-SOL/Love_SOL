package com.ssafy.lovesol.domain.datelog.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

import java.time.LocalDateTime;

public class CommentResponseDto {
    @Schema(description = "댓글 내용", example = "신한 해커톤 우승하자")
    private String content;
    @Schema(description = "댓글 작성 날짜", example = "2023-09-04T15:30:00.123")
    private LocalDateTime createAt;
}
