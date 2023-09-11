package com.ssafy.lovesol.domain.user.dto.response;


import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;
import org.springframework.web.bind.annotation.RequestBody;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "샘플 반환 DTO")
public class NoticeResDto {

    private int kind;
    private String title;
    private String body;
    private LocalDateTime createAt;
    private String SenderName;

}
