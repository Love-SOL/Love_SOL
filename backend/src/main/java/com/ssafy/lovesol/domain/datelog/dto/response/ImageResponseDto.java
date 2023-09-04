package com.ssafy.lovesol.domain.datelog.dto.response;

import com.ssafy.lovesol.domain.datelog.entity.Comment;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "데이트 일기의 이미지 정보 반환 DTO")
public class ImageResponseDto {
    @Schema(description = "이미지 ID", example = "1")
    private Long imageId;
    @Schema(description = "이미지 URL", example = "www.shinhan.com")
    private String imgUrl;
    @Schema(description = "이미지 내용", example = "신한 해커톤 1등하자!")
    private String content;
    @Schema(description = "이미지 생성 날짜", example = "2023-06-23")
    private LocalDateTime createAt;
    @Schema(description = "데이트 일기 이미지 목록")
    private List<CommentResponseDto> commentList;
}
