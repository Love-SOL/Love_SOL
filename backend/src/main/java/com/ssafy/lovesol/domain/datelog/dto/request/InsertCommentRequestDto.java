package com.ssafy.lovesol.domain.datelog.dto.request;

import com.ssafy.lovesol.domain.datelog.entity.Comment;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "댓글 작성 요청 DTO")
public class InsertCommentRequestDto {
    @NotBlank
    @Schema(description = "댓글 내용", example = "작성할 댓글 내용입니다.")
    private String content;

    public Comment toEntity() {
        return Comment.builder()
                .content(content)
                .build();
    }
}
