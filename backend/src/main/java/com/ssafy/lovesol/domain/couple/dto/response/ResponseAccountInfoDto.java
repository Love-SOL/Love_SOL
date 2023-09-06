package com.ssafy.lovesol.domain.couple.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Schema(description = "곚 DTO")
public class ResponseAccountInfoDto {

    private Long coupleId;
    private String coupleAccount;
    private int Total;
}
