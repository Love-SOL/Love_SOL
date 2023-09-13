package com.ssafy.lovesol.global.fcm.dto.request;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FcmRequestDto {
    private long targetId;
    private String title;
    private String body;

}
