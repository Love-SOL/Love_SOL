package com.ssafy.lovesol.domain.datelog.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "댓글 정보 반환 DTO")
public class CommentResponseDto {
    @Schema(description = "댓글 ID", example = "1")
    private Long commentId;
    @Schema(description = "댓글 내용", example = "신한 해커톤 우승하자")
    private String content;
    @Schema(description = "댓글 작성 날짜", example = "2023-09-04T15:30:00.123")
    private LocalDateTime createAt;
    @Schema(description = "댓글 작성자 고유번호", example = "1")
    private Long userId;
    @Schema(description = "댓글 작성자 ID", example = "shinhan")
    private String id;
}
