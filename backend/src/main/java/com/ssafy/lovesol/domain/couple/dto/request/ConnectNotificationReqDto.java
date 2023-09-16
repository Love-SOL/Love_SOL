package com.ssafy.lovesol.domain.couple.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "커플 연결 알림 객체")
public class ConnectNotificationReqDto {

    @Schema(description = "커플 owner Long타입 ID")
    private long senderId;

    @NotNull
    @Schema(description = "커플 subonwer의  String타입 Id")
    private String receiverId;

    @NotNull
    @Schema(description = "기념일",example = "2020-02-02")
    private LocalDate anniversary;


    @Schema(description = "일수 xx일")
    private int day;
    @Schema(description = "금액 단위 원")
    private int amount;
}
