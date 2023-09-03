package com.ssafy.lovesol.domain.datelog.dto.request;

import com.ssafy.lovesol.domain.datelog.entity.Image;
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
@Schema(description = "이미지 삽입 요청 DTO")
public class InsertImageDto {
    @NotBlank
    @Schema(description = "이미지 URL")
    private String imgUrl;

    @NotBlank
    @Schema(description = "이미지 내용", example = "변경된 이미지 내용입니다.")
    private String content;

    public Image toEntity(){
        return Image.builder()
                .imgUrl(imgUrl)
                .content(content)
                .build();
    }
}
