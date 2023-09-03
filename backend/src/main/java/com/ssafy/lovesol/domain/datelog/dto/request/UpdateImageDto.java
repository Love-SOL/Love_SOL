package com.ssafy.lovesol.domain.datelog.dto.request;

import com.ssafy.lovesol.domain.datelog.entity.Image;
import com.ssafy.lovesol.domain.user.entity.User;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "이미지 변경 요청 DTO")
public class UpdateImageDto {

    @NotBlank
    @Schema(description = "이미지 ID")
    private Long imageId;
    @NotBlank
    @Schema(description = "이미지 URL")
    private String imgUrl;

    @NotBlank
    @Schema(description = "이미지 내용", example = "변경된 이미지 내용입니다.")
    private String content;

    public Image toEntity(){
        return Image.builder()
                .imageId(imageId)
                .imgUrl(imgUrl)
                .content(content)
                .build();
    }
}
