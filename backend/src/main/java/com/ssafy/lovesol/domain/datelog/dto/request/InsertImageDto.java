package com.ssafy.lovesol.domain.datelog.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "이미지 삽입 요청 DTO")
public class InsertImageDto {
    @NotBlank
    @Schema(description = "이미지 파일")
    private MultipartFile imageFile;


    @NotBlank
    @Schema(description = "이미지 내용", example = "작성할 이미지 내용입니다.")
    private String content;

}
